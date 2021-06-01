Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2937C397D3C
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 01:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhFAXym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 19:54:42 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:53018 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235137AbhFAXyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 19:54:40 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 151Nqr6w109565;
        Tue, 1 Jun 2021 18:52:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1622591573;
        bh=R/TwjtddTVGHWakjw/FOW9ucHapL5nru4HxdLWEtUmA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=h1+Dp/xf+FNy4+jDoACDBTqOzqEMMmBKr+I7OTmPjpd6DvB8RAq1z0CtsUItPvqVT
         E9zql7cYc4ESmyozmOtkezpj9+ynHjJT7spIv+FFz43NjSLXKv8yAxngijzSe/psmx
         yhecXz4LOT852SDpP76fiZ5RIZ75o3aMbbLQPS1c=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 151Nqra9118447
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 1 Jun 2021 18:52:53 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 1 Jun
 2021 18:52:52 -0500
Received: from DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14]) by
 DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14%17]) with mapi id
 15.01.2176.012; Tue, 1 Jun 2021 18:52:52 -0500
From:   "Modi, Geet" <geet.modi@ti.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Bajjuri, Praneeth" <praneeth@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] net: phy:
 dp83867: perform soft reset and retain established link
Thread-Topic: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] net: phy:
 dp83867: perform soft reset and retain established link
Thread-Index: AQHXU98FVTwb14DGTkOIv0rsFlldQar5b8+A//+PhQCABmhVAIAAej4A///XSQA=
Date:   Tue, 1 Jun 2021 23:52:52 +0000
Message-ID: <5A01E985-7215-4926-98F7-3F776E06A436@ti.com>
References: <20210324010006.32576-1-praneeth@ti.com>
 <YFsxaBj/AvPpo13W@lunn.ch> <404285EC-BBF0-4482-8454-3289C7AF3084@ti.com>
 <YGSk4W4mW8JQPyPl@lunn.ch> <3494dcf6-14ca-be2b-dbf8-dda2e208b70b@ti.com>
 <YLEf128OEADi0Kb1@lunn.ch> <5480BEB5-B540-4BB6-AC32-65CB27439270@ti.com>
 <EC713CBF-D669-4A0E-ADF2-093902C03C49@ti.com> <YLaICrmU8ND+66mU@lunn.ch>
In-Reply-To: <YLaICrmU8ND+66mU@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.49.21050901
x-originating-ip: [10.250.200.196]
x-exclaimer-md-config: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9267D983B21EC4AAD90EBC921C49109@owa.mail.ti.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UHJhbmVldGgsDQoNCkNhbiB5b3UgcGxlYXNlIGhlbHAgZWRpdCB0aGUgY29tbWVudCBhbmQgcmVz
dWJtaXQgZm9yIGFwcHJvdmFsID8NCg0KUmVnYXJkcywNCkdlZXQNCg0KDQrvu79PbiA2LzEvMjEs
IDEyOjE4IFBNLCAiQW5kcmV3IEx1bm4iIDxhbmRyZXdAbHVubi5jaD4gd3JvdGU6DQoNCiAgICBP
biBUdWUsIEp1biAwMSwgMjAyMSBhdCAwNzowMTowNFBNICswMDAwLCBNb2RpLCBHZWV0IHdyb3Rl
Og0KICAgID4gSGVsbG8gQW5kcmV3LA0KICAgID4gDQogICAgPiAgDQogICAgPiANCiAgICA+IFBs
ZWFzZSBsZXQgbWUga25vdyBpZiB5b3UgaGF2ZSBhZGRpdGlvbmFsIHF1ZXN0aW9ucy9jbGFyaWZp
Y2F0aW9ucyB0byBhcHByb3ZlDQogICAgPiBiZWxvdyBjaGFuZ2UgcmVxdWVzdC4NCiAgICA+IA0K
ICAgID4gIA0KICAgID4gDQogICAgPiBSZWdhcmRzLA0KICAgID4gR2VldA0KICAgID4gDQogICAg
PiAgDQogICAgPiANCiAgICA+ICANCiAgICA+IA0KICAgID4gRnJvbTogR2VldCBNb2RpIDxnZWV0
Lm1vZGlAdGkuY29tPg0KICAgID4gRGF0ZTogRnJpZGF5LCBNYXkgMjgsIDIwMjEgYXQgMTA6MTAg
QU0NCiAgICA+IFRvOiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+LCAiQmFqanVyaSwgUHJh
bmVldGgiIDxwcmFuZWV0aEB0aS5jb20+DQogICAgPiBDYzogIkRhdmlkIFMgLiBNaWxsZXIiIDxk
YXZlbUBkYXZlbWxvZnQubmV0PiwgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4sDQog
ICAgPiAibmV0ZGV2QHZnZXIua2VybmVsLm9yZyIgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+LA0K
ICAgID4gImxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmciIDxsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnPg0KICAgID4gU3ViamVjdDogUmU6IFtFWFRFUk5BTF0gUmU6IFtFWFRFUk5BTF0g
UmU6IFtQQVRDSF0gbmV0OiBwaHk6IGRwODM4Njc6IHBlcmZvcm0NCiAgICA+IHNvZnQgcmVzZXQg
YW5kIHJldGFpbiBlc3RhYmxpc2hlZCBsaW5rDQoNCiAgICBTbyB0aGlzIGFsbCBzZWVtcyB0byBi
b2lsIGRvd24gdG8sIGl0IGRvZXMgbm90IG1hdHRlciBpZiBpdCBpcw0KICAgIGFjY2VwdGFibGUg
b3Igbm90LCB5b3UgYXJlIGdvaW5nIHRvIGRvIGl0LiBTbyBwbGVhc2UganVzdCByZW1vdmUgdGhh
dA0KICAgIHBhcnQgb2YgdGhlIGNvbW1lbnQuIEl0IGhhcyBubyB2YWx1ZS4NCg0KICAgIAkgQW5k
cmV3DQoNCg==
