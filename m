Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5E4406555
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 03:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhIJBnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 21:43:25 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:35538 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhIJBnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 21:43:22 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 18A1g6Qb098422;
        Thu, 9 Sep 2021 20:42:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1631238126;
        bh=T2O7Vgkw8W6SU2hJ+lMl1dxjW6VuIFMJa+2lb+T3+O8=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=jjbqEEOQLqnRnQ3DuzdjcKMRZThx2qZzPw2xhsjZi89ToOx61dtVhuGAQHBwvRXSP
         TfL5ZLNHGW1PXykZHhzZRAqKhLZXkKIsnAYRn5mvuihwWdWG/yYIECOkscN1x4mMLA
         hoqDvuSNtKGsqp+KUJlK1Dvv0x9LzuwsSQgajYTo=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 18A1g5Ei004711
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 Sep 2021 20:42:05 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 9
 Sep 2021 20:42:05 -0500
Received: from DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14]) by
 DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14%17]) with mapi id
 15.01.2308.014; Thu, 9 Sep 2021 20:42:05 -0500
From:   "Modi, Geet" <geet.modi@ti.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Nagalla, Hari" <hnagalla@ti.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sharma, Vikram" <vikram.sharma@ti.com>,
        "dmurphy@ti.com" <dmurphy@ti.com>
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re:
 [PATCH] net: phy: dp83tc811: modify list of interrupts enabled at
 initialization
Thread-Topic: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re:
 [PATCH] net: phy: dp83tc811: modify list of interrupts enabled at
 initialization
Thread-Index: AQHXoC4XSSkBWxKBYUuzA52mb5z+zauRtoAAgAWhA4CAAZ4BAIADCCgAgACK0YD//66ZAIAAo1YA//+NyAA=
Date:   Fri, 10 Sep 2021 01:42:05 +0000
Message-ID: <4FD7DBD6-C10A-44D8-BD3C-59751BA8FE5A@ti.com>
References: <20210902190944.4963-1-hnagalla@ti.com> <YTFc6pyEtlRO/4r/@lunn.ch>
 <99232B33-1C2F-45AF-A259-0868AC7D3FBC@ti.com> <YTdxBMVeqZVyO4Tf@lunn.ch>
 <E61A9519-DBA6-4931-A2A0-78856819C362@ti.com> <YTpwjWEUmJWo0mwr@lunn.ch>
 <E3DBDC45-111F-4744-82A8-95C7D5CCEBE5@ti.com> <YTq1SATpNvwo+ojg@lunn.ch>
In-Reply-To: <YTq1SATpNvwo+ojg@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.52.21080801
x-originating-ip: [10.250.200.196]
x-exclaimer-md-config: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CC37384FBD9994681053968656F88CB@owa.mail.ti.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpQbGVhc2UgYmUgYXNzdXJlIHRoZSBtb25pdG9ycyBhcmUgcGFydCBvZiB0
aGUgUEhZIGFuZCB3ZWxsIGNhcHR1cmVkIGluIGRldmljZSBkYXRhc2hlZXQuICAgVGhlIG9ubHkg
cmVhc29uIHRvIGdvIHNlbGVjdGl2ZWx5IGlzIGFzIHdlIGhhdmUgbm90IGNhcmVmdWxseSByZXZp
ZXdlZCB0aGUgb3RoZXIgIGludGVycnVwdHMgdXNhZ2UgYnkgYXBwbGljYXRpb24sIGhlbmNlIGRv
bid0IHdhbnQgdG8gbWFrZSB0aGUgY2hhbmdlIGluIGhhc3RlLg0KDQpSZWdhcmRzLA0KR2VldA0K
DQoNCg0KDQrvu79PbiA5LzkvMjEsIDY6MzEgUE0sICJBbmRyZXcgTHVubiIgPGFuZHJld0BsdW5u
LmNoPiB3cm90ZToNCg0KICAgIE9uIEZyaSwgU2VwIDEwLCAyMDIxIGF0IDEyOjQxOjUzQU0gKzAw
MDAsIE1vZGksIEdlZXQgd3JvdGU6DQogICAgPiBIaSBBbmRyZXcsDQogICAgPiANCiAgICA+IEFz
IG1lbnRpb25lZCB3ZSB3YW50IHRvIGRvIHRoaXMgaW4gcGhhc2VzOiANCiAgICA+IGEpIHRoaXMg
cGF0Y2ggdG8gZGlzYWJsZSB0aGUgT3ZlcnZvbHRhZ2UgZHJpdmVyIGludGVycnVwdA0KICAgID4g
YikgQWZ0ZXIgY2FyZWZ1bGx5IGNvbnNpZGVyaW5nIG90aGVyIGludGVycnVwdHMsIHBsYW4gYSAg
Zm9sbG93LW9uIHBhdGNoIHRvIHRha2UgY2FyZSBvZiBvdGhlciBpbnRlcnJ1cHRzLg0KDQogICAg
SSBzdGlsbCBkb24ndCBnZXQgaXQuIFdoeSBqdXN0IE92ZXIgdm9sdCBub3cgYW5kIG5vdCB0aGUg
cmVzdCwgd2hpY2gNCiAgICBhcmUgZXF1YWxseSB1c2VsZXNzPyBJdCBtYWtlcyBtZSB0aGluayB0
aGVyZSBpcyBzb21ldGhpbmcgc2VyaW91c2x5DQogICAgd3Jvbmcgd2l0aCBvdmVyIHZvbHRhZ2Us
IHdoaWNoIHlvdSBhcmUgbm90IHRlbGxpbmcgdXMgYWJvdXQuIE1heWJlIGFuDQogICAgaW50ZXJy
dXB0IHN0b3JtPyBJZiB0aGVyZSBpcyBzb21ldGhpbmcgYnJva2VuIGhlcmUsIHRoaXMgcGF0Y2gg
bmVlZHMNCiAgICB0byBiZSBiYWNrIHBvcnRlZCB0byBzdGFibGUuDQoNCiAgICAgICBBbmRyZXcN
Cg0K
