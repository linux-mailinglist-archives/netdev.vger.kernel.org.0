Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 705B7E848A
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 10:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfJ2Jdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 05:33:42 -0400
Received: from mail-eopbgr50047.outbound.protection.outlook.com ([40.107.5.47]:55973
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726334AbfJ2Jdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 05:33:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FcUR9Z3PRTvk+fO/WrqY4O5PpPKy5mvdwk5uWwScDGYhlYJjld1C/1xDE4UyfQ6CKSfBWAVjD+qaHZ3CwsjPdoSJ9sqotbm/GZj+Y1iRCsH5OQTANMPH/KtuJawTSC+cpS110SBNiYuQRHmuP9somFxJBNRiW2IRhkvF5XAAm5yNWaXU/hEDHwauEWbn0D8dDzZXZG2TnCCTnA5xymHh6lXuaUtuT/14sACqjEJ1QkRJHVU5Oxe+FWfLFCxQsrq5bFM2jvD0EcxMbMjZQj0k8pNLecHjCapkCJwTcqBUo76D/IERbHclOTomKE6QjHhZsKZ8woi3mw9aeytyzO06RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YW9bErM7aZqTBIrC2xtBht6zAaCfr2GEWacj3D7XeA=;
 b=ZGiVnGKrN0eXsnjefjso2Kb3+1RslMJzG0iH3zfxoctNtqCh8Hxf7xiRBb2lOk05/l5cwBsQZ9Sg5Y5YCf1xtX5D4fB+sx1HJhlyKly0MHkuL6hXHB0B4cVJpJbyH+98mztJNWioqBurqFm5xTdTqJYNe29p0rB7zk/6EAx+c1SBlo9Ng4kEERQkSTMyMGui+s1nJoUYP0GmOeBjWKORklTgxrv7TQ6RqYhzpv9esU/Qa3M3fHpOt5w5Go+h8GCOhEb4grZc/lkO9bk+np3Dg6g8B7nPJy/qyQX6s+TTSRIpvxyl4ik55zGgcfDbqcAJ/MAjCixkH1eSDqoTrfIqhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YW9bErM7aZqTBIrC2xtBht6zAaCfr2GEWacj3D7XeA=;
 b=DyDQLR/NkZxPt1MFZNcp5c97ZQz3AMdy+xBkSZs0u7pqe2NKZXyz6KhHWMXrZTBvlQBHct7f0gsHkl5VV2aEex3pBZBY5txDZVeAxyaCeEB1cu97gN02sp98cZ4LlxrbxSIYLCna2rnAcvbIOYNX6FEKcTbyUMxlKit/5aYjbC0=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2864.eurprd04.prod.outlook.com (10.175.24.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Tue, 29 Oct 2019 09:33:36 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2387.027; Tue, 29 Oct
 2019 09:33:36 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
Subject: RE: [PATCH net-next v3 5/5] net: documentation: add docs for MAC/PHY
 support in DPAA2
Thread-Topic: [PATCH net-next v3 5/5] net: documentation: add docs for MAC/PHY
 support in DPAA2
Thread-Index: AQHVix1tbe7+f4PkT0SJrtecFTsHb6dw5TEAgAB6hPA=
Date:   Tue, 29 Oct 2019 09:33:36 +0000
Message-ID: <VI1PR0402MB280019AE076EB26885021493E0610@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1571998630-17108-1-git-send-email-ioana.ciornei@nxp.com>
 <1571998630-17108-6-git-send-email-ioana.ciornei@nxp.com>
 <20191029020810.GJ15259@lunn.ch>
In-Reply-To: <20191029020810.GJ15259@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 09954fea-d840-40c4-cbe9-08d75c531301
x-ms-traffictypediagnostic: VI1PR0402MB2864:|VI1PR0402MB2864:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB286432090EC6E39DBBBA1BC4E0610@VI1PR0402MB2864.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(189003)(199004)(25786009)(66446008)(76116006)(5660300002)(66476007)(14454004)(64756008)(305945005)(316002)(66556008)(66066001)(54906003)(478600001)(446003)(11346002)(55016002)(14444005)(256004)(6246003)(7736002)(4326008)(52536014)(9686003)(476003)(66946007)(2906002)(76176011)(33656002)(3846002)(6916009)(86362001)(8936002)(44832011)(71200400001)(229853002)(71190400001)(8676002)(486006)(186003)(7696005)(102836004)(99286004)(74316002)(81156014)(26005)(6436002)(81166006)(6506007)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2864;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 77mqc9qBRFt3Oyw2nNOqE5vVuNTYTzIxF2G3ILtZu1W3FnpK5E1cmx/pzwPUeoduAG9e+CedZpMhjI26NrFxT7ZPUZFqvFp6JSco8mYehJElx3Pt1jZYrmw2fZ5pntXwoW3vSWH+yz+9ddG2UqVnxidjIzsXs140HUialcWU/YWbBuBWGOPbrBzAZ6/JVpED4uAHTHJx/vcnJT9jaTRpe3HkEWBqjducOrLjD1U67oT863zE8r2XZm/nY/qib4RKTCDDUlttvKBgLDP2ny3EQ6THOm4MSS0tHfudPvGxGi5QUwRWp5XX4Lv49zbD0hfh3nVjF6l7ZDYAQ//K2fSq/cPVWFEtwO74NNvx6tk4Fb4KN5DGArGQET5agWs755kiCMSTHhZgm6xU594lg9l69V3uoENAyZ+/++VHob0IFnajqi/i7lQcDSD3HTC4Dwln
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09954fea-d840-40c4-cbe9-08d75c531301
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 09:33:36.1552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Sp7cwqLPA0OLyZXOlQMjhjybrleqogcQQFihOIuy4GmH6IRPyjeqFf/VHcOMY8qOoIbCvUuc77URV3FVnX10A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2864
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH net-next v3 5/5] net: documentation: add docs for
> MAC/PHY support in DPAA2
>=20
> > +DPAA2 Software Architecture
> > +---------------------------
> > +
> > +Among other DPAA2 objects, the fsl-mc bus exports DPNI objects
> > +(abstracting a network interface) and DPMAC objects (abstracting a
> > +MAC). The dpaa2-eth driver probes on the DPNI object and connects to
> > +and configures a DPMAC object with the help of phylink.
>=20
> Does a DPMAC object always connect to a PHY? Can a DPMAC connect to
> another DPMAC? I guess you would not normally do that, you would connect =
a
> DPNI to a DPNI?

We do not connect DPMACs to other DPMAC. As you said, for direct offload co=
mmunication
between software partitions we use DPNI-DPNI connections, without any DPMAC=
 involvement.

> But can you connect a DPMAC to a switch?

Yes, you can connect a DPMAC to a switch port.
This is why I made this code generic, so that once I move the dpaa2-ethsw f=
rom
staging I can directly integrate it with the DPMAC support without duplicat=
ing code.

>=20
> I guess it actually does not matter. Phylib/Phylink has the concept of a =
fixed-link,
> which is used when there is no PHY and you need to emulate it in order to
> configure the MAC. That will work here.
>=20
> 	Andrew
