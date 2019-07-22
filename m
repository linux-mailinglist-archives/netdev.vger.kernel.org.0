Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE02D701D4
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 15:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbfGVN60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 09:58:26 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:40974 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728637AbfGVN60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 09:58:26 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6F25AC01A1;
        Mon, 22 Jul 2019 13:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563803905; bh=HgFtNavLipDNVv1A+94DLM7wbcSsuao5VrGfXlJZir0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=clhnYGa7ZZ3o4146qpTpXkf1yMllY0RBAhUs+Zrj8dvV4igBLnkNjyEkwSLo8zhaa
         t9BtYZllt324Hi8I6f66AN65RJLrFa6BemSX3suMV7MAJjB3sAP/k2AZrH53aKgu2q
         IKWA5sxV4AJu48vi5RLl8QjHYeEOzRatnyTmnsTInQfMIFAUQvYOF+5WdZizpqoBr+
         P6N4/sd0gjh5tEK3ts5G4eUPdCKDQqvLl5zlyG7aJBJyHivA4n4GwJHUtCVhaDxcUl
         RHE9a8ZIAExHbd57BDUIRtxzee9aw18nzZf2CyaIst90hnVnGtzQ0K6qc1VqpeVmBF
         QKRnpx+Sqexzg==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7A199A023B;
        Mon, 22 Jul 2019 13:58:23 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 22 Jul 2019 06:58:23 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 22 Jul 2019 06:58:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abo4NsCeTdsIkQ3yGKoqcI7oH4eRizG8eVNHNIs8l20GPKPuP06FW/kxkaSxqAza7RC1kiYzTjoDXL3Yy4Qfm4wjYWOIFL/kzrL+7BH0HiIztX8/ikIuLpQLzD6nb9vbbAi3Es2gc2m4QbzqdWnPjO980GU9zqXAHcqS32BLIVdhxtVOLF/tvTY4hvJ6h3HDVETrB19Hpy9OYS6We+7m0UXtCVKyHlNhd7MrABrRuO+TGlqcc0fFV4zoi2agZjUGGKI6lCTIlxCHn8+R+6IEJHyZoGwPGyhulT+KXVHVvANr4MpIlrd3tlqLPuWGKmdC5kh9o3VlPYiKYv+M0xGu3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgFtNavLipDNVv1A+94DLM7wbcSsuao5VrGfXlJZir0=;
 b=UoZsB9yMIXZKfbwq6iFGZVnvlh8QLjoZOYa+Y/k+5LkEMbLu/6oIQtCR1gebiHnCOfuoVTO3RTnR5aXT5EHj0jtrsf71EJMoreUTZlyWwFhr/SS9S62Cw9g0yPZNqj5o/IHPhn76xw0ofe12qVsVBIRhv/KlHtb1reOY/NYNL2xZdXtEbyZfH2LFJANmZX+WsJJ7uOiTuMRWBSwNW3mjZ4iE0JFDmaqA6DGSo7ASsNVeHOelTIdHIbyTmTs/IZ9a1z7fcE3sf1mCgIro8H8pORMgC9Ns7El52wHdJN85X0h1dOlYlyKeS63YAEIOpIm6TvSZYTxMB2Cl4RtQvEVPeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgFtNavLipDNVv1A+94DLM7wbcSsuao5VrGfXlJZir0=;
 b=kfC+JV4p3hIwY1RcGbpulkoun/4Vf7Cu5CUjvvjILf0YbYGfBsI0xNb5xZ3l1jwp4WlwNlAsHMB3Cq/vkvi2MzYVBN7FZfjWjMmu/8hSPWbxsimBmzPJWRz6625pe6zCZqcq1oCNEcZfPFxmWDgDSc4Gq32aAjzhECQrj2EKDQU=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3187.namprd12.prod.outlook.com (20.179.64.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 22 Jul 2019 13:58:21 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2094.013; Mon, 22 Jul 2019
 13:58:21 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>
CC:     =?utf-8?B?T25kxZllaiBKaXJtYW4=?= <megi@xff.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Thread-Topic: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Thread-Index: AQHVIGkCReoXsI1ev0mBbW+MAvwZAqbW1RMAgAALU8CAAATNgIAAAL0g
Date:   Mon, 22 Jul 2019 13:58:20 +0000
Message-ID: <BN8PR12MB3266678A3ABD0EBF429C9766D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <20190722124240.464e73losonwb356@core.my.home>
 <BN8PR12MB32660B12F8E2617ED42249BBD3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722134023.GD8972@lunn.ch>
In-Reply-To: <20190722134023.GD8972@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 835b6327-8e37-47e3-ef12-08d70eaca7f3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3187;
x-ms-traffictypediagnostic: BN8PR12MB3187:
x-microsoft-antispam-prvs: <BN8PR12MB3187846490C51FE83A340094D3C40@BN8PR12MB3187.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(396003)(366004)(376002)(199004)(189003)(11346002)(76176011)(8936002)(6636002)(476003)(81166006)(81156014)(33656002)(486006)(2906002)(99286004)(446003)(4744005)(6436002)(6506007)(14454004)(229853002)(71200400001)(71190400001)(26005)(102836004)(66066001)(186003)(7416002)(4326008)(5660300002)(55016002)(6246003)(53936002)(86362001)(54906003)(7696005)(3846002)(8676002)(9686003)(110136005)(316002)(68736007)(6116002)(7736002)(66946007)(25786009)(76116006)(52536014)(305945005)(74316002)(66476007)(66556008)(256004)(478600001)(66446008)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3187;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rOdIy68xsuL7MuslvCx0DXa5sN5hWV0NiSKo2NV2Kru70RBoZnjUBJxleXAQoJfkB3lWzoJDpAv/u9JomTXlpkBB+CsdiBs9EmbwhunT65v+Q2Jsnjtf8vZKWRaFvyTUdBIwVrb5vYgnDCr4J9hurS30mobVH7Q3HJmTLohmoS7sDQg+IDLEagZCRXN7m5osCTfSWj/BC3Da4z5rbvAvj6Xt3aql8JGIoPxQ7JU6CdAZ1wh3Kr3Tp8HZCl6xyAdPgqKHiZSiDBVxYqkycasmo5hU/vPPd6u4pXAl6tE0zvKNuQvXHsMtsTcsNy2nV6ejyIXp5/LLbi3rNedf51psIRi2DYKA5MJMyhlro70nNUSqlfZLjQ3tK4IPMALEuRnDCcc/f7+aI1yvs2Ud8zdJlpOejmRZxpDYZ/tIVmBuKq4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 835b6327-8e37-47e3-ef12-08d70eaca7f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 13:58:20.9270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3187
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KRGF0ZTogSnVsLzIyLzIwMTksIDE0
OjQwOjIzIChVVEMrMDA6MDApDQoNCj4gRG9lcyB0aGlzIG1lYW4gdGhhdCBhbGwgc3RtbWFjIHZh
cmlhbnRzIHN1cHBvcnQgMUc/IFRoZXJlIGFyZSBub25lDQo+IHdoaWNoIGp1c3Qgc3VwcG9ydCBG
YXN0IEV0aGVybmV0Pw0KDQpUaGlzIGdsdWUgbG9naWMgZHJpdmVycyBzb21ldGltZXMgcmVmbGVj
dCBhIGN1c3RvbSBJUCB0aGF0J3MgU3lub3BzeXMgDQpiYXNlZCBidXQgbW9kaWZpZWQgYnkgY3Vz
dG9tZXIsIHNvIEkgY2FuJ3Qga25vdyBiZWZvcmUtaGFuZCB3aGF0J3MgdGhlIA0Kc3VwcG9ydGVk
IG1heCBzcGVlZC4gVGhlcmUgYXJlIHNvbWUgb2xkIHZlcnNpb25zIHRoYXQgZG9uJ3Qgc3VwcG9y
dCAxRyANCmJ1dCBJIGV4cGVjdCB0aGF0IFBIWSBkcml2ZXIgbGltaXRzIHRoaXMgLi4uDQoNCj4g
SSdtIGFsc28gbm90IHN1cmUgdGhlIGNoYW5nZSBmaXRzIHRoZSBwcm9ibGVtLiBXaHkgZGlkIGl0
IG5vdA0KPiBuZWdvdGlhdGUgMTAwRlVMTCByYXRoZXIgdGhhbiAxMEhhbGY/IFlvdSBhcmUgb25s
eSBtb3ZpbmcgdGhlIDFHDQo+IHNwZWVkcyBhcm91bmQsIHNvIDEwMCBzcGVlZHMgc2hvdWxkIG9m
IGJlZW4gYWR2ZXJ0aXNlZCBhbmQgc2VsZWN0ZWQuDQoNCkhtbSwgbm93IHRoYXQgSSdtIGxvb2tp
bmcgYXQgaXQgY2xvc2VyIEkgYWdyZWUgd2l0aCB5b3UuIE1heWJlIGxpbmsgDQpwYXJ0bmVyIG9y
IFBIWSBkb2Vzbid0IHN1cHBvcnQgMTAwTSA/DQoNCkl0J3Mgd29ya2luZyBmb3IgT25kcmVqIGJ1
dCBJIGdvdCBjdXJpb3VzIG5vdyAuLi4NCg0KLS0tDQpUaGFua3MsDQpKb3NlIE1pZ3VlbCBBYnJl
dQ0K
