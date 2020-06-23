Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB272045F0
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 02:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731833AbgFWAlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 20:41:35 -0400
Received: from mga07.intel.com ([134.134.136.100]:18339 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731442AbgFWAlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 20:41:35 -0400
IronPort-SDR: xwfuj47NqaDZEUvlLfjwWXjqVTNjAunpngkKnZsH4135hEl7PAYmNFRq6ee1DGxFLFW0DoqaM3
 RAISIhVDvBQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="209104318"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="209104318"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 17:41:33 -0700
IronPort-SDR: NG93zXij8Uc37gqKsJ/8Pe0INf9kaAauA3kqq1BZkYhY3twj9LTk3aWGFaeuTif5qEJds/7os1
 IUOUdjfJtHrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="283003181"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by orsmga007.jf.intel.com with ESMTP; 22 Jun 2020 17:41:33 -0700
Received: from orsmsx152.amr.corp.intel.com (10.22.226.39) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 22 Jun 2020 17:41:33 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.199]) by
 ORSMSX152.amr.corp.intel.com ([169.254.8.114]) with mapi id 14.03.0439.000;
 Mon, 22 Jun 2020 17:41:33 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Kwapulinski, Piotr" <piotr.kwapulinski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 4/9] i40e: detect and log info about pre-recovery mode
Thread-Topic: [net-next 4/9] i40e: detect and log info about pre-recovery
 mode
Thread-Index: AQHWSOMMtMCKLyPfsUWCUoUdRG4SWKjlxOQA//+QaMCAAHj9gP//jUaA
Date:   Tue, 23 Jun 2020 00:41:32 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D9404498732013@ORSMSX112.amr.corp.intel.com>
References: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
        <20200622221817.2287549-5-jeffrey.t.kirsher@intel.com>
        <20200622165552.13ebc666@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <61CC2BC414934749BD9F5BF3D5D9404498731F8F@ORSMSX112.amr.corp.intel.com>
 <20200622172929.0a7c29d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200622172929.0a7c29d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPg0KPiBTZW50OiBNb25kYXksIEp1bmUgMjIsIDIwMjAgMTc6MjkNCj4gVG86
IEtpcnNoZXIsIEplZmZyZXkgVCA8amVmZnJleS50LmtpcnNoZXJAaW50ZWwuY29tPg0KPiBDYzog
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgS3dhcHVsaW5za2ksIFBpb3RyIDxwaW90ci5rd2FwdWxpbnNr
aUBpbnRlbC5jb20+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBuaG9ybWFuQHJlZGhhdC5j
b207IHNhc3NtYW5uQHJlZGhhdC5jb207DQo+IExva3Rpb25vdiwgQWxla3NhbmRyIDxhbGVrc2Fu
ZHIubG9rdGlvbm92QGludGVsLmNvbT47IEJvd2VycywgQW5kcmV3WA0KPiA8YW5kcmV3eC5ib3dl
cnNAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW25ldC1uZXh0IDQvOV0gaTQwZTogZGV0ZWN0
IGFuZCBsb2cgaW5mbyBhYm91dCBwcmUtcmVjb3ZlcnkgbW9kZQ0KPiANCj4gT24gVHVlLCAyMyBK
dW4gMjAyMCAwMDoxODowOCArMDAwMCBLaXJzaGVyLCBKZWZmcmV5IFQgd3JvdGU6DQo+ID4gPiBU
aGVyZSBpcyBubyBuZWVkIHRvIHVzZSB0aGUgaW5saW5lIGtleXdvcmQgaW4gQyBzb3VyY2VzLiBD
b21waWxlcg0KPiA+ID4gd2lsbCBpbmxpbmUgc21hbGwgc3RhdGljIGZ1bmN0aW9ucywgYW55d2F5
Lg0KPiA+ID4NCj4gPiA+IFNhbWUgdGhpbmcgaW4gcGF0Y2ggOC4NCj4gPg0KPiA+IEkgYW0gcHJl
cHBpbmcgYSB2MiwgYXJlIHRoZXNlIHRoZSBvbmx5IGlzc3Vlcz8gIFdhbnQgdG8gbWFrZSBzdXJl
DQo+ID4gYmVmb3JlIHNlbmQgb3V0IGEgdjIgYW5kIHRoYW5rIHlvdSBKYWt1YiENCj4gDQo+IFNp
bmNlIHlvdSBhc2tlZCA6KQ0KDQpZb3VyIHJpZ2h0LCBJIGRpZC4gIEkgYW0gYSBnbHV0ZW4gZm9y
IGNyaXRpY2lzbS4g8J+Yig0KDQo+IC0gSSBjb3VsZG4ndCByZWFsbHkgZ3Jhc3Agd2hhdCB0aGUg
OHRoIHBhdGNoIGRvZXMuDQo+IFF1aXRlIGEgYml0IG9mIGNvZGUgZ2V0cyBtb3ZlZCBhcm91bmQg
aW4gYSB3YXkgdGhhdCBkb2Vzbid0IGNsZWFybHkgYWRkcmVzcw0KPiBhbnkgbG9ja2luZyBpc3N1
ZXMuIFBlcmhhcHMgdGhlIGNvbW1pdCBtZXNzYWdlIGNvdWxkIGJlIGltcHJvdmVkIChvciBldmVu
DQo+IHBhdGNoIHNwbGl0IGludG8gdHdvIC0gbW92ZSBjb2RlLCBjaGFuZ2UgY29kZSk/DQoNCk9r
LCBJIHdpbGwgd29yayB3aXRoIEFsZWsgdG8gaW1wcm92ZSBwYXRjaCA4Lg0K
