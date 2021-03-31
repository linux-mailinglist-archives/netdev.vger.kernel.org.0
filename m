Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5279435084B
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbhCaUhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:37:37 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:41740 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236646AbhCaUhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 16:37:01 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 12VKatru046155;
        Wed, 31 Mar 2021 15:36:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1617223015;
        bh=VrV32HcQ0YfVxFlp6rZ7lPD0kqMVx6MfLchHYHN4mdY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=VXs9rNAVzFNlKvgrRh4SNlI15PdJP5CBVRj47gs45IBLxvGpCaahu+F0i0n0Haj0v
         2meVDlYqA/FTYEkeSFLUU6L0w3Q3Zq0csyRwSQ2Ql7UW6h0tJf+sjYU82xhlCwjXBk
         vO8NQY5pZNaJwEheMJ9rnHb0ArqJTMtdaKVSwdII=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 12VKat7D062625
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 31 Mar 2021 15:36:55 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 31
 Mar 2021 15:36:54 -0500
Received: from DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14]) by
 DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14%17]) with mapi id
 15.01.2176.009; Wed, 31 Mar 2021 15:36:54 -0500
From:   "Modi, Geet" <geet.modi@ti.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Bajjuri, Praneeth" <praneeth@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] net: phy: dp83867: perform
 soft reset and retain established link
Thread-Topic: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] net: phy: dp83867: perform
 soft reset and retain established link
Thread-Index: AQHXIEkHsYDk3zUxz02zzii3IeTCVaqTZs4AgAq/KYCAAIUUgP//zgaA
Date:   Wed, 31 Mar 2021 20:36:54 +0000
Message-ID: <4838EA12-7BF4-4FF2-8305-7446C3498DDF@ti.com>
References: <20210324010006.32576-1-praneeth@ti.com>
 <YFsxaBj/AvPpo13W@lunn.ch> <404285EC-BBF0-4482-8454-3289C7AF3084@ti.com>
 <YGSk4W4mW8JQPyPl@lunn.ch>
