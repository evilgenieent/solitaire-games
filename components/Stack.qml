import QtQuick 2.0

Item {
    id: stack
    property bool goDown: false
    property bool goRight: false
    property bool goUpZ: false
    property bool showHidden: true
    property bool transparant: false
    property real cardWidth: width
    property real cardHeight: height
    property Card lastCard: count > 0 ? repeater.itemAt(count - 1) : back
    property bool cardsMoveable: false
    property bool cardsDropable: false

    property int count: repeater.count
    property int cardsVisible: goUpZ ? 3 : count
    property int nrCardsMoveable: count
    property bool onlyUpMoveable: true
    property int _hiddenCards: count+amountWaiting-cardsVisible<0?0:count+amountWaiting-cardsVisible
    property int cardsShown: 0

    property int placeholderSuit: 0
    property int placeholderCard: 0

    property int highlightFrom: -1
    property int amountWaiting: 0

    property alias deck: deck
    property alias decks: deck.decks
    property alias suits: deck.suits
    property alias model: deck.model
    property alias repeater: repeater

    property int cardsSetZ: 0
    property int extraZ: 0
    z: cardsSetZ>0?cardsSetZ + extraZ:0

    objectName: "stack"

    width: childrenRect.width
    height: childrenRect.height

    Deck {
        id: deck
    }

    Card {
        id: back
        outline: true
        width: cardWidth
        height: cardHeight
        z: 0

        moveable: false
        visible: !transparant
        card: placeholderCard
        suit: placeholderSuit
    }

    Repeater {
        id: repeater
        model: deck.model
        delegate: Card {
            id: cardObj
            width: cardWidth
            height: cardHeight
            x: getX(index)
            y: getY(index)
            z: !up && cardToStack?count-index-1:index
            card: thisCard
            suit: thisSuit
            up: thisUp
            highlighted: highlightFrom > -1
                         && index >= highlightFrom ? true : false
            visible: animating ? true : true //Should be getVisible(index)

            moveable: cardsMoveable && (onlyUpMoveable?up:true) && nrCardsMoveable>count-index

            stackIndex: index

            onAfterAnimation: repeater.checkUpCards()
        }
        onItemAdded: {
            amountWaiting--
            checkUpCards()
        }
        onItemRemoved: checkUpCards()

        function checkUpCards() {
            var tmpCardsShown = 0
            for (var iii = 0; iii < count; iii++) {
                if (itemAt(iii) && itemAt(iii).up)
                    tmpCardsShown++
            }
            cardsShown = tmpCardsShown
        }
    }

    function indexOf(item) {
        for (var iii = 0; iii < count; iii++) {
            if (repeater.itemAt(iii) === item)
                return iii
        }
        return
    }

    function getVisible(index) {
        if (index < _hiddenCards)
            return false
        else
            return true
    }

    function getX(index) {
        if(!getVisible(index))
            return 0.0
        if (goUpZ) {
            return (index-_hiddenCards) * cardMarginX / 2
        }
        if (goRight) {
            return (index-_hiddenCards) * cardMarginX * 3
        }
        return 0.0
    }

    function getY(index) {
        if(!getVisible(index))
            return 0.0
        if (goUpZ) {
            return (index-_hiddenCards) * cardMarginY / 4
        }
        if (goDown) {
            return (index-_hiddenCards) * cardMarginY
        }
        return 0
    }

    function mapToItemFromIndex(toStack, index) {
        if(typeof index === 'undefined')
            index = 0
        return stack.mapToItem(toStack, getX(index), getY(index))
    }
}
