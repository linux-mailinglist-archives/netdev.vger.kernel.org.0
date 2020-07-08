Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4EB2182ED
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 10:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgGHI5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 04:57:11 -0400
Received: from mail-eopbgr60067.outbound.protection.outlook.com ([40.107.6.67]:18734
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726144AbgGHI5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 04:57:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GML3Mi+FFDk4luMmRjEE7LXfMU4QtexZfNMvd7b09aY4JTKEQfBfK1Y+ygSiquxr/arWtkHISG/vEk2Bj52BGPioccZWvwfyzR43xDlMy/+yVJA8e31vuvpN9asmOCYOy3Im0ca3hBYeRuYiujTm+lNnXrEy+drAp27rmN23/ZcUkS8lEoDoYKdiqs0ezdFUFyhOtgfrJ68v9CqTXHixyF10J7Sd/rQ7gswMl1poiy6IHdM0lLvuZ62zov8EfeSWMSerUWTcXObT66gk37liAZF0J5elmjNuQwlI0M4FWj70fpxoIPFLgRGC3nIzznVO0seahNM05gS9ry1WxZDFpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CG3jdfKpR1H06nWkpbSxXLfi/zrmi4RMA0EG+M3Mb7A=;
 b=BTgbWVuUdI4WjIy+eBv+0+Um353EXnV/HmkduizQhHVg68yhgk6EWUqnpwLYJvMSJydgh3RMJuCeFBSctH6bg3VBD6/K9pCJeLFM9WVdEptZ9Pac8z22Dju2iCQY7bo5VC74pnsy8kjVrQVG8GiWXcSUZWkOP2L3MBQZP2nyTSAfT6Bg+W/30HTYNspwv7penz1dtjqxiNRM5TELilqQkxtXQ317Bv0l1V3EWr1IvpJ6d/gamdpH4puNl2zATrY5XE+pU6Qh9iGzpZkBsZU0XtRDutqkwIbW+wzWhfbkhGOnj59aH842WSKlC81Agwdhvm9e28+pF8QFW7PdT9PFXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CG3jdfKpR1H06nWkpbSxXLfi/zrmi4RMA0EG+M3Mb7A=;
 b=nTem4fyJDyR8aySO00aCwauTgMRbEJkGtKsk6uqwv6SevxOm/EXWSjRraCUmCbgt7UgRyVNSCOHTqfh6JPa7DM8CyNECDO9qiCh+aN29RQGlTjGMoNBascZnVfCS3jljfIrhix44kimLg72k6u1/mg7OXgeqPOqfKE4jYP0jcOE=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR04MB5270.eurprd04.prod.outlook.com
 (2603:10a6:20b:f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Wed, 8 Jul
 2020 08:57:07 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f%5]) with mapi id 15.20.3153.029; Wed, 8 Jul 2020
 08:57:07 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Sergey Organov <sorganov@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [EXT] [PATCH  4/5] net: fec: get rid of redundant code in
 fec_ptp_set()
Thread-Topic: [EXT] [PATCH  4/5] net: fec: get rid of redundant code in
 fec_ptp_set()
Thread-Index: AQHWU6F5IyIEbIdp8UqiTSGJIl4IMaj7gQmwgACxpduAAPiYUIAANqKJgAABs1A=
Date:   Wed, 8 Jul 2020 08:57:07 +0000
Message-ID: <AM6PR0402MB36070AF1D20C8F1A1E053F07FF670@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200706142616.25192-5-sorganov@gmail.com>
        <AM6PR0402MB3607DE03C3333B9E4C8D3309FF660@AM6PR0402MB3607.eurprd04.prod.outlook.com>
        <87tuyj8jxx.fsf@osv.gnss.ru>
        <AM6PR0402MB36074EB7107ACF728134FEB0FF670@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <87y2nue6jl.fsf@osv.gnss.ru>
