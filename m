Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA1E27685E
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 07:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgIXFZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 01:25:09 -0400
Received: from mail-eopbgr60087.outbound.protection.outlook.com ([40.107.6.87]:1028
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726683AbgIXFZH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 01:25:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O889fDOV+icBrX+hCr9pa0kq1ZhcNGwn7tkmQj/x8ldHZZ2u+BO/cgnTia64jIc9Yk65uKX9EbgPbtEY228jj8Mp9Xjbus783/HX6k90zE1eZqdi7saucu03XeRqpU+uM8F/GUugqAERkO8i4fgKE9SzVPvojhsQCeVe1zbiRc89B3QpS8ta+48Tj+GNuEkXmZij53vK9zzUsvlDAepWuH8Qd8AYKDjO0uToztgw1GDwVceevrkC+oRL8jeU/in+0BSgaVb33o0zGegaRhIYtKZvXE/FXT/FIQ6GrhGit8JzZQ061QUzv1eQnJnEwq8rgzbeBXIu9Tw85yIwE2Fjfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SExcYD/STVlBTsa0aHJByz0s+54saGBLhzaw4SRnzAA=;
 b=fF+l/bAB5ANB+I3st21qYgzAP3WRXK6D/2rjf9yCMxZN5FPIwgZk9/Z7/wVne2AS4du+2nvcSNC42UNCi8RwqBZiH0f3IkhSxMt8KLnBO16LUHxElCcKOPvsMJ/b3Z+5QYwASfAlsjxdck54oz0rkEAREoZl0K+pVrQIaLFWhBlkVpJts6ZuFraObJTY0WIMdrnvceR6G0lzNXTzwdVvPrU3UtarRq9OC0NJEcVZWh1zwyiftpMnUJr+MlCPaLW6qFd/k16lV3Drsw/RXRW8YloN1r/8xnm6g+bgETzDjsC6eUNmjZukHQLewNfxGrPZYwIicY7xe/SoeWnxROJsMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SExcYD/STVlBTsa0aHJByz0s+54saGBLhzaw4SRnzAA=;
 b=XY+jT4+7z+rmzm1bMKOli0Q99BRikPKfo4rAvF2hXg2IpGdrCOG3XpuO61+ziHAkPs07qCvaX1r9LOEQTe0+lXnQFDYchprowXxNf9aPY1vakPRW5hipUHeKConein/7m/X6rkB4Vp0k243iyistDZeSl7fRpcnK9wS5yQwHyD0=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5725.eurprd04.prod.outlook.com
 (2603:10a6:803:e3::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Thu, 24 Sep
 2020 05:25:04 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3412.020; Thu, 24 Sep 2020
 05:25:04 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v2 3/3] dpaa2-mac: add PCS support through the
 Lynx module
Thread-Topic: [PATCH net-next v2 3/3] dpaa2-mac: add PCS support through the
 Lynx module
Thread-Index: AQHWkcAFkt+DECZPUEyUbY+aPfap96l2+5aAgABHA4A=
Date:   Thu, 24 Sep 2020 05:25:03 +0000
Message-ID: <20200924052501.jk6o2w4ks2g4gfbq@skbuf>
References: <20200923154123.636-1-ioana.ciornei@nxp.com>
 <20200923154123.636-4-ioana.ciornei@nxp.com>
 <20200924011051.GI3770354@lunn.ch>
In-Reply-To: <20200924011051.GI3770354@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 828aee97-9f9d-403e-05b6-08d8604a3116
x-ms-traffictypediagnostic: VI1PR04MB5725:
x-microsoft-antispam-prvs: <VI1PR04MB5725DC262B54427CF4F75F5CE0390@VI1PR04MB5725.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W7zUxF4+6yGJDwdkUI4zyKoqQD1GK6FFcFd2uANd+IBy1qV3sheVm2lzEVbqrtwimRuPejlqENVfuj6TfH0uSkg3DnCB41R57FC+ZdIFZ/Ya6FhHoj6n+vmcbMs+nYl0CnckBVFwDD+UKhndHYk/8E20TsuHNRrhHTmiW8z0jBym0hyA5wLK16k4i6f5OUYG9+L8EvU60rscJnrAPnnfAawzlX2s8gm0AJgZYVKcNEHEJvCkgAOOxBJhBzb2Yt2fOUl337ktQzVS7ZyaqzTMbXutS4gAPk5oUMjJVIhgFfy4WKZVzjZPv32RwmGc+0ivfHLwalLukFoMH8q3fEmEWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(376002)(136003)(346002)(396003)(39860400002)(316002)(6506007)(4744005)(83380400001)(186003)(4326008)(1076003)(54906003)(44832011)(26005)(86362001)(8676002)(6916009)(478600001)(91956017)(8936002)(66946007)(66476007)(6486002)(66556008)(76116006)(66446008)(64756008)(6512007)(5660300002)(33716001)(2906002)(71200400001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: +KXAeWWUYcDpWNtcO7gKrY4BL8ei4t7zpRP4RTUARSa0jOQ0mclAT1N7BzrZjoj66DxPZOMPXYW05z1IeXzX1krBT4oBHAgOIDm/iNcRCHSuIJnCkaCfkobwfRCuCbKP9wWNGG3d3k+VUVi7agHfRuTptDi+Rj/Ols/YcV6P3Hn6OnZ/PWkoTq+dTRSfab4R5FU0nLgDQZJVXlDk3UuPRHRmSLmtLZo7PI/uNtvNT3C/rc8ncy18ZDm1OpKfA4icY0mEF9+QB1QaENViMT6W7Csg1hY/ygdW7UfM/jzsmHe6B5HIIw+aug6QGugKfMx3DgIT5H4l5MNd3+VcW9VPo6g70UFE9IK42zMfqPHwSEWjNbdySJ9cMdMIqF3YYVGopZR/wghobDrsH6hePxnpKVNc0aINAYZz6e+N5WzvIleuPHHT9cLK+30/i2uP3sRUxoIs+Wo1DJ4FXZZknBC2JXzo/C0t+dekwoSDDxM2ukq2KNZlwamut4mG2tmhoN5szsuZfAnmKZlYEHhhV1oe4Up/kfOG1S9vMd/QACTxh09lm7adhXDzbJUpaX830JHilLOfp219Qh2RpRx70Lidj514LpQOzxJArzr9ttIcrdlWEIwl4SYJogFxVlw5VLeNv5ZoRToC4B4NaHi0W/31tQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4F23587C5499143A24504301D57406D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 828aee97-9f9d-403e-05b6-08d8604a3116
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2020 05:25:03.8949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eGTX5uFNMQjATjN+TyQtEd2ep/GeRjzCAALvcs1JriwNRaIegvU0G8ybZAdHjYxZbISlTB1WDT3+1gvgaUTEYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 03:10:51AM +0200, Andrew Lunn wrote:
> > +static int dpaa2_pcs_create(struct dpaa2_mac *mac,
> > +			    struct device_node *dpmac_node, int id)
> > +{
> > +	struct mdio_device *mdiodev;
> > +	struct device_node *node;
> > +
> > +	node =3D of_parse_phandle(dpmac_node, "pcs-handle", 0);
> > +	if (!node) {
> > +		/* do not error out on old DTS files */
> > +		netdev_warn(mac->net_dev, "pcs-handle node not found\n");
> > +		return 0;
> > +	}
> > +
> > +	if (!of_device_is_available(node) ||
> > +	    !of_device_is_available(node->parent)) {
> > +		netdev_err(mac->net_dev, "pcs-handle node not available\n");
> > +		return -ENODEV;
> > +	}
>=20
> Can a child be available when its parent is not? I've no idea!
>=20

One can definitely try and enable the child node from DTS while keeping
the parent disabled but what seems to be the outcome is that the
disabled state will trickle down from the parent node to all child
nodes.
This check is just a little more cautious than absolutely necessary.

Ioana=
