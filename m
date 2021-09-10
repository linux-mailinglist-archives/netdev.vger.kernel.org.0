Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC6D406401
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 02:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbhIJAwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 20:52:51 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60432 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240861AbhIJAnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 20:43:11 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 18A0fsbh098329;
        Thu, 9 Sep 2021 19:41:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1631234514;
        bh=7WpQ0UQcRckhL2KZvB4oX9WAhqkdJztE4q4lICX7bYU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=mX2WPCfx3MZRw55KF2xHWdHz3xgCzW0ei13jc9kwpVfeXiH3QdwkTQqeytDenEfvL
         8Cukd8LpP99EttSCHqqEUNTMmLaoqL7BmePzpGEzURRKQ0Tu7PrM0OlNYtMn/YdDIi
         Ad4yYI6dSWOiHVx3r28LQfMRMpnsS3UpD0pCRqDY=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 18A0fs5U059866
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 Sep 2021 19:41:54 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 9
 Sep 2021 19:41:53 -0500
Received: from DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14]) by
 DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14%17]) with mapi id
 15.01.2308.014; Thu, 9 Sep 2021 19:41:53 -0500
From:   "Modi, Geet" <geet.modi@ti.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Nagalla, Hari" <hnagalla@ti.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sharma, Vikram" <vikram.sharma@ti.com>
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] net: phy:
 dp83tc811: modify list of interrupts enabled at initialization
Thread-Topic: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] net: phy:
 dp83tc811: modify list of interrupts enabled at initialization
Thread-Index: AQHXoC4XSSkBWxKBYUuzA52mb5z+zauRtoAAgAWhA4CAAZ4BAIADCCgAgACK0YD//66ZAA==
Date:   Fri, 10 Sep 2021 00:41:53 +0000
Message-ID: <E3DBDC45-111F-4744-82A8-95C7D5CCEBE5@ti.com>
References: <20210902190944.4963-1-hnagalla@ti.com> <YTFc6pyEtlRO/4r/@lunn.ch>
 <99232B33-1C2F-45AF-A259-0868AC7D3FBC@ti.com> <YTdxBMVeqZVyO4Tf@lunn.ch>
 <E61A9519-DBA6-4931-A2A0-78856819C362@ti.com> <YTpwjWEUmJWo0mwr@lunn.ch>
