Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782B89540A
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 04:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbfHTCIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 22:08:17 -0400
Received: from mail-eopbgr150058.outbound.protection.outlook.com ([40.107.15.58]:31909
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728615AbfHTCIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 22:08:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqL2iw3ChauhTJUQG32smxIRCDcLh4wTXX5z/4K3SteewPtwCjQ2kLGRSiOTOXtKeI7E8GnfHmsg2piaMKTbl8IUvj2LnBioHOTuEFMjOrljlzAl5R+SxdoKa29AKTkQIzuXhoBOrZhP1Cy8OZfHjsKQ/vZPfujCiNDf91yrufsPH9VaUys/x9j+8BQjO2KcM39G41hjsm2BWqN+eoGvFICocMsnS+HS74NpFSkRyAv8qQHRoWhGS4luc5ovGNp/jss9e9MPGrDEYRDpGyH7yUWZ4MEjGUUb0ILWjrfUwKOB1zVCuYRd9S+b6Fmzmkabe9WnXoeuF7+nk2XvjP/zoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PmsV/2SW6YfqJmdGTbIkunY9Gv2mXOY0YCkMscVBQ8=;
 b=awWNgirNLIfOuZ/Lp8oXcwxWca+RsS7TZwj4Opf2Dzbeu36By4+jdK7qcynE+Sp4Ys2KQBVB2fmTnr5E3YO3XQTWv5NFl3POV5T5OIGTDRqiaK0Dnxv3canilKUZd4OKA36Xhv4Ahifo5/erejWO6uZ21vlE/VX4AwoSouD40ZDlo5LM2MGQZNKiOUu+/m3KA1SYgku9RQqoSpqR5lOz/5o6P1F/8fgkzeTbSs9bJljNbtsQs4r2VXsdJIv98YZqxegwpK8tHaPEykVuLikG4MuzNIAGOTv1LJliFJuXf+o35VkIIXzEDQonnPNZIKQyFkHKUtRB2kzVrA2tEkyqKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PmsV/2SW6YfqJmdGTbIkunY9Gv2mXOY0YCkMscVBQ8=;
 b=Lxfp5rTILoanUDYwFALZabmoNYQkPYQW0wPqWXEdvwWS4dUF3O6WYjUmOosxBevnL/Z36gpAgSFvjCgA5S095ov5rY8sbmeFb9Eey+L3YFkWNDWXFILHC+kRCIEmInLeTYJoyorUUp3o2zcLrk6O2L+8u5KntROuC/ba+3FVyXE=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB2702.eurprd04.prod.outlook.com (10.175.22.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 02:08:12 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::8026:902c:16d9:699d]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::8026:902c:16d9:699d%7]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 02:08:12 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Marco Hartmann <marco.hartmann@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
Subject: RE: [PATCH net-next 1/1] fec: add C45 MDIO read/write support
Thread-Topic: [PATCH net-next 1/1] fec: add C45 MDIO read/write support
Thread-Index: AQHVVrEbELPNNXpxt0CfMgo+jLB/5acDRPAg
Date:   Tue, 20 Aug 2019 02:08:12 +0000
Message-ID: <VI1PR0402MB3600576CFF2392A71B1DA99CFFAB0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1566234659-7164-1-git-send-email-marco.hartmann@nxp.com>
 <1566234659-7164-2-git-send-email-marco.hartmann@nxp.com>
In-Reply-To: <1566234659-7164-2-git-send-email-marco.hartmann@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bf59a97-d31a-40d3-c22c-08d725134170
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2702;
x-ms-traffictypediagnostic: VI1PR0402MB2702:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2702D7D15F68AF4520A4782FFFAB0@VI1PR0402MB2702.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(189003)(199004)(66476007)(66446008)(66556008)(64756008)(76116006)(76176011)(66946007)(26005)(7736002)(6636002)(305945005)(9686003)(74316002)(478600001)(8936002)(53936002)(11346002)(446003)(99286004)(6246003)(486006)(81166006)(25786009)(316002)(8676002)(81156014)(229853002)(102836004)(14454004)(7696005)(110136005)(6506007)(2501003)(186003)(55016002)(6116002)(3846002)(6436002)(2201001)(86362001)(5660300002)(66066001)(33656002)(256004)(71190400001)(71200400001)(52536014)(476003)(2906002)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2702;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4kHjHkpd75omtldVdFuSGja2GKWeSSEM/JMwZMdcUYwGeEKOEtUryu0Pkq0zwj4MdVyQ0PaifQVDpcUdGi0uljc8pLUcaQttV1A7QIvhHsVGKtwY/whNYFmUjtIMVEPg4A/VqRdCErxN2oq9nUZRG4sR/xtz7sxsaSg9QukmhK6DBzlu6EioYpBz6WTPdAVthQNZQX+oqJQG2JUWQ4cedA7SxTM2zR/ZCg/D7cxzckAAayyErMtu3J9KBDpn4jLDzTVd1nb9Ynv0UsQlSVx3bmarJgsIlHQFNDyNMJpUdBBROjePsLXmEHsw5YgNUKs1e5DhIvw4ogpb1jYrmCS787O88ah8NSDQNZJPW/bEnXfZDaQqgm3DP0XcIMHiimZGwfBkmqIwX07YfSv40n4VxwTs0LCS4+nIsWEAwnMAih8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf59a97-d31a-40d3-c22c-08d725134170
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 02:08:12.7550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J6dch3OYrU2FvsnfBlBsSH3pO3IRSuGZz9hLpShT9dHWvRyRpv3HLkCBUpJX5XfdIB6L/lbxy/y3xA7uR3h5Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2702
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marco Hartmann Sent: Tuesday, August 20, 2019 1:11 AM
> IEEE 802.3ae clause 45 defines a modified MDIO protocol that uses a two
> staged access model in order to increase the address space.
>=20
> This patch adds support for C45 MDIO read and write accesses, which are
> used whenever the MII_ADDR_C45 flag in the regnum argument is set.
> In case it is not set, C22 accesses are used as before.
>=20
> Co-developed-by: Christian Herber <christian.herber@nxp.com>
> Signed-off-by: Christian Herber <christian.herber@nxp.com>
> Signed-off-by: Marco Hartmann <marco.hartmann@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 65
> ++++++++++++++++++++++++++++---
>  1 file changed, 59 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index c01d3ec3e9af..73f8f9a149a1 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -208,8 +208,11 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet
> MAC address");
>=20
>  /* FEC MII MMFR bits definition */
>  #define FEC_MMFR_ST		(1 << 30)
> +#define FEC_MMFR_ST_C45		(0)
>  #define FEC_MMFR_OP_READ	(2 << 28)
> +#define FEC_MMFR_OP_READ_C45	(3 << 28)
>  #define FEC_MMFR_OP_WRITE	(1 << 28)
> +#define FEC_MMFR_OP_ADDR_WRITE	(0)
>  #define FEC_MMFR_PA(v)		((v & 0x1f) << 23)
>  #define FEC_MMFR_RA(v)		((v & 0x1f) << 18)
>  #define FEC_MMFR_TA		(2 << 16)
> @@ -1767,7 +1770,7 @@ static int fec_enet_mdio_read(struct mii_bus *bus,
> int mii_id, int regnum)
>  	struct fec_enet_private *fep =3D bus->priv;
>  	struct device *dev =3D &fep->pdev->dev;
>  	unsigned long time_left;
> -	int ret =3D 0;
> +	int ret =3D 0, frame_start, frame_addr, frame_op;