In-Reply-To: <87y2nue6jl.fsf@osv.gnss.ru>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0831044f-9c34-40e4-0546-08d8231ce4af
x-ms-traffictypediagnostic: AM6PR04MB5270:
x-microsoft-antispam-prvs: <AM6PR04MB527061119EBDBF633E2DD503FF670@AM6PR04MB5270.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JMXu8Xn17AgHlEmxn/1sWna+kKNvyBDPVuuFsLaAgD6LmSc/NYBz1zkKk6S8+xXxM2AA4P3JcBrnojz6utXv1NiKsK5lCOdmSLXkzcuuE0T51bFxVLq1vPF9ldSmYe1IUvlyvm2Cv8Vz1mQBhkCWHNyTp0EFouzpgt39kyGzVhhMzjbJi/rDh07Qr96hsiYa02guUk1uXohAVzvQs7COcqLG2mXCu54PXPqBnFr+kD4xmW+32LryT+IfQOLsrFCM9nrUV6+6yziJOTwOfXlyZeW8YSM9j4d7290seA5z82FMF3dFIJMo/oWp2Ck8hz81AVyha0gYptErqVZQFPPUr4hKVe2K3/9XAnzHjhnm0TM3Cvj7OqBn4IW6ITc/XJXk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(66556008)(66476007)(66446008)(66946007)(64756008)(316002)(55016002)(54906003)(2906002)(71200400001)(9686003)(7696005)(33656002)(4326008)(6916009)(8936002)(8676002)(83380400001)(478600001)(76116006)(86362001)(186003)(26005)(52536014)(5660300002)(6506007)(26583001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: w45e1zG2ZO5lbH4tlMrIcO1gHbbAof68SA06qN0wbuErIe8Z0LdOzunqe3s5X+tdKVjl6Bw7Q5fFoRcvSlftkvf8tG1zNT6tMMmCtvjHsKKh9oTLsHNKvV3N6Ne0j/i681dfIGZwv68JswqVJqk/EI3qJ4i8/XcppZd5ebaRhzRJMa2Fyh4iUoXlz8lFyL/RqL6EQU8O3tVY4tZrj6XL0d57sgDMqUxEc8pYHi5rton0nkgd1pMHVVnC5W30vhhpe769aWrXsXw0RwjGkQ05kp/WNSuutOwKArN9+xyqYs3vq7E6iCdoV1QRKUeb9/FCWoU7Bi2ZbcyVE3DEMa3mBT6z3VjR3PsHKKDzHXDEGtm8ECznvLNoYvNzIYmyVfT0QSOBaIiO/A5EC6s+yWyhRelrBoR0g4fAhuEfRPykAtW2mhK3G+evOty04kEOoXwDgFC7zXlHviwaAOsOBmLkGXiI5EnMX/3/9hdhCYiBdVg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0831044f-9c34-40e4-0546-08d8231ce4af
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 08:57:07.5247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hglxv/Ph9lYM5qJkqH3iaWSUW6rZWxvc/EGu+d43p91rDLKKWOfrK71CHBf9Lv+WZip+ehdRJ1FxOPmxAtY0wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5270
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Organov <sorganov@gmail.com> Sent: Wednesday, July 8, 2020 4:4=
9 PM
> Andy Duan <fugang.duan@nxp.com> writes:
>=20
> > From: Sergey Organov <sorganov@gmail.com> Sent: Tuesday, July 7, 2020
> > 10:43 PM
> >> Andy Duan <fugang.duan@nxp.com> writes:
> >>
> >> > From: Sergey Organov <sorganov@gmail.com> Sent: Monday, July 6,
> >> > 2020
> >> 10:26 PM
> >> >> Code of the form "if(x) x =3D 0" replaced with "x =3D 0".
> >> >>
> >> >> Code of the form "if(x =3D=3D a) x =3D a" removed.
> >> >>
> >> >> Signed-off-by: Sergey Organov <sorganov@gmail.com>
> >> >> ---
> >> >>  drivers/net/ethernet/freescale/fec_ptp.c | 4 +---
> >> >>  1 file changed, 1 insertion(+), 3 deletions(-)
> >> >>
> >> >> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c
> >> >> b/drivers/net/ethernet/freescale/fec_ptp.c
> >> >> index e455343..4152cae 100644
> >> >> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> >> >> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> >> >> @@ -485,9 +485,7 @@ int fec_ptp_set(struct net_device *ndev,
> >> >> struct
> >> ifreq
> >> >> *ifr)
> >> >>
> >> >>         switch (config.rx_filter) {
> >> >>         case HWTSTAMP_FILTER_NONE:
> >> >> -               if (fep->hwts_rx_en)
> >> >> -                       fep->hwts_rx_en =3D 0;
> >> >> -               config.rx_filter =3D HWTSTAMP_FILTER_NONE;
=20
The original patch seems fine. Thanks!

For the patch: Acked-by: Fugang Duan <fugang.duan@nxp.com>