In-Reply-To: <YTpwjWEUmJWo0mwr@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.52.21080801
x-originating-ip: [10.250.200.196]
x-exclaimer-md-config: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Content-Type: text/plain; charset="utf-8"
Content-ID: <04DAA7E225833244AA978630095B1EB7@owa.mail.ti.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpBcyBtZW50aW9uZWQgd2Ugd2FudCB0byBkbyB0aGlzIGluIHBoYXNlczog
DQphKSB0aGlzIHBhdGNoIHRvIGRpc2FibGUgdGhlIE92ZXJ2b2x0YWdlIGRyaXZlciBpbnRlcnJ1
cHQNCmIpIEFmdGVyIGNhcmVmdWxseSBjb25zaWRlcmluZyBvdGhlciBpbnRlcnJ1cHRzLCBwbGFu
IGEgIGZvbGxvdy1vbiBwYXRjaCB0byB0YWtlIGNhcmUgb2Ygb3RoZXIgaW50ZXJydXB0cy4NCg0K
UGF0Y2ggY29tbWVudCB3aWxsIGJlIGlubGluZSB3aXRoIHlvdXIgc3VnZ2VzdGlvbg0KDQoiVGhl
IG92ZXIgdm9sdGFnZSBpbnRlcnJ1cHQgaXMgZW5hYmxlZCwgYnV0IGlmIGl0IGV2ZXIgb2NjdXJz
LCB0aGVyZSBpcyBubyBjb2RlIHRvIG1ha2UgdXNlIG9mIGl0LiBTbyByZW1vdmluZyBpdC4gSXQN
CiAgICBjYW4gcmUtZW5hYmxlZCB3aGVuIEhXTU9OIHN1cHBvcnQgaXMgYWRkZWQgIg0KDQpSZWdh
cmZkcywNCkdlZXQNCg0KDQrvu79PbiA5LzkvMjEsIDE6MzcgUE0sICJBbmRyZXcgTHVubiIgPGFu
ZHJld0BsdW5uLmNoPiB3cm90ZToNCg0KICAgID4gSSBhbSBwbGFubmluZyB0byBoYXZlIGZvbGxv
d2luZyBjb21taXQgbXNnOw0KICAgID4gDQogICAgPiAgDQogICAgPiANCiAgICA+IOKAnFRoaXMg
ZmVhdHVyZSBpcyBub3QgdXNlZCBieSBvdXIgbWFpbnN0cmVhbSBjdXN0b21lcnMgYXMgdGhleSBo
YXZlIGFkZGl0aW9uYWwNCg0KICAgIEFzIGkgc2FpZCwgdGhpcyBpcyBub3QgeW91ciBkcml2ZXIs
IGZvciB5b3UgY3VzdG9tZXJzLiBJdCBpcyB0aGUgTGludXgNCiAgICBrZXJuZWwgZHJpdmVyLiBQ
bGVhc2UgZHJvcCBhbGwgcmVmZXJlbmNlcyB0byB5b3VyIGN1c3RvbWVycy4gSWYgeW91DQogICAg
bmVlZCB0byBhZGRyZXNzIGFueWJvZHksIGl0IHNob3VsZCBiZSB0aGUgTGludXggY29tbXVuaXR5
IGFzIGEgd2hvbGUsDQogICAgb3IgbWF5YmUgdGhlIHVzZXJzIG9mIHRoaXMgZHJpdmVyLg0KDQog
ICAgPiBtZWNoYW5pc20gdG8gbW9uaXRvciB0aGUgc3VwcGx5IGF0IFN5c3RlbSBsZXZlbCBhcyBh
Y2N1cmFjeSByZXF1aXJlbWVudHMgYXJlDQogICAgPiBkaWZmZXJlbnQgZm9yIGVhY2ggYXBwbGlj
YXRpb24uICBUaGUgZGV2aWNlIGlzIGRlc2lnbmVkIHdpdGggaW5idWlsdCBtb25pdG9yDQogICAg
PiB3aXRoIGludGVycnVwdCBkaXNhYmxlZCBieSBkZWZhdWx0IGFuZCBsZXQgdXNlciBjaG9vc2Ug
aWYgdGhleSB3YW50IHRvIGV4ZXJjaXNlDQogICAgPiB0aGUgbW9uaXRvci4gSG93ZXZlciwgdGhl
IGRyaXZlciBoYWQgdGhpcyBpbnRlcnJ1cHQgZW5hYmxlZCwgdGhlIHJlcXVlc3QgaGVyZQ0KICAg
ID4gaXMgZGlzYWJsZSBpdCBieSBkZWZhdWx0IGluIGRyaXZlciBob3dldmVyIG5vdCBjaGFuZ2Ug
aW4gZGF0YXNoZWV0LiAgTGV0IHVzZXINCiAgICA+IG9mIHRoZSBkcml2ZXIgcmV2aWV3IHRoZSBh
Y2N1cmFjeSBvZmZlcmVkIGJ5IG1vbml0b3IgYW5kIGlmIG1lZXRzIHRoZQ0KICAgID4gZXhwZWN0
YXRpb24sIHRoZXkgY2FuIGFsd2F5cyBlbmFibGUgaXQu4oCdDQoNCiAgICBJIHdvdWxkIG11Y2gg
bW9yZSBwcmVmZXIgc29tZXRoaW5nIGxpa2UuLi4NCg0KICAgIFRoZSBvdmVyIHZvbHRhZ2UgaW50
ZXJydXB0IGlzIGVuYWJsZWQsIGJ1dCBpZiBpdCBldmVyeSBvY2N1cnMsIHRoZXJlIGlzDQogICAg
bm8gY29kZSB0byBtYWtlIHVzZSBvZiBpdC4gU28gcmVtb3ZlIHRoZSBwb2ludGxlc3MgZW5hYmxp
bmcgb2YgaXQuIEl0DQogICAgY2FuIHJlLWVuYWJsZWQgd2hlbiBIV01PTiBzdXBwb3J0IGlzIGFk
ZGVkLiBGb3IgdGhlIHNhbWUgcmVhc29uLA0KICAgIGVuYWJsaW5nIG9mIHRoZSBpbnRlcnJ1cHRz
IERQODM4MTFfUlhfRVJSX0hGX0lOVF9FTiwNCiAgICBEUDgzODExX01TX1RSQUlOSU5HX0lOVF9F
TiwgRFA4MzgxMV9FU0RfRVZFTlRfSU5UX0VOLA0KICAgIERQODM4MTFfRU5FUkdZX0RFVF9JTlRf
RU4sIERQODM4MTFfTElOS19RVUFMX0lOVF9FTiwNCiAgICBEUDgzODExX0pBQkJFUl9ERVRfSU5U
X0VOLCBEUDgzODExX1BPTEFSSVRZX0lOVF9FTiwNCiAgICBEUDgzODExX1NMRUVQX01PREVfSU5U
X0VOLCBEUDgzODExX09WRVJURU1QX0lOVF9FTiwNCiAgICBEUDgzODExX1VOREVSVk9MVEFHRV9J
TlRfRU4gaXMgYWxzbyByZW1vdmVkLCBzaW5jZSB0aGVyZSBpcyBubyBjb2RlDQogICAgd2hpY2gg
YWN0cyBvbiB0aGVzZSBpbnRlcnJ1cHRzLg0KDQogICAgQW5kIHVwZGF0ZSB0aGUgcGF0Y2ggdG8g
Zml0Lg0KDQogICAgICAgICAgQW5kcmV3DQoNCg==