Add bool variable:

bool is_c45 =3D !!(regnum & MII_ADDR_C45);
>=20
>  	ret =3D pm_runtime_get_sync(dev);
>  	if (ret < 0)
> @@ -1775,9 +1778,36 @@ static int fec_enet_mdio_read(struct mii_bus
> *bus, int mii_id, int regnum)
>=20
>  	reinit_completion(&fep->mdio_done);
>=20
> +	if (MII_ADDR_C45 & regnum) {
if (is_c45)

> +		frame_start =3D FEC_MMFR_ST_C45;
> +
> +		/* write address */
> +		frame_addr =3D (regnum >> 16);
> +		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
> +		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
> +		       FEC_MMFR_TA | (regnum & 0xFFFF),
> +		       fep->hwp + FEC_MII_DATA);
> +
> +		/* wait for end of transfer */
> +		time_left =3D wait_for_completion_timeout(&fep->mdio_done,
> +				usecs_to_jiffies(FEC_MII_TIMEOUT));
> +		if (time_left =3D=3D 0) {
> +			netdev_err(fep->netdev, "MDIO address write timeout\n");
> +			ret  =3D -ETIMEDOUT;

Should be:
goto out;
> +		}
> +
> +		frame_op =3D FEC_MMFR_OP_READ_C45;
> +
> +	} else {
> +		/* C22 read */
> +		frame_op =3D FEC_MMFR_OP_READ;
> +		frame_start =3D FEC_MMFR_ST;
> +		frame_addr =3D regnum;
> +	}
> +
>  	/* start a read op */
> -	writel(FEC_MMFR_ST | FEC_MMFR_OP_READ |
> -		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
> +	writel(frame_start | frame_op |
> +		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
>  		FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
>=20
>  	/* wait for end of transfer */
> @@ -1804,7 +1834,7 @@ static int fec_enet_mdio_write(struct mii_bus *bus,
> int mii_id, int regnum,
>  	struct fec_enet_private *fep =3D bus->priv;
>  	struct device *dev =3D &fep->pdev->dev;
>  	unsigned long time_left;
> -	int ret;
> +	int ret, frame_start, frame_addr;
>=20
>  	ret =3D pm_runtime_get_sync(dev);
>  	if (ret < 0)
> @@ -1814,9 +1844,32 @@ static int fec_enet_mdio_write(struct mii_bus
> *bus, int mii_id, int regnum,

bool is_c45 =3D !!(regnum & MII_ADDR_C45);
>=20
>  	reinit_completion(&fep->mdio_done);
>=20
> +	if (MII_ADDR_C45 & regnum) {

if (!is_c45) {
> +		frame_start =3D FEC_MMFR_ST_C45;
> +
> +		/* write address */
> +		frame_addr =3D (regnum >> 16);
> +		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
> +		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
> +		       FEC_MMFR_TA | (regnum & 0xFFFF),
> +		       fep->hwp + FEC_MII_DATA);
> +
> +		/* wait for end of transfer */
> +		time_left =3D wait_for_completion_timeout(&fep->mdio_done,
> +			usecs_to_jiffies(FEC_MII_TIMEOUT));
> +		if (time_left =3D=3D 0) {
> +			netdev_err(fep->netdev, "MDIO address write timeout\n");
> +			ret  =3D -ETIMEDOUT;
Like mdio read, it should be:
goto out;=20
> +		}
> +	} else {
> +		/* C22 write */
> +		frame_start =3D FEC_MMFR_ST;
> +		frame_addr =3D regnum;
> +	}
> +
>  	/* start a write op */
> -	writel(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
> -		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
> +	writel(frame_start | FEC_MMFR_OP_WRITE |
> +		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
>  		FEC_MMFR_TA | FEC_MMFR_DATA(value),
>  		fep->hwp + FEC_MII_DATA);
>=20
> --
> 2.7.4

