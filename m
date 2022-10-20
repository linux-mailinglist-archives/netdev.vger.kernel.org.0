Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220BF605B0E
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 11:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiJTJYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 05:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiJTJYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 05:24:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C9A2D1C3;
        Thu, 20 Oct 2022 02:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666257884; x=1697793884;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Wj4l33DaYJ9VEOxS8rubLXY/EOYmxzoOfQFw6w/nBTU=;
  b=a5qvAb+BrLiGG5pPTBpNMihNWDXHohwVAv2CmbBKCcYsXgj2ASluQ06R
   JmPV51zmJHit0VtQ+eH1t5+p0t1Lz87bUoPwmt1rZO9rpFYnXB7/nXUs3
   a7/UEdWzOe56YRfyCESgmvipF4dVclkZHS6r0x1GOdxT0KKDsQtNyo+7c
   n60Hu84+MpGDDBUsidrJrpaiSmz14KQUhVsWpeeIPAbCujVdc2RMtuQ3y
   noOqD1S/uRITn8nHdpr7+djCXyEc9kzmIvAYmRoQDegyWk6lKuINaCbF4
   EQ+xPoBn1qqSKxWIcRt743ON7LvcExmT+dhFbl55UVP0e0kmOcBcEFnPP
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="185546700"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Oct 2022 02:24:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 20 Oct 2022 02:24:43 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 20 Oct 2022 02:24:40 -0700
Message-ID: <85b3993eae5e82860f366c112342527f2018243f.camel@microchip.com>
Subject: Re: [PATCH net-next v2 7/9] net: microchip: sparx5: Writing rules
 to the IS2 VCAP
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "Wan Jiabing" <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Thu, 20 Oct 2022 11:24:40 +0200
In-Reply-To: <20221020074806.ys7lyfkn7f7zpkcp@wse-c0155>
References: <20221019114215.620969-1-steen.hegelund@microchip.com>
         <20221019114215.620969-8-steen.hegelund@microchip.com>
         <20221020074806.ys7lyfkn7f7zpkcp@wse-c0155>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2FzcGVyLAoKT24gVGh1LCAyMDIyLTEwLTIwIGF0IDA5OjQ4ICswMjAwLCBDYXNwZXIgQW5k
ZXJzc29uIHdyb3RlOgo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQo+IAo+IE9u
IDIwMjItMTAtMTkgMTM6NDIsIFN0ZWVuIEhlZ2VsdW5kIHdyb3RlOgo+ID4gK3N0YXRpYyB2b2lk
IHZjYXBfaXRlcl9za2lwX3RnKHN0cnVjdCB2Y2FwX3N0cmVhbV9pdGVyICppdHIpCj4gPiArewo+
ID4gK8KgwqDCoMKgIC8qIENvbXBlbnNhdGUgdGhlIGZpZWxkIG9mZnNldCBmb3IgcHJlY2VkaW5n
IHR5cGVncm91cHMgKi8KPiA+ICvCoMKgwqDCoCB3aGlsZSAoaXRyLT50Zy0+d2lkdGggJiYgaXRy
LT5vZmZzZXQgPj0gaXRyLT50Zy0+b2Zmc2V0KSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGl0ci0+b2Zmc2V0ICs9IGl0ci0+dGctPndpZHRoOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpdHItPnRnKys7IC8qIG5leHQgdHlwZWdyb3VwICovCj4gPiArwqDCoMKgwqAgfQo+
ID4gK30KPiAKPiBJdCB3YXMgbm90IGltbWVkaWF0ZWx5IG9idmlvdXMgdG8gbWUgd2h5IGl0IHNo
b3VsZCBzdG9wIGl0ZXJhdGluZyB3aGVuCj4gdGctPndpZHRoIGlzIHplcm8uIEJ1dCBhZnRlciBz
b21lIGRpZ2dpbmcgSSBzYXcgdGhhdCB0aGUgdGcgaXRlcmF0b3JzCj4gYWx3YXlzIGVuZHMgd2l0
aCBhbiBlbXB0eSBlbGVtZW50IChhbGwgYml0cyB6ZXJvLCBhbmQgdGhlcmVmb3JlIHdpZHRoIGlz
Cj4gemVybykuIENvdWxkIHRoaXMgYmUgbWFkZSBjbGVhcmVyPyBPciBtYXliZSB0aGlzIGlzIHNv
bWV0aGluZyBjb21tb24KPiB0aGF0IEknbSBqdXN0IG5vdCB1c2VkIHRvIHNlZWluZy4KClllcyB0
aGUgZW1wdHkgZWxlbWVudCBpcyBqdXN0IGEgbGlzdCB0ZXJtaW5hdG9yLCBhbmQgaXQganVzdCBt
YWtlcyB0aGUgaXRlcmF0aW9uIHNpbXBsZXIgdGhhbiB1c2luZwphIGNvdW50IHdoaWNoIHdvdWxk
IGhhdmUgYmVlbiBzdG9yZWQgaW4gYSBzZXBhcmF0ZSBsb2NhdGlvbi4KSSBjb3VsZCBhZGQgYSBj
b21tZW50IGhlcmUgdG8gY2xhcmlmeSB0aGlzLgoKPiAKPiA+ICtzdGF0aWMgdm9pZCB2Y2FwX2Vu
Y29kZV9iaXQodTMyICpzdHJlYW0sIHN0cnVjdCB2Y2FwX3N0cmVhbV9pdGVyICppdHIsIGJvb2wg
dmFsKQo+ID4gK3sKPiA+ICvCoMKgwqDCoCAvKiBXaGVuIGludGVyc2VjdGVkIGJ5IGEgdHlwZSBn
cm91cCBmaWVsZCwgc3RyZWFtIHRoZSB0eXBlIGdyb3VwIGJpdHMKPiA+ICvCoMKgwqDCoMKgICog
YmVmb3JlIGNvbnRpbnVpbmcgd2l0aCB0aGUgdmFsdWUgYml0Cj4gPiArwqDCoMKgwqDCoCAqLwo+
ID4gK8KgwqDCoMKgIHdoaWxlIChpdHItPnRnLT53aWR0aCAmJgo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgaXRyLT5vZmZzZXQgPj0gaXRyLT50Zy0+b2Zmc2V0ICYmCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBpdHItPm9mZnNldCA8IGl0ci0+dGctPm9mZnNldCArIGl0ci0+dGctPndp
ZHRoKSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludCB0Z19iaXRwb3MgPSBpdHIt
PnRnLT5vZmZzZXQgLSBpdHItPm9mZnNldDsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgdmNhcF9zZXRfYml0KHN0cmVhbSwgaXRyLCAoaXRyLT50Zy0+dmFsdWUgPj4gdGdfYml0
cG9zKSAmIDB4MSk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGl0ci0+b2Zmc2V0Kys7
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZjYXBfaXRlcl91cGRhdGUoaXRyKTsKPiA+
ICvCoMKgwqDCoCB9Cj4gCj4gU2FtZSBhcyBhYm92ZS4KClllcyBpdCBhbHNvIGNoZWNrcyBmb3Ig
dGhlIGxpc3QgdGVybWluYXRvci4KCj4gCj4gPiArc3RhdGljIHZvaWQgdmNhcF9lbmNvZGVfdHlw
ZWdyb3Vwcyh1MzIgKnN0cmVhbSwgaW50IHN3X3dpZHRoLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnN0IHN0cnVj
dCB2Y2FwX3R5cGVncm91cCAqdGcsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYm9vbCBtYXNrKQo+ID4gK3sKPiA+ICvC
oMKgwqDCoCBzdHJ1Y3QgdmNhcF9zdHJlYW1faXRlciBpdGVyOwo+ID4gK8KgwqDCoMKgIGludCBp
ZHg7Cj4gPiArCj4gPiArwqDCoMKgwqAgLyogTWFzayBiaXRzIG11c3QgYmUgc2V0IHRvIHplcm9z
IChpbnZlcnRlZCBsYXRlciB3aGVuIHdyaXRpbmcgdG8gdGhlCj4gPiArwqDCoMKgwqDCoCAqIG1h
c2sgY2FjaGUgcmVnaXN0ZXIpLCBzbyB0aGF0IHRoZSBtYXNrIHR5cGVncm91cCBiaXRzIGNvbnNp
c3Qgb2YKPiA+ICvCoMKgwqDCoMKgICogbWF0Y2gtMSBvciBtYXRjaC0wLCBvciBib3RoCj4gPiAr
wqDCoMKgwqDCoCAqLwo+ID4gK8KgwqDCoMKgIHZjYXBfaXRlcl9zZXQoJml0ZXIsIHN3X3dpZHRo
LCB0ZywgMCk7Cj4gPiArwqDCoMKgwqAgd2hpbGUgKGl0ZXIudGctPndpZHRoKSB7Cj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIFNldCBwb3NpdGlvbiB0byBjdXJyZW50IHR5cGVncm91
cCBiaXQgKi8KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaXRlci5vZmZzZXQgPSBpdGVy
LnRnLT5vZmZzZXQ7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZjYXBfaXRlcl91cGRh
dGUoJml0ZXIpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmb3IgKGlkeCA9IDA7IGlk
eCA8IGl0ZXIudGctPndpZHRoOyBpZHgrKykgewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgLyogSXRlcmF0ZSBvdmVyIGN1cnJlbnQgdHlwZWdyb3VwIGJpdHMu
IE1hc2sgdHlwZWdyb3VwCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgICogYml0cyBhcmUgYWx3YXlzIHNldAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgaWYgKG1hc2spCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmNhcF9zZXRfYml0KHN0cmVhbSwgJml0ZXIsIDB4
MSk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlbHNlCj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgdmNhcF9zZXRfYml0KHN0cmVhbSwgJml0ZXIsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAoaXRlci50Zy0+dmFsdWUgPj4gaWR4KSAmIDB4MSk7Cj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpdGVyLm9mZnNldCsrOwo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmNhcF9pdGVyX3VwZGF0ZSgmaXRlcik7Cj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgaXRlci50ZysrOyAvKiBuZXh0IHR5cGVncm91cCAqLwo+ID4gK8KgwqDCoMKgIH0KPiAKPiBT
YW1lIGFzIGFib3ZlLgpZZXMgc2FtZSBwcm9jZWR1cmUgaGVyZS4KCj4gCj4gVGVzdGVkIG9uIE1p
Y3JvY2hpcCBQQ0IxMzUgc3dpdGNoLgo+IAo+IFRlc3RlZC1ieTogQ2FzcGVyIEFuZGVyc3NvbiA8
Y2FzcGVyLmNhc2FuQGdtYWlsLmNvbT4KPiBSZXZpZXdlZC1ieTogQ2FzcGVyIEFuZGVyc3NvbiA8
Y2FzcGVyLmNhc2FuQGdtYWlsLmNvbT4KPiAKPiBCZXN0IFJlZ2FyZHMsCj4gQ2FzcGVyCgpUaGFu
a3MgYWdhaW4gZm9yIHRoZSByZXZpZXcgYW5kIHRoZSB0YXJnZXQgdGVzdGluZy4KCkJSClN0ZWVu
Cgo=