In-Reply-To: <YGSk4W4mW8JQPyPl@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.47.21031401
x-originating-ip: [10.250.200.196]
x-exclaimer-md-config: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8FCBD488C65514993E1F9B72EA00FEC@owa.mail.ti.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpJZiBMaW5rIGlzIHByZXNlbnQsIHRoZSBjdXJyZW50IHJlc2V0IHdpbGwg
cmVzZXQgdGhlIHJlZ2lzdGVycyBpbmNsdWRpbmcgdGhlIGxpbmsgYW5kIEhvc3Qgd2lsbCBuZWVk
IHRvIHJlLXByb2dyYW0gYWxsIHRoZSByZWdpc3RlcnMuIFdpdGggdGhlIGNoYW5nZSBwcm9wb3Nl
ZCwgaXQgd2lsbCByZXNldCB0aGUgc3RhdGUgbWFjaGluZSB3aGlsZSBrZWVwaW5nIHRoZSByZWdp
c3RlciBjb250ZW50Lg0KDQpNeSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQgYmVsb3cgQVBJIGlzIGNh
bGxlZCB0byBwZXJmb3JtIHRoZSBzb2Z0IHJlc2V0IGFuZCBub3QgY29tcGxldGUgd2lwZSBvZiBQ
SFkuIERvIHlvdSBhZ3JlZSA/DQoNCg0KLnNvZnRfcmVzZXQJPSBkcDgzODY3X3BoeV9yZXNldCwN
Cg0KDQpSZWdhcmRzLA0KR2VldA0KDQoNCg0KU2VlIGJlbG93IGRpZmZlcmVuY2UgYmV0d2VlbiB0
aGUgdHdvIHJlc2V0IGZyb20gRFA4Mzg2NyBkYXRhc2hlZXQuDQoNCjguNS41LjMgR2xvYmFsIFNv
ZnR3YXJlIFJlc2V0DQpBIGdsb2JhbCBzb2Z0d2FyZSByZXNldCBpcyBhY2NvbXBsaXNoZWQgYnkg
c2V0dGluZyBiaXQgMTUgb2YgcmVnaXN0ZXIgQ1RSTCAoYWRkcmVzcyAweDAwMUYpIHRvIDEuIFRo
aXMgYml0IHJlc2V0cw0KYWxsIHRoZSBpbnRlcm5hbCBjaXJjdWl0cyBpbiB0aGUgUEhZIGluY2x1
ZGluZyBJRUVFLWRlZmluZWQgcmVnaXN0ZXJzIGFuZCBhbGwgdGhlIGV4dGVuZGVkIHJlZ2lzdGVy
cy4gVGhlIGdsb2JhbA0Kc29mdHdhcmUgcmVzZXQgcmVzZXRzIHRoZSBkZXZpY2Ugc3VjaCB0aGF0
IGFsbCByZWdpc3RlcnMgYXJlIHJlc2V0IHRvIGRlZmF1bHQgdmFsdWVzIGFuZCB0aGUgaGFyZHdh
cmUgY29uZmlndXJhdGlvbg0KdmFsdWVzIGFyZSBtYWludGFpbmVkLg0KOC41LjUuNCBHbG9iYWwg
U29mdHdhcmUgUmVzdGFydA0KQSBnbG9iYWwgc29mdHdhcmUgcmVzdGFydCBpcyBhY2NvbXBsaXNo
ZWQgYnkgc2V0dGluZyBiaXQgMTQgb2YgcmVnaXN0ZXIgQ1RSTCAoMHgwMDFGKSB0byAxLiBUaGlz
IGFjdGlvbiByZXNldHMgYWxsDQp0aGUgUEhZIGNpcmN1aXRzIGV4Y2VwdCB0aGUgcmVnaXN0ZXJz
IGluIHRoZSBSZWdpc3RlciBGaWxlLg0KDQoNCg0KDQpJbiBEUDgzODIyIGxpbnV4LCB0aGUgQVBJ
IGlzIGNhbGxpbmcgdGhlIHNvZnR3YXJlIHJlc2V0IGFuZCB3ZSBhcmUgYWxpZ25pbmcgRFA4Mzg2
NyBpbXBsZW1lbnRhaXRvbiB3aXRoIERQODM4MjIuDQoNCg0KUmVnYXJkcywNCkdlZXQNCg0KDQoN
Cu+7v09uIDMvMzEvMjEsIDk6MzUgQU0sICJBbmRyZXcgTHVubiIgPGFuZHJld0BsdW5uLmNoPiB3
cm90ZToNCg0KICAgID4gICAgID4gYXMgcGVyIGRhdGFzaGVldDogaHR0cHM6Ly93d3cudGkuY29t
L2xpdC9kcy9zeW1saW5rL2RwODM4Njdjci5wZGYNCiAgICA+IA0KICAgID4gICAgID4gOC42LjI2
IENvbnRyb2wgUmVnaXN0ZXIgKENUUkwpDQogICAgPiAgICAgPiBkbyBTV19SRVNUQVJUIHRvIHBl
cmZvcm0gYSByZXNldCBub3QgaW5jbHVkaW5nIHRoZSByZWdpc3RlcnMgYW5kIGlzDQogICAgPiAg
ICAgPiBhY2NlcHRhYmxlIHRvIGRvIHRoaXMgaWYgYSBsaW5rIGlzIGFscmVhZHkgcHJlc2VudC4N
CiAgICA+IA0KICAgID4gIA0KICAgID4gDQogICAgPiAgICAgSSBkb24ndCBzZWUgYW55IGNvZGUg
aGVyZSB0byBkZXRlcm1pbmUgaWYgdGhlIGxpa2UgaXMgcHJlc2VudC4gV2hhdCBpZg0KICAgID4g
ICAgIHRoZSBjYWJsZSBpcyBub3QgcGx1Z2dlZCBpbj8NCiAgICA+IA0KICAgID4gICAgIFRoaXMg
QVBJIGlzIHByaW1hcmlseSB1c2VkIGZvciByZXNldC4gTGluayBTdGF0dXMgaXMgY2hlY2tlZCB0
aHJ1IGRpZmZlcmVudA0KICAgID4gcmVnaXN0ZXIuIFRoaXMgc2hhbGwgbm90IGltcGFjdCB0aGUg
Y2FibGUgcGx1ZyBpbi9vdXQuIFdpdGggdGhpcyBjaGFuZ2UsIGl0DQogICAgPiB3aWxsIGFsaWdu
IHdpdGggRFA4MzgyMiBkcml2ZXIgQVBJLg0KDQogICAgU28gd2h5IGlzIHRoZXJlIHRoZSBjb21t
ZW50Og0KDQogICAgPiAgICAgPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgYW5kIGlzDQogICAgPiAgICAgPiBhY2NlcHRhYmxlIHRvIGRvIHRoaXMgaWYgYSBsaW5r
IGlzIGFscmVhZHkgcHJlc2VudC4NCg0KICAgIFRoYXQga2luZCBvZiBzYXlzLCBpdCBpcyBub3Qg
YWNjZXB0YWJsZSB0byBkbyB0aGlzIGlmIHRoZSBsaW5rIGlzIG5vdA0KICAgIHByZXNlbnQuIFdo
aWNoIGlzIHdoeSBpJ20gYXNraW5nLg0KDQogICAgCSBBbmRyZXcNCg0K
