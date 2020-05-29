Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080E61E7C2A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgE2LpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:45:13 -0400
Received: from mail-eopbgr40052.outbound.protection.outlook.com ([40.107.4.52]:21287
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725562AbgE2LpM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:45:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTxKG/b7rgB2QuTVckde7+xWQzBoISWaDwrM1fXqUscY5Z99iTuG7cMpwfIEGQ6B4c8jphIbT862RfT3D947NjjTSzdf6aUVPoFkSDCw8ANVB2rQDXkraqnX7mbJSbrOEfjRD85Sjv8WW2QIarnvk4rPIqRLmg1qBEzGxS6BjRamobL2AjdCraFeC31AQmkS0CIbRFy48dC4hx2BbyjuZPSyGS2lr0GaVFV3U0wLZSnnZaj92uR5F0wAj85CYqbb2Wn6/+xBvCmcSyyxSEOEp3sxeq45Y0+h3LPR2uG7ki3+ITj/Vqe2gHtEcIpRIt2f1692KhyPixWyovq2awCu3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPA01Lzus6u+JZ1FW7ce2xoJMUlT9onmZYH99i8Rzbg=;
 b=BjSGaxm8O2L5U3ST2xL19Ky5WkkncGMJARhDI7axn6ThFGVIEwyvt/Bx+WW18nUOtD/Ay65sGkkI7cWfMnswfEx9M4dc/MIeMHRxw72fypj9r6m+DDc/w+p5x3rw15bm+FxtHgYQ3DFCgxIjVNW6KGmuaU89anuLg2X/RXee+Fc5iLLtb3W8A7ejSSKuyTtlVeCrdLy+ohxuKiOumiMqhvrSl0o90tyR1v6UEfVAlaovML8cKhSoHTrK4iZzu9Pngf354H2/1xGtVFCaXQ7HeZHbtgCQxbHtidMHBPM/YU8YcMpdTJj7Hn4sZsGWGTryThWi0RWtolbhaiMkpTwiew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPA01Lzus6u+JZ1FW7ce2xoJMUlT9onmZYH99i8Rzbg=;
 b=eKFE7fkjuLwkJvMqQ46lU5ekbeuV4cpq/PNGL92dqRKa8ghXGloSrNLiTRvf4zV1NwB+xNClRwhN965d3QnQIbCu60wrOj1CepEvdR8AcyEUsj6Y6HwmthtDsjF5VLYUVqUlyIFv70AP7myDqZU4hX2MygdOmA1EFmEa3CZuAfs=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2816.eurprd04.prod.outlook.com
 (2603:10a6:800:b7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 11:45:08 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3021.030; Fri, 29 May 2020
 11:45:08 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Topic: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Index: AQHWKulbmiq87o7Yx0yuJ8Tm2Q7xY6iphgOAgAACOECAAAN2gIAAEXFggAAcYgCAAKFaYIAD5lUAgBDB0kA=
Date:   Fri, 29 May 2020 11:45:08 +0000
Message-ID: <VI1PR0402MB387176400D9ED1670801A474E08F0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB38719FE975320D9E0E47A6F9E0BA0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200518123540.3245b949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200518123540.3245b949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.147.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cffab0c0-499a-4618-69a6-08d803c5bcc9
x-ms-traffictypediagnostic: VI1PR0402MB2816:
x-microsoft-antispam-prvs: <VI1PR0402MB2816C1E4E4D792C5EC91B171E08F0@VI1PR0402MB2816.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04180B6720
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bo/izzQX6LWB0qyeoCLx3ca96L8aevLOg528/ImsodaKioKFlqH7wDBvajIgcs+bwITF2zJ3mP2it9bYipnV4Dsdh9GN1HyYEhxOY9RUBt08Cvvt2w3r/JzVIkp0FdLW+H6l1bsfx6nCZHv3bGhx+B6nlrCu80TFrubx6iqntCae+0NBEWVj59XFtNGo1HoBF2vB81DQU973C3Nf+3hmmXCIY8C06h3jzCzhtTf9gwQyMakJ9bAztXVn5zJzqhwjR5c3R2Eceu0NUO4TtBUcerl6gyPhPezwgSg/Y40LdnyVMHxqVoZNUMd9lu4YHC+N
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(44832011)(76116006)(26005)(52536014)(66556008)(66446008)(8676002)(55016002)(9686003)(4326008)(478600001)(66946007)(66476007)(64756008)(8936002)(186003)(316002)(54906003)(6506007)(7696005)(6916009)(71200400001)(2906002)(5660300002)(33656002)(86362001)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3q8llhG5guFtuop2rQud3AD1aD8zjG8XTJOnjqCuzfhwF85rhroodFjCkHecKWC2U9V0FC29YWGIYKpBVs+p37MUMJhh+kA7ofqnKOxziM8PpNEoffLzMMIwS9mvY7FXor8m293+MlBOWdjOwLFNeQcPl0UHsrjK+59sAdd40mX91Oe4d9D/I5laF8jQ7uQ0w7vsuRrRpGF3TephD0pJp6nF6Kdy7iUSKPcOSaXzg18QFP6uvsJPfFyEnRJwRiZQoyOlR7RXO4H+ZEfprgbh3LcGfqwe/v5DbjILzfJWtdwNAZZh03KcNX6G7SkcZW+i7OzPxwphBBe3XhKO5LY8WTUT/Ymn2H6BdWBU1R4T+u+s94gGHvo5bU0pXudk5hhLJiZ2Nej1ZYGHLvi4k4PclQRZu5TdL7zGqewBd1Ibif3+lMpk/w9Ri+XwlTrBgHlkhgb8SRqQmVjoqtEfauwIKx5Z01NWCFbDS5YEX5rWFky8P6m8XEwFXQwX7R1bOFzF
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cffab0c0-499a-4618-69a6-08d803c5bcc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2020 11:45:08.2412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZDYbThOyw8OrcAU3beL4fRuaviaiIl23dAGcOriaoOH0m5BWdIPTtKP4KsgGzZl+6lkqHzIemLmBLy/SxR4zdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2816
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffi=
c
> classes
>=20
> On Sat, 16 May 2020 08:16:47 +0000 Ioana Ciornei wrote:
> > > With the Rx QoS features users won't even be able to tell via
> > > standard Linux interfaces what the config was.
> >
> > Ok, that is true. So how should this information be exported to the use=
r?
>=20
> I believe no such interface currently exists.

Somehow I missed this the first time around but the number of Rx traffic cl=
asses
can be exported through the DCB ops if those traffic classes are PFC enable=
d.
Also, adding PFC support was the main target of this patch set.

An output like the following would convey to the user how many traffic clas=
ses
are available and which of them are PFC enabled.

root@localhost:~# lldptool -t -i eth1 -V PFC
IEEE 8021QAZ PFC TLV
         Willing: yes
         MACsec Bypass Capable: no
         PFC capable traffic classes: 8
         PFC enabled: 1 3 7

Ioana
