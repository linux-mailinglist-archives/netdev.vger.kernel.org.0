Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B48D35D9B
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 15:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbfFENNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 09:13:32 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:43600 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727740AbfFENNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 09:13:32 -0400
Received: from mailhost.synopsys.com (dc2-mailhost1.synopsys.com [10.12.135.161])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C0627C0B50;
        Wed,  5 Jun 2019 13:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559740422; bh=mh42QUvXWlbA4/Dvy1RLLMUvXyOiaZoLvd+Q77x88KU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=et+aK2S7dIEvIxkpfYu0ZdcdLWn8dgGITMkaVMFivs6/u52mZiqr+BGxXAK2lvAC9
         d8rYQTkZzzvVSJ8iDq7qF3FNT8ju49oFg3+X1xFmxuHKttMpBY2/z3M2YOQenYPSze
         hyUETVKNawbMK9vCcI1OKHNodNZ4dmp3SIvhDG0Q7wVhU1w6k16jw9Bge0q+pqEoUy
         qY9EDKwBmVwnSVqg9/D4JiTU8Lsk9muibY5Q393I5czBTw/62w7EZCni8GvTGYy5LE
         tIGd2TnoqwZW/XM+h7qxwXgPecdKwvNhGLvvBr3Op/vtyd2BfiBZ0QeArYtXw4FMQa
         2AIIyW0USLnrQ==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 17C24A0070;
        Wed,  5 Jun 2019 13:13:27 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 5 Jun 2019 06:13:26 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Wed,
 5 Jun 2019 15:13:24 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "Kweh Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH net-next v6 2/5] net: stmmac: introducing support for
 DWC xPCS logics
Thread-Topic: [PATCH net-next v6 2/5] net: stmmac: introducing support for
 DWC xPCS logics
Thread-Index: AQHVGsR5qibwMaoNx0yOto7uqjBITaaL1fgAgAE08AA=
Date:   Wed, 5 Jun 2019 13:13:22 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B93EF69@DE02WEMBXB.internal.synopsys.com>
References: <1559674736-2190-1-git-send-email-weifeng.voon@intel.com>
 <1559674736-2190-3-git-send-email-weifeng.voon@intel.com>
 <05cf54dc-7c40-471e-f08a-7fdf5fe4ef54@gmail.com>
In-Reply-To: <05cf54dc-7c40-471e-f08a-7fdf5fe4ef54@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQoNCj4gK1J1c3Nl
bGwsDQo+IA0KPiBPbiA2LzQvMjAxOSAxMTo1OCBBTSwgVm9vbiBXZWlmZW5nIHdyb3RlOg0KPiA+
IEZyb206IE9uZyBCb29uIExlb25nIDxib29uLmxlb25nLm9uZ0BpbnRlbC5jb20+DQo+ID4gDQo+
ID4geFBDUyBpcyBEV0MgRXRoZXJuZXQgUGh5c2ljYWwgQ29kaW5nIFN1YmxheWVyIHRoYXQgbWF5
IGJlIGludGVncmF0ZWQNCj4gPiBpbnRvIGEgR2JFIGNvbnRyb2xsZXIgdGhhdCB1c2VzIERXQyBF
UW9TIE1BQyBjb250cm9sbGVyLiBBbiBleGFtcGxlIG9mDQo+ID4gSFcgY29uZmlndXJhdGlvbiBp
cyBzaG93biBiZWxvdzotDQo+ID4gDQo+ID4gICA8LS0tLS0tLS0tLS0tLS0tLS1HQkUgQ29udHJv
bGxlci0tLS0tLS0tLS0+fDwtLUV4dGVybmFsIFBIWSBjaGlwLS0+DQo+ID4gDQo+ID4gICArLS0t
LS0tLS0tLSsgICAgICAgICArLS0tLSsgICAgKy0tLSsgICAgICAgICAgICAgICArLS0tLS0tLS0t
LS0tLS0rDQo+ID4gICB8ICAgRVFvUyAgIHwgPC1HTUlJLT58IERXIHw8LS0+fFBIWXwgPC0tIFNH
TUlJIC0tPiB8IEV4dGVybmFsIEdiRSB8DQo+ID4gICB8ICAgTUFDICAgIHwgICAgICAgICB8eFBD
U3wgICAgfElGIHwgICAgICAgICAgICAgICB8IFBIWSBDaGlwICAgICB8DQo+ID4gICArLS0tLS0t
LS0tLSsgICAgICAgICArLS0tLSsgICAgKy0tLSsgICAgICAgICAgICAgICArLS0tLS0tLS0tLS0t
LS0rDQo+ID4gICAgICAgICAgXiAgICAgICAgICAgICAgIF4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgXg0KPiA+ICAgICAgICAgIHwgICAgICAgICAgICAgICB8ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwNCj4gPiAgICAgICAgICArLS0tLS0tLS0tLS0tLS0tLS0t
LS0tTURJTy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rDQo+ID4gDQo+ID4geFBDUyBpcyBhIENs
YXVzZS00NSBNRElPIE1hbmFnZWFibGUgRGV2aWNlIChNTUQpIGFuZCB3ZSBuZWVkIGEgd2F5IHRv
DQo+ID4gZGlmZmVyZW50aWF0ZSBpdCBmcm9tIGV4dGVybmFsIFBIWSBjaGlwIHRoYXQgaXMgZGlz
Y292ZXJlZCBvdmVyIE1ESU8uDQo+ID4gVGhlcmVmb3JlLCB4cGNzX3BoeV9hZGRyIGlzIGludHJv
ZHVjZWQgaW4gc3RtbWFjIHBsYXRmb3JtIGRhdGENCj4gPiAocGxhdF9zdG1tYWNlbmV0X2RhdGEp
IGZvciBkaWZmZXJlbnRpYXRpbmcgeFBDUyBmcm9tICdwaHlfYWRkcicgdGhhdA0KPiA+IGJlbG9u
Z3MgdG8gZXh0ZXJuYWwgUEhZLg0KPiANCj4gQXNzdW1pbmcgdGhpcyBEVyB4UENTIGNhbiBiZSBm
b3VuZCB3aXRoIGRlc2lnbnMgb3RoZXIgdGhhbiBTVE1NQUMgd291bGQNCj4gbm90IGl0IG1ha2Ug
c2Vuc2UgdG8gbW9kZWwgdGhpcyBhcyBzb21lIGtpbmQgb2YgUEhZL01ESU8gYnJpZGdlPyBBDQo+
IGxpdHRsZSBiaXQgbGlrZSB3aGF0IGRyaXZlcnMvbmV0L3BoeS94aWxpbnhfZ21paTJyZ21paS5j
IHRyaWVzIHRvIGRvPw0KDQpZZXMsIERXIFhQQ1MgaXMgYSBzZXBhcmF0ZSBJUCB0aGF0IGNhbiBi
ZSBzb2xkIHdpdGhvdXQgdGhlIE1BQy4NCg0KVGhhbmtzLA0KSm9zZSBNaWd1ZWwgQWJyZXUNCg==
