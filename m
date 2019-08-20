Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEF095470
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 04:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbfHTCcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 22:32:31 -0400
Received: from mail-eopbgr130073.outbound.protection.outlook.com ([40.107.13.73]:28548
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728719AbfHTCca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 22:32:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lj2VUxGZ4KuyGsBKyvp4g9vuj0uAbhWJzNr3B8DK6e58Xmms+0hbwvD42Fvuv18fluMmaLmxKRKMR+WNE1fGUNLPdV8Jcl/Ow4q6zamrr1FQzezAanUdlzL8jZ6dF3juivLKWnh0nNJAlapNB6XkoKop2jl++LaL9hpVfugT7uySjFSVNCmzJXBEbU++sIS+s98tK2GmfRoAISXkhdVUNTpLD5zhdkFAJ0fzyrKmdpx/2mu1UiD5VNYC69GadqzVO0yNJbb5Vuh6XBRQ+Wu9KAxIN9bAOmDxJ2zAj7YGZrPbhD9oQcM8HtO3xbgQtwE+ObkCOeMMd2YmxHtK/d0lag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tmmw/7RzIjidk3HJdAgvM64Mcbhsj+8O66Ws1WVw7IY=;
 b=mtLNWD5W7Ycszg3G3atnaxeFbXHiA5HLW6jtozTKWInSUO5cfS2O3zKBsvIDt2eZyupUpbJuQ+E1vjD4vAv568Xk3nuEffqkCtiI4MK4B88WncVdgsxwD3JLPEHAgpng+Ddc/PxQbKTY4NX29vIrEWhZ0/Nb7ocvrs6r1gIqA2UZdqFaVjyI6R7F6dud7x0b/1WL9bHq91Tp3SbyBEh4PPeTZrFupaoAlsVNVVXeajPE9PCFo6/qGNJdUUWUbgFuAx4wO/T3QIU2ySHc6os7nhvYsH5PcN0QGFKBZ33WBo/tPnIOTOXxPfrurgoyKk5Ys0wrzS3IU5JM2r/MLtJB9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tmmw/7RzIjidk3HJdAgvM64Mcbhsj+8O66Ws1WVw7IY=;
 b=BUHKFxn7WveAG3aF3gG3FrFRG4sHnQlRxo+9mnmVAD7yy6e/XIH1w3zuCPnxLrPok9ZGhdWZjMJjz7qK5qB/2pKQ69Bkf+7TRLJihDvgYkrYikldxcKF1ydasdMALjGwHJ73/YBFnLu3NedxAGRFe0kVYHEabb4LVeKynMEwwYg=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3952.eurprd04.prod.outlook.com (52.134.17.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 02:32:26 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::8026:902c:16d9:699d]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::8026:902c:16d9:699d%7]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 02:32:26 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marco Hartmann <marco.hartmann@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next 0/1] net: fec: add C45 MDIO read/write
 support
Thread-Topic: [EXT] Re: [PATCH net-next 0/1] net: fec: add C45 MDIO read/write
 support
Thread-Index: AQHVVrEbaaUHZXnfyUWEGTy4sTss5acDFLIAgAA3lHA=
Date:   Tue, 20 Aug 2019 02:32:26 +0000
Message-ID: <VI1PR0402MB360079EAAE7042048B2F5AC8FFAB0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1566234659-7164-1-git-send-email-marco.hartmann@nxp.com>
 <20190819225422.GD29991@lunn.ch>
In-Reply-To: <20190819225422.GD29991@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f52e6b7a-76e5-479e-cf09-08d72516a3eb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3952;
x-ms-traffictypediagnostic: VI1PR0402MB3952:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB39527B4D4ABE470311963679FFAB0@VI1PR0402MB3952.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(189003)(199004)(3846002)(6116002)(66066001)(2906002)(476003)(446003)(102836004)(4744005)(11346002)(6506007)(486006)(52536014)(5660300002)(186003)(6246003)(53936002)(6636002)(7736002)(74316002)(26005)(33656002)(110136005)(54906003)(316002)(305945005)(7696005)(86362001)(71200400001)(71190400001)(478600001)(99286004)(76176011)(14444005)(14454004)(256004)(229853002)(66446008)(64756008)(4326008)(6436002)(9686003)(76116006)(55016002)(66476007)(66946007)(81156014)(66556008)(25786009)(81166006)(8936002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3952;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +HnLp/BrebltwPjhgoD5zy8DZx1ogOynY3WprbvoIqpmsvqJPQiZXHWsK7cTLSTDGzilZLF2gBlvh05uMz0rvm0r6tM11QknJsgjRBPEnj8jSZfVovf5d4kgSH/f2En9zIjBWYUH5JXUn56RVeFRlApRupJFFLDXIC6MM/G6CpPf1PB/Sig5Q9P57Fo/cCkiDFZGidO1q9wp7QWbo5xu1eSKJIb6oz6VEwdjrzOnR2ys6INr2QNjchOZBJVQLV7t+N7F6/p1S7cJihHPULhggakTmcjIqt+/+vHz3sDoxejLAfe5zM/Jd3LujaX17xpkdnH1F5Bqv+A+cLKMIndHctogsxajDLw/X2ZRXfXh+hJueO/b/IKcQUL+JcF0CFs8xt1sQFB0Eum7m9ZN+2a5VY2gJNQWuUQyrYgMpXMCvrM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f52e6b7a-76e5-479e-cf09-08d72516a3eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 02:32:26.4843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t4nQtvg+0LbpR8GaIVX1OwxS8zpFBnfWv9Ks6usODFkJ/4v5AMGtQTwQYUuN3mWTBVaY1W1uTz32n22OIRtHyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3952
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
> On Mon, Aug 19, 2019 at 05:11:14PM +0000, Marco Hartmann wrote:
> > As of yet, the Fast Ethernet Controller (FEC) driver only supports
> > Clause 22 conform MDIO transactions. IEEE 802.3ae Clause 45 defines a
> > modified MDIO protocol that uses a two staged access model in order to
> > increase the address space.
> >
> > This patch adds support for Clause 45 conform MDIO read and write
> > operations to the FEC driver.
>=20
> Hi Marco
>=20
> Do all versions of the FEC hardware support C45? Or do we need to make us=
e
> of the quirk support in this driver to just enable it for some revisions =
of FEC?
>=20
> Thanks
>         Andrew

i.MX legacy platforms like i.MX6/7 series, they doesn't support Write & Rea=
d Increment.
But for i.MX8MQ/MM series, it support C45 full features like Write & Read I=
ncrement.

For the patch itself, it doesn't support Write & Read Increment, so I think=
 the patch doesn't
need to add quirk support.

Andy
