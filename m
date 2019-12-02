Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2053810E4C8
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 04:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfLBDEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 22:04:20 -0500
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:48031
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727285AbfLBDET (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Dec 2019 22:04:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=er14Dbkm7C9riaulWhWe5IZfNTzXDxoF8L1WcPVQ4WTeZ3J2ZfB8HjJwmUXmq3c88y5/COY3BaB24khdA5Gx5T8jid7XEuoGY3fpwe+7RtcaHeq/s2PzCYjoXGdqEXtks+Ze6vg7vsBtOkm4l0fLnXDtzGBcGlvNDQTpkzDuZIEUSGJITS6zrHsIgAJk+bIcEB7D/FCeMrf1VSN1q9Y13I2PgUwthJ9axKuCgE0zscnSFhLBqvWFU2hTNQI46Y0P2zRcfHYrC3MZbOydkCVrUaELgEgtQv+PxXSNNJ+R/JWrpCe8W8X65KR+tF7ISmNw4gItLV1Wek83J/R8NGLosQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYnccvN5ERWtgMR2duPSUEeZFL14qxDvQlCqP3n7Efo=;
 b=oIquwfP7049eCaghFgwM2C+BFXHHgbwMr0mWrK+DVJwIQAogXlolIpPvvGM9Wpc1GbPD4wDKmn28ctDLFoR2ZOXZZN4+QKlX2tFdjOhhP1+JeSsLKF3Q/QGIYZgOKEnqSkziPZK6z93krElk4YOq8YnacgwDBs3o//AnnL5fKbEN7mFX1oQ4NtqYXj3t380FjvLmmxaMZUWhoSlw0D5laR7iTAzMhT5c4DDj5+P/kyU9qCObb1aaYQ1hDRjQ5GFCKeXOoKa3aRTB661pijLkaPTwiHBnnm9a8a9+hBKWrNEcxnP+bSWjb8yHfV1OjM7YC1vnAadcXGxd0XX1Tgj6cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYnccvN5ERWtgMR2duPSUEeZFL14qxDvQlCqP3n7Efo=;
 b=JHHLb+Cn1tOyld6kV/vsDwlsIR6iSaUCvkfLwL/H26zK5wj6b18g4ph6NjTc3co9IAghtoHQlu9S6FrZnhv7+cJlBqEFxCbGyYuxyRZWiTFpnr7o0Rt+KupR0n+ONgZccf52wCEotzh0rloOusGremRiMnW87CWniT3nr+x9prI=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3616.eurprd04.prod.outlook.com (52.134.4.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Mon, 2 Dec 2019 03:04:16 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625%7]) with mapi id 15.20.2495.014; Mon, 2 Dec 2019
 03:04:16 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net,stable 1/1] net: fec: match the dev_id
 between probe and remove
Thread-Topic: [EXT] Re: [PATCH net,stable 1/1] net: fec: match the dev_id
 between probe and remove
Thread-Index: AQHVpn/jrt25MiDjN0mpVyW3r4862qekLDsAgAHkeqA=
Date:   Mon, 2 Dec 2019 03:04:16 +0000
Message-ID: <VI1PR0402MB3600232AF1CF9203704DCE83FF430@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1575009408-30362-1-git-send-email-fugang.duan@nxp.com>
 <20191130.122742.343376576614064539.davem@davemloft.net>
In-Reply-To: <20191130.122742.343376576614064539.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b34059aa-3b8d-48fd-9715-08d776d45128
x-ms-traffictypediagnostic: VI1PR0402MB3616:
x-microsoft-antispam-prvs: <VI1PR0402MB3616A98E5376C8E55BBB376CFF430@VI1PR0402MB3616.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0239D46DB6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(199004)(189003)(66446008)(66556008)(256004)(26005)(316002)(186003)(9686003)(8936002)(33656002)(3846002)(66066001)(14444005)(6436002)(7736002)(6916009)(74316002)(229853002)(4326008)(8676002)(99286004)(71200400001)(71190400001)(81156014)(55016002)(6246003)(81166006)(14454004)(76116006)(52536014)(5660300002)(25786009)(66946007)(86362001)(305945005)(6116002)(478600001)(6506007)(102836004)(2906002)(446003)(11346002)(64756008)(7696005)(76176011)(66476007)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3616;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CFNrY8l0HOoFTb1MnjLsu1M+c8u/Wds4PZbzrrbIXrw+o/iLTx9u5e8TrXYhM4UN9TSQpdCq4mj772oiNDZxtW+XJPDvpLC00xISsb67rxcHCKbOJLYhX1gxzHgPo1psKTyAjxBq8fs5PV55wxnt5NBaPzd5HqgtCPb7oh0TIIOQwf/Xbf2t3Pagid4ryS99tchi3YmkKY+2uEo8vE4uOkrwDE23rAgDzRkfc2iAjyEK141nihfGbsEViWrXlWBsboznVfGLqlMYVLfleF1hxVgup+kXNg41l6j8hKmg1jppcfYNzSp9W+YH+dywuxI8htMLoE+NonmV0LxbRNdhynijsRSe/fwtVF6fpk62nEKYj/sP4EIEFfHESk1ZTAFpkVWnh/NYY3XBzp+dU6VgEnKhIGjJxCGxFTbv6eLq2FZJqX4o2ilmsu5LMVk2ZxMi
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b34059aa-3b8d-48fd-9715-08d776d45128
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2019 03:04:16.2443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5YKRiWgS3y09qE1t+jgJM9u/LKBMNGq9hrN0CCvVfgc87Ep/B85UBctfZoXZIbtQGmN4e3RFMEOAa6B09gAinA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> Sent: Sun=
day, December 1, 2019 4:28 AM
> From: Andy Duan <fugang.duan@nxp.com>
> Date: Fri, 29 Nov 2019 06:40:28 +0000
>=20
> > Test device bind/unbind on i.MX8QM platform:
> > echo 5b040000.ethernet > /sys/bus/platform/drivers/fec/unbind
> > echo 5b040000.ethernet > /sys/bus/platform/drivers/fec/bind
> >
> > error log:
> > pps pps0: new PPS source ptp0 /sys/bus/platform/drivers/fec/bind
> > fec: probe of 5b040000.ethernet failed with error -2
> >
> > It should decrease the dev_id when device is unbinded. So let the
> > fec_dev_id as global variable and let the count match in
> > .probe() and .remvoe().
> >
> > Reported-by: shivani.patel <shivani.patel@volansystech.com>
> > Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
>=20
> This is not correct.
>=20
> Nothing says that there is a direct correlation between the devices added=
 and
> the ones removed, nor the order in which these operations occur relative =
to
> eachother.
>=20
> This dev_id allocation is buggy because you aren't using a proper ID allo=
cation
> scheme such as IDR.
David, you are correct. There still has issue to support bind/unbind featur=
e even if use IDR
to allocate ID because enet instance#1 depend on instance#0 internal MDIO b=
us for some platforms
and we don't know who is the real instance#0 while binging the device.

Do you have any suggestion to implement the bind/unbind feature with curren=
t dependence?
Thanks.

Andy
>=20
> I'm not applying this patch, it is incorrect and makes things worse rathe=
r than
> better.
