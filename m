Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D648450EF10
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 05:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242746AbiDZDPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 23:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiDZDPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 23:15:22 -0400
Received: from mg.sunplus.com (mswedge1.sunplus.com [60.248.182.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87D0374DE2;
        Mon, 25 Apr 2022 20:12:13 -0700 (PDT)
X-MailGates: (compute_score:DELIVER,40,3)
Received: from 172.17.9.202
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(27730:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Tue, 26 Apr 2022 11:03:41 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.26; Tue, 26 Apr 2022 11:03:41 +0800
Received: from sphcmbx02.sunplus.com.tw ([fe80::fd3d:ad1a:de2a:18bd]) by
 sphcmbx02.sunplus.com.tw ([fe80::fd3d:ad1a:de2a:18bd%14]) with mapi id
 15.00.1497.026; Tue, 26 Apr 2022 11:03:40 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Wells Lu <wellslutw@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "edumazet@google.com" <edumazet@google.com>
Subject: RE: [PATCH net-next v9 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Topic: [PATCH net-next v9 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Index: AQHYWI+jS4JtiaXpFUyrVgs1l1MK560ATOYAgAEeclA=
Date:   Tue, 26 Apr 2022 03:03:40 +0000
Message-ID: <a7cfab9942d849df93b51859925781bf@sphcmbx02.sunplus.com.tw>
References: <1650882640-7106-1-git-send-email-wellslutw@gmail.com>
        <1650882640-7106-3-git-send-email-wellslutw@gmail.com>
 <20220425093234.0ab232ff@hermes.local>
In-Reply-To: <20220425093234.0ab232ff@hermes.local>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.25.108.39]
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3RlcGhlbiwNCg0KDQo+ID4gK2ludCBzcGwyc3dfcnhfcG9sbChzdHJ1Y3QgbmFwaV9zdHJ1
Y3QgKm5hcGksIGludCBidWRnZXQpIHsNCj4gPiArCXN0cnVjdCBzcGwyc3dfY29tbW9uICpjb21t
ID0gY29udGFpbmVyX29mKG5hcGksIHN0cnVjdCBzcGwyc3dfY29tbW9uLCByeF9uYXBpKTsNCj4g
PiArCXN0cnVjdCBzcGwyc3dfbWFjX2Rlc2MgKmRlc2MsICpoX2Rlc2M7DQo+ID4gKwlzdHJ1Y3Qg
bmV0X2RldmljZV9zdGF0cyAqc3RhdHM7DQo+ID4gKwlzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCAqbmV3
X3NrYjsNCj4gPiArCXN0cnVjdCBzcGwyc3dfc2tiX2luZm8gKnNpbmZvOw0KPiA+ICsJaW50IGJ1
ZGdldF9sZWZ0ID0gYnVkZ2V0Ow0KPiA+ICsJdTMyIHJ4X3BvcywgcGtnX2xlbjsNCj4gPiArCXUz
MiBudW0sIHJ4X2NvdW50Ow0KPiA+ICsJczMyIHF1ZXVlOw0KPiA+ICsJdTMyIG1hc2s7DQo+ID4g
KwlpbnQgcG9ydDsNCj4gPiArCXUzMiBjbWQ7DQo+ID4gKw0KPiA+ICsJLyogUHJvY2VzcyBoaWdo
LXByaW9yaXR5IHF1ZXVlIGFuZCB0aGVuIGxvdy1wcmlvcml0eSBxdWV1ZS4gKi8NCj4gPiArCWZv
ciAocXVldWUgPSAwOyBxdWV1ZSA8IFJYX0RFU0NfUVVFVUVfTlVNOyBxdWV1ZSsrKSB7DQo+ID4g
KwkJcnhfcG9zID0gY29tbS0+cnhfcG9zW3F1ZXVlXTsNCj4gPiArCQlyeF9jb3VudCA9IGNvbW0t
PnJ4X2Rlc2NfbnVtW3F1ZXVlXTsNCj4gPiArDQo+ID4gKwkJZm9yIChudW0gPSAwOyBudW0gPCBy
eF9jb3VudCAmJiBidWRnZXRfbGVmdDsgbnVtKyspIHsNCj4gPiArCQkJc2luZm8gPSBjb21tLT5y
eF9za2JfaW5mb1txdWV1ZV0gKyByeF9wb3M7DQo+ID4gKwkJCWRlc2MgPSBjb21tLT5yeF9kZXNj
W3F1ZXVlXSArIHJ4X3BvczsNCj4gPiArCQkJY21kID0gZGVzYy0+Y21kMTsNCj4gPiArDQo+ID4g
KwkJCWlmIChjbWQgJiBSWERfT1dOKQ0KPiA+ICsJCQkJYnJlYWs7DQo+ID4gKw0KPiA+ICsJCQlw
b3J0ID0gRklFTERfR0VUKFJYRF9QS1RfU1AsIGNtZCk7DQo+ID4gKwkJCWlmIChwb3J0IDwgTUFY
X05FVERFVl9OVU0gJiYgY29tbS0+bmRldltwb3J0XSkNCj4gPiArCQkJCXN0YXRzID0gJmNvbW0t
Pm5kZXZbcG9ydF0tPnN0YXRzOw0KPiA+ICsJCQllbHNlDQo+ID4gKwkJCQlnb3RvIHNwbDJzd19y
eF9wb2xsX3JlY19lcnI7DQo+ID4gKw0KPiA+ICsJCQlwa2dfbGVuID0gRklFTERfR0VUKFJYRF9Q
S1RfTEVOLCBjbWQpOw0KPiA+ICsJCQlpZiAodW5saWtlbHkoKGNtZCAmIFJYRF9FUlJfQ09ERSkg
fHwgcGtnX2xlbiA8IEVUSF9aTEVOICsgNCkpIHsNCj4gPiArCQkJCXN0YXRzLT5yeF9sZW5ndGhf
ZXJyb3JzKys7DQo+ID4gKwkJCQlzdGF0cy0+cnhfZHJvcHBlZCsrOw0KPiA+ICsJCQkJZ290byBz
cGwyc3dfcnhfcG9sbF9yZWNfZXJyOw0KPiA+ICsJCQl9DQo+ID4gKw0KPiA+ICsJCQlkbWFfdW5t
YXBfc2luZ2xlKCZjb21tLT5wZGV2LT5kZXYsIHNpbmZvLT5tYXBwaW5nLA0KPiA+ICsJCQkJCSBj
b21tLT5yeF9kZXNjX2J1ZmZfc2l6ZSwgRE1BX0ZST01fREVWSUNFKTsNCj4gPiArDQo+ID4gKwkJ
CXNrYiA9IHNpbmZvLT5za2I7DQo+ID4gKwkJCXNrYl9wdXQoc2tiLCBwa2dfbGVuIC0gNCk7IC8q
IE1pbnVzIEZDUyAqLw0KPiA+ICsJCQlza2ItPmlwX3N1bW1lZCA9IENIRUNLU1VNX05PTkU7DQo+
ID4gKwkJCXNrYi0+cHJvdG9jb2wgPSBldGhfdHlwZV90cmFucyhza2IsIGNvbW0tPm5kZXZbcG9y
dF0pOw0KPiA+ICsJCQluZXRpZl9yZWNlaXZlX3NrYihza2IpOw0KPiA+ICsNCj4gPiArCQkJc3Rh
dHMtPnJ4X3BhY2tldHMrKzsNCj4gPiArCQkJc3RhdHMtPnJ4X2J5dGVzICs9IHNrYi0+bGVuOw0K
PiA+ICsNCj4gPiArCQkJLyogQWxsb2NhdGUgYSBuZXcgc2tiIGZvciByZWNlaXZpbmcuICovDQo+
ID4gKwkJCW5ld19za2IgPSBuZXRkZXZfYWxsb2Nfc2tiKE5VTEwsIGNvbW0tPnJ4X2Rlc2NfYnVm
Zl9zaXplKTsNCj4gPiArCQkJaWYgKHVubGlrZWx5KCFuZXdfc2tiKSkgew0KPiA+ICsJCQkJZGVz
Yy0+Y21kMiA9IChyeF9wb3MgPT0gY29tbS0+cnhfZGVzY19udW1bcXVldWVdIC0gMSkgPw0KPiA+
ICsJCQkJCSAgICAgUlhEX0VPUiA6IDA7DQo+ID4gKwkJCQlzaW5mby0+c2tiID0gTlVMTDsNCj4g
PiArCQkJCXNpbmZvLT5tYXBwaW5nID0gMDsNCj4gPiArCQkJCWRlc2MtPmFkZHIxID0gMDsNCj4g
PiArCQkJCWdvdG8gc3BsMnN3X3J4X3BvbGxfYWxsb2NfZXJyOw0KPiA+ICsJCQl9DQo+ID4gKw0K
PiA+ICsJCQlzaW5mby0+bWFwcGluZyA9IGRtYV9tYXBfc2luZ2xlKCZjb21tLT5wZGV2LT5kZXYs
IG5ld19za2ItPmRhdGEsDQo+ID4gKwkJCQkJCQljb21tLT5yeF9kZXNjX2J1ZmZfc2l6ZSwNCj4g
PiArCQkJCQkJCURNQV9GUk9NX0RFVklDRSk7DQo+ID4gKwkJCWlmIChkbWFfbWFwcGluZ19lcnJv
cigmY29tbS0+cGRldi0+ZGV2LCBzaW5mby0+bWFwcGluZykpIHsNCj4gPiArCQkJCWRldl9rZnJl
ZV9za2JfaXJxKG5ld19za2IpOw0KPiA+ICsJCQkJZGVzYy0+Y21kMiA9IChyeF9wb3MgPT0gY29t
bS0+cnhfZGVzY19udW1bcXVldWVdIC0gMSkgPw0KPiA+ICsJCQkJCSAgICAgUlhEX0VPUiA6IDA7
DQo+ID4gKwkJCQlzaW5mby0+c2tiID0gTlVMTDsNCj4gPiArCQkJCXNpbmZvLT5tYXBwaW5nID0g
MDsNCj4gPiArCQkJCWRlc2MtPmFkZHIxID0gMDsNCj4gPiArCQkJCWdvdG8gc3BsMnN3X3J4X3Bv
bGxfYWxsb2NfZXJyOw0KPiA+ICsJCQl9DQo+ID4gKw0KPiA+ICsJCQlzaW5mby0+c2tiID0gbmV3
X3NrYjsNCj4gPiArCQkJZGVzYy0+YWRkcjEgPSBzaW5mby0+bWFwcGluZzsNCj4gPiArDQo+ID4g
K3NwbDJzd19yeF9wb2xsX3JlY19lcnI6DQo+ID4gKwkJCWRlc2MtPmNtZDIgPSAocnhfcG9zID09
IGNvbW0tPnJ4X2Rlc2NfbnVtW3F1ZXVlXSAtIDEpID8NCj4gPiArCQkJCSAgICAgUlhEX0VPUiB8
IGNvbW0tPnJ4X2Rlc2NfYnVmZl9zaXplIDoNCj4gPiArCQkJCSAgICAgY29tbS0+cnhfZGVzY19i
dWZmX3NpemU7DQo+ID4gKw0KPiA+ICsJCQl3bWIoKTsJLyogU2V0IFJYRF9PV04gYWZ0ZXIgb3Ro
ZXIgZmllbGRzIGFyZSBlZmZlY3RpdmUuICovDQo+ID4gKwkJCWRlc2MtPmNtZDEgPSBSWERfT1dO
Ow0KPiA+ICsNCj4gPiArc3BsMnN3X3J4X3BvbGxfYWxsb2NfZXJyOg0KPiA+ICsJCQkvKiBNb3Zl
IHJ4X3BvcyB0byBuZXh0IHBvc2l0aW9uICovDQo+ID4gKwkJCXJ4X3BvcyA9ICgocnhfcG9zICsg
MSkgPT0gY29tbS0+cnhfZGVzY19udW1bcXVldWVdKSA/IDAgOiByeF9wb3MgKw0KPiA+ICsxOw0K
PiA+ICsNCj4gPiArCQkJYnVkZ2V0X2xlZnQtLTsNCj4gPiArDQo+ID4gKwkJCS8qIElmIHRoZXJl
IGFyZSBwYWNrZXRzIGluIGhpZ2gtcHJpb3JpdHkgcXVldWUsDQo+ID4gKwkJCSAqIHN0b3AgcHJv
Y2Vzc2luZyBsb3ctcHJpb3JpdHkgcXVldWUuDQo+ID4gKwkJCSAqLw0KPiA+ICsJCQlpZiAocXVl
dWUgPT0gMSAmJiAhKGhfZGVzYy0+Y21kMSAmIFJYRF9PV04pKQ0KPiA+ICsJCQkJYnJlYWs7DQo+
ID4gKwkJfQ0KPiA+ICsNCj4gPiArCQljb21tLT5yeF9wb3NbcXVldWVdID0gcnhfcG9zOw0KPiA+
ICsNCj4gPiArCQkvKiBTYXZlIHBvaW50ZXIgdG8gbGFzdCByeCBkZXNjcmlwdG9yIG9mIGhpZ2gt
cHJpb3JpdHkgcXVldWUuICovDQo+ID4gKwkJaWYgKHF1ZXVlID09IDApDQo+ID4gKwkJCWhfZGVz
YyA9IGNvbW0tPnJ4X2Rlc2NbcXVldWVdICsgcnhfcG9zOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiAr
CXdtYigpOwkvKiBtYWtlIHN1cmUgc2V0dGluZ3MgYXJlIGVmZmVjdGl2ZS4gKi8NCj4gPiArCW1h
c2sgPSByZWFkbChjb21tLT5sMnN3X3JlZ19iYXNlICsgTDJTV19TV19JTlRfTUFTS18wKTsNCj4g
PiArCW1hc2sgJj0gfk1BQ19JTlRfUlg7DQo+ID4gKwl3cml0ZWwobWFzaywgY29tbS0+bDJzd19y
ZWdfYmFzZSArIEwyU1dfU1dfSU5UX01BU0tfMCk7DQo+ID4gKw0KPiA+ICsJbmFwaV9jb21wbGV0
ZShuYXBpKTsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtpbnQgc3BsMnN3
X3R4X3BvbGwoc3RydWN0IG5hcGlfc3RydWN0ICpuYXBpLCBpbnQgYnVkZ2V0KSB7DQo+ID4gKwlz
dHJ1Y3Qgc3BsMnN3X2NvbW1vbiAqY29tbSA9IGNvbnRhaW5lcl9vZihuYXBpLCBzdHJ1Y3Qgc3Bs
MnN3X2NvbW1vbiwgdHhfbmFwaSk7DQo+ID4gKwlzdHJ1Y3Qgc3BsMnN3X3NrYl9pbmZvICpza2Jp
bmZvOw0KPiA+ICsJc3RydWN0IG5ldF9kZXZpY2Vfc3RhdHMgKnN0YXRzOw0KPiA+ICsJaW50IGJ1
ZGdldF9sZWZ0ID0gYnVkZ2V0Ow0KPiA+ICsJdTMyIHR4X2RvbmVfcG9zOw0KPiA+ICsJdTMyIG1h
c2s7DQo+ID4gKwl1MzIgY21kOw0KPiA+ICsJaW50IGk7DQo+ID4gKw0KPiA+ICsJc3Bpbl9sb2Nr
KCZjb21tLT50eF9sb2NrKTsNCj4gPiArDQo+ID4gKwl0eF9kb25lX3BvcyA9IGNvbW0tPnR4X2Rv
bmVfcG9zOw0KPiA+ICsJd2hpbGUgKCgodHhfZG9uZV9wb3MgIT0gY29tbS0+dHhfcG9zKSB8fCAo
Y29tbS0+dHhfZGVzY19mdWxsID09IDEpKSAmJiBidWRnZXRfbGVmdCkNCj4gew0KPiA+ICsJCWNt
ZCA9IGNvbW0tPnR4X2Rlc2NbdHhfZG9uZV9wb3NdLmNtZDE7DQo+ID4gKwkJaWYgKGNtZCAmIFRY
RF9PV04pDQo+ID4gKwkJCWJyZWFrOw0KPiA+ICsNCj4gPiArCQlza2JpbmZvID0gJmNvbW0tPnR4
X3RlbXBfc2tiX2luZm9bdHhfZG9uZV9wb3NdOw0KPiA+ICsJCWlmICh1bmxpa2VseSghc2tiaW5m
by0+c2tiKSkNCj4gPiArCQkJZ290byBzcGwyc3dfdHhfcG9sbF9uZXh0Ow0KPiA+ICsNCj4gPiAr
CQlpID0gZmZzKEZJRUxEX0dFVChUWERfVkxBTiwgY21kKSkgLSAxOw0KPiA+ICsJCWlmIChpIDwg
TUFYX05FVERFVl9OVU0gJiYgY29tbS0+bmRldltpXSkNCj4gPiArCQkJc3RhdHMgPSAmY29tbS0+
bmRldltpXS0+c3RhdHM7DQo+ID4gKwkJZWxzZQ0KPiA+ICsJCQlnb3RvIHNwbDJzd190eF9wb2xs
X3VubWFwOw0KPiA+ICsNCj4gPiArCQlpZiAodW5saWtlbHkoY21kICYgKFRYRF9FUlJfQ09ERSkp
KSB7DQo+ID4gKwkJCXN0YXRzLT50eF9lcnJvcnMrKzsNCj4gPiArCQl9IGVsc2Ugew0KPiA+ICsJ
CQlzdGF0cy0+dHhfcGFja2V0cysrOw0KPiA+ICsJCQlzdGF0cy0+dHhfYnl0ZXMgKz0gc2tiaW5m
by0+bGVuOw0KPiA+ICsJCX0NCj4gPiArDQo+ID4gK3NwbDJzd190eF9wb2xsX3VubWFwOg0KPiA+
ICsJCWRtYV91bm1hcF9zaW5nbGUoJmNvbW0tPnBkZXYtPmRldiwgc2tiaW5mby0+bWFwcGluZywg
c2tiaW5mby0+bGVuLA0KPiA+ICsJCQkJIERNQV9UT19ERVZJQ0UpOw0KPiA+ICsJCXNrYmluZm8t
Pm1hcHBpbmcgPSAwOw0KPiA+ICsJCWRldl9rZnJlZV9za2JfaXJxKHNrYmluZm8tPnNrYik7DQo+
ID4gKwkJc2tiaW5mby0+c2tiID0gTlVMTDsNCj4gPiArDQo+ID4gK3NwbDJzd190eF9wb2xsX25l
eHQ6DQo+ID4gKwkJLyogTW92ZSB0eF9kb25lX3BvcyB0byBuZXh0IHBvc2l0aW9uICovDQo+ID4g
KwkJdHhfZG9uZV9wb3MgPSAoKHR4X2RvbmVfcG9zICsgMSkgPT0gVFhfREVTQ19OVU0pID8gMCA6
IHR4X2RvbmVfcG9zDQo+ID4gKysgMTsNCj4gPiArDQo+ID4gKwkJaWYgKGNvbW0tPnR4X2Rlc2Nf
ZnVsbCA9PSAxKQ0KPiA+ICsJCQljb21tLT50eF9kZXNjX2Z1bGwgPSAwOw0KPiA+ICsNCj4gPiAr
CQlidWRnZXRfbGVmdC0tOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCWNvbW0tPnR4X2RvbmVfcG9z
ID0gdHhfZG9uZV9wb3M7DQo+ID4gKwlpZiAoIWNvbW0tPnR4X2Rlc2NfZnVsbCkNCj4gPiArCQlm
b3IgKGkgPSAwOyBpIDwgTUFYX05FVERFVl9OVU07IGkrKykNCj4gPiArCQkJaWYgKGNvbW0tPm5k
ZXZbaV0pDQo+ID4gKwkJCQlpZiAobmV0aWZfcXVldWVfc3RvcHBlZChjb21tLT5uZGV2W2ldKSkN
Cj4gPiArCQkJCQluZXRpZl93YWtlX3F1ZXVlKGNvbW0tPm5kZXZbaV0pOw0KPiA+ICsNCj4gPiAr
CXNwaW5fdW5sb2NrKCZjb21tLT50eF9sb2NrKTsNCj4gPiArDQo+ID4gKwl3bWIoKTsJCQkvKiBt
YWtlIHN1cmUgc2V0dGluZ3MgYXJlIGVmZmVjdGl2ZS4gKi8NCj4gPiArCW1hc2sgPSByZWFkbChj
b21tLT5sMnN3X3JlZ19iYXNlICsgTDJTV19TV19JTlRfTUFTS18wKTsNCj4gPiArCW1hc2sgJj0g
fk1BQ19JTlRfVFg7DQo+ID4gKwl3cml0ZWwobWFzaywgY29tbS0+bDJzd19yZWdfYmFzZSArIEwy
U1dfU1dfSU5UX01BU0tfMCk7DQo+ID4gKw0KPiA+ICsJbmFwaV9jb21wbGV0ZShuYXBpKTsNCj4g
PiArCXJldHVybiAwOw0KPiA+ICt9DQo+IA0KPiBUaGlzIGRvZXNuJ3QgbG9vayBsaWtlIGl0IGlz
IGRvaW5nIE5BUEkgcHJvcGVybHkuDQo+IA0KPiBUaGUgZHJpdmVyIGlzIHN1cHBvc2VkIHRvIHJl
dHVybiB0aGUgYW1vdW50IG9mIHBhY2tldHMgcHJvY2Vzc2VkLg0KPiBJZiBidWRnZXQgaXMgdXNl
ZCwgaXQgc2hvdWxkIHJldHVybiBidWRnZXQuDQoNCkknbGwgbW9kaWZ5IGNvZGUgdG8gcmV0dXJu
IHRoZSBhbW91bnQgb2YgcHJvY2Vzc2VkIHBhY2tldHM6DQoNCglyZXR1cm4gYnVkZ2UgLSBidWRn
ZXRfbGVmdDsNCg0KDQpUaGFuayB5b3UgZm9yIHlvdXIgcmV2aWV3Lg0KDQoNCkJlc3QgcmVnYXJk
cywNCldlbGxzDQo=
