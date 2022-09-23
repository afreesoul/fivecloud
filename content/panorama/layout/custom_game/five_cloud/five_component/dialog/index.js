class FiveDialog {

    //构造器，接收传参以及初始化
    constructor(options) {
        this.el = options.el
        this.title = options.title
        this.content = options.content
        this.ok = options.ok
        this.reset = options.reset
        this.defaultValue = options.defaultValue
        this.init();
    }

    init() {
        let _this = this
        let panel = this.el
        panel.BLoadLayout("", false, false)
        panel.BLoadLayout("file://{resources}/layout/custom_game/five_cloud/five_component/dialog/index.xml", false, false)
        panel.FindChildTraverse('FiveDialogTitle').text = this.title
        panel.FindChildTraverse('FiveDialogContentlabel').text = this.content
        panel.FindChildTraverse('ok').SetPanelEvent('onactivate', this.ok)
        if (this.defaultValue == null) {
            panel.FindChildTraverse('reset').style.visibility = "collapse"
        } else {
            panel.FindChildTraverse('reset').SetPanelEvent('onactivate', function() {
                _this.panel.FindChildTraverse('FiveDialogContentErrorlabel').style.visibility = "collapse"
                _this.setInputdefaultValue()
            })
        }
        panel.FindChildTraverse('cancel').SetPanelEvent('onactivate', function() {
            _this.close()
        })
        this.panel = panel
        _this.setInputdefaultValue()
    }

    getinput() {
        return this.panel.FindChildTraverse('FiveDialogInput').text
    }

    setInputdefaultValue() {
        this.panel.FindChildTraverse('FiveDialogInput').text = this.defaultValue
    }

    setErrorInfo(e) {
        this.panel.FindChildTraverse('FiveDialogContentErrorlabel').text = e
        this.panel.FindChildTraverse('FiveDialogContentErrorlabel').style.visibility = "visible"
    }

    open() {
        GameUI.FiveDialog.forEach(element => {
            element.panel.style.visibility = "collapse"
        });
        this.panel.style.visibility = "visible"
        this.panel.FindChildTraverse('FiveDialogInput').SetFocus()
    }

    close() {
        this.panel.FindChildTraverse('FiveDialogContentErrorlabel').style.visibility = "collapse"
        this.panel.style.visibility = "collapse"
        $.DispatchEvent("DOTAShopCancelSearch")
    }

}