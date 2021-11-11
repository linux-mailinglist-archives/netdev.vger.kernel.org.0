Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2399844CFD6
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 03:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhKKCNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 21:13:16 -0500
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:39181
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S234265AbhKKCNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 21:13:04 -0500
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 11 Nov 2021 10:09:59
 +0800 (GMT+08:00)
X-Originating-IP: [183.159.98.51]
Date:   Thu, 11 Nov 2021 10:09:59 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jirislaby@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v1 2/2] hamradio: defer 6pack kfree after
 unregister_netdev
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2021 www.mailtech.cn zju.edu.cn
In-Reply-To: <20211110180612.2f2eb760@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211108103721.30522-1-linma@zju.edu.cn>
 <20211108103759.30541-1-linma@zju.edu.cn>
 <20211110180525.20422f66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211110180612.2f2eb760@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <724aae55.1863af.17d0cc249ab.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: en_US
X-CM-TRANSID: cS_KCgAXSXR3e4xhh7ffBA--.61118W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwUCElNG3ElR6gAUs5
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgdGhlcmUsCgo+IFNlbnQgVGltZTogMjAyMS0xMS0xMSAxMDowNjoxMiAoVGh1cnNkYXkpCj4g
VG86ICJMaW4gTWEiIDxsaW5tYUB6anUuZWR1LmNuPgo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnLCBkYXZlbUBkYXZlbWxvZnQubmV0LCBqaXJpc2xhYnlAa2VybmVsLm9yZywgZ3JlZ2toQGxp
bnV4Zm91bmRhdGlvbi5vcmcsIGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcKPiBTdWJqZWN0
OiBSZTogW1BBVENIIHYxIDIvMl0gaGFtcmFkaW86IGRlZmVyIDZwYWNrIGtmcmVlIGFmdGVyIHVu
cmVnaXN0ZXJfbmV0ZGV2Cj4gCj4gT24gV2VkLCAxMCBOb3YgMjAyMSAxODowNToyNSAtMDgwMCBK
YWt1YiBLaWNpbnNraSB3cm90ZToKPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2hhbXJh
ZGlvLzZwYWNrLmMgYi9kcml2ZXJzL25ldC9oYW1yYWRpby82cGFjay5jCj4gPiA+IGluZGV4IDQ5
ZjEwMDUzYTc5NC4uYmZkZjg5ZTU0NzUyIDEwMDY0NAo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9o
YW1yYWRpby82cGFjay5jCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2hhbXJhZGlvLzZwYWNrLmMK
PiA+ID4gQEAgLTY3MiwxMSArNjcyLDEzIEBAIHN0YXRpYyB2b2lkIHNpeHBhY2tfY2xvc2Uoc3Ry
dWN0IHR0eV9zdHJ1Y3QgKnR0eSkKPiA+ID4gIAlkZWxfdGltZXJfc3luYygmc3AtPnR4X3QpOwo+
ID4gPiAgCWRlbF90aW1lcl9zeW5jKCZzcC0+cmVzeW5jX3QpOwo+ID4gPiAgCj4gPiA+IC0JLyog
RnJlZSBhbGwgNnBhY2sgZnJhbWUgYnVmZmVycy4gKi8KPiA+ID4gKwl1bnJlZ2lzdGVyX25ldGRl
dihzcC0+ZGV2KTsKPiA+ID4gKwo+ID4gPiArCS8qIEZyZWUgYWxsIDZwYWNrIGZyYW1lIGJ1ZmZl
cnMgYWZ0ZXIgdW5yZWcuICovCj4gPiA+ICAJa2ZyZWUoc3AtPnJidWZmKTsKPiA+ID4gIAlrZnJl
ZShzcC0+eGJ1ZmYpOwo+ID4gPiAgCj4gPiA+IC0JdW5yZWdpc3Rlcl9uZXRkZXYoc3AtPmRldik7
Cj4gPiA+ICsJZnJlZV9uZXRkZXYoc3AtPmRldik7ICAKPiA+IAo+ID4gWW91IHNob3VsZCBtZW50
aW9uIGluIHRoZSBjb21taXQgbWVzc2FnZSB3aHkgeW91IHRoaW5rIGl0J3Mgc2FmZSB0byBhZGQK
PiA+IGZyZWVfbmV0ZGV2KCkgd2hpY2ggd2Fzbid0IGhlcmUgYmVmb3JlLi4uCj4gPiAKPiA+IFRo
aXMgZHJpdmVyIHNlZW1zIHRvIGJlIHNldHRpbmc6Cj4gPiAKPiA+IAlkZXYtPm5lZWRzX2ZyZWVf
bmV0ZGV2CT0gdHJ1ZTsKPiA+IAo+ID4gc28gdW5yZWdpc3Rlcl9uZXRkZXYoKSB3aWxsIGZyZWUg
dGhlIG5ldGRldiBhdXRvbWF0aWNhbGx5Lgo+ID4gCj4gPiBUaGF0IHNhaWQgSSBkb24ndCBzZWUg
YSByZWFzb24gd2h5IHRoaXMgZHJpdmVyIG5lZWRzIHRoZSBhdXRvbWF0aWMKPiA+IGNsZWFudXAu
Cj4gPiAKPiA+IFlvdSBjYW4gZWl0aGVyIHJlbW92ZSB0aGF0IHNldHRpbmcgYW5kIHRoZW4geW91
IGNhbiBjYWxsIGZyZWVfbmV0ZGV2KCkKPiA+IGxpa2UgeW91IGRvLCBvciB5b3UgbmVlZCB0byBt
b3ZlIHRoZSBjbGVhbnVwIHRvIGRldi0+cHJpdl9kZXN0cnVjdG9yLgo+IAo+IExvb2tzIGxpa2Ug
dGhpcyBnbyBhcHBsaWVkIGFscmVhZHksIHBsZWFzZSBzZW5kIGEgZm9sbG93IHVwIGZpeC4KCk9v
b29wcywgdGhhbmtzIGZvciB0aGUgcmVtaW5kLiBYRAoKSSBqdXN0IGZvdW5kIHRoYXQgdGhlIG1r
aWxsIGFkZHMgdGhlIGZyZWVfbmV0ZGV2IGFmdGVyIHRoZSB1bnJlZ2lzdGVyX25ldGRldiBzbyBJ
IGRpZCBpdCB0b28uIE5vIGlkZWEgYWJvdXQgdGhpcyBhdXRvbWF0aWMgY2xlYW51cC4KClNob3Vs
ZCBJIHNlbmQgdGhlIGZpeCBpbiB0aGlzIHRocmVhZCBvciBvcGVuIGEgbmV3IG9uZT8KClRoYW5r
cwoKTGluIAo=
