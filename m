Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1323CD008
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbhGSIZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:25:18 -0400
Received: from mail-am6eur05on2054.outbound.protection.outlook.com ([40.107.22.54]:34816
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235842AbhGSIZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 04:25:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgtpufrcOk8nOvgYUg0GstKIVJ1Wdyitd6m8tlq0GK1+fnOGZ0KsWUPvVRtP8bnobyoBzXcrdm1wSOvYJHyH2QIgVNUDCSkzqfL7iH91NYwVQ/arAnh263owujP+1d3530dYtogYu7SbxIz+ebbLa/+Vdd7mX7ULA44CP+jdzwJI+c5SQ2+mFsVGAdmzCKQkBmLjtZtLjQ8t0bhixKLmFPyfJQI0N7hC4ahFP49f9ryU9WcO3y5DDCGiAEd2tYluKAHcZ0FwTlDJ1B3yMeWZrNQlUrrT9tuDBnrVDykQnDpuCzyH4in7jI8P16a9YvcTiIRtXamFMFlzt5b3o1u1AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OEspEZPBvn2tKR63eN8tyQ7CcmFp4MhzTDM5ACxsSU=;
 b=TUB9MJgo0K4IdXEVStftMHrhPB8m+T6N7rfIsg37imd1Cbbdh5ABR/LZPYPCacgMLGZU0axEZ8y/7vlFtJa0Zbd2T3k35I6PMRMcE0Sqqn72QFygs6n5W/mhDJmC2e0boCFay5KDKWSf5u2xvip9gtj5CH3GRriiGaoPS0z/2M88UVgTdiWfnlq3aTcGcxL0H7ReKFscVT0cOae7tFfJQmhVa+szrTKcwSQcxyRCaovzvbsDYIS0fsBfaWmaFVpS8O84Tg2DyqaRLAsmepnLj73rQsDZCR5GfX9v9RLGxGiU2Mr3xFmYMfwKsz2T0r1lPU9APca+ZQQjvewhTML9lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OEspEZPBvn2tKR63eN8tyQ7CcmFp4MhzTDM5ACxsSU=;
 b=F+ykGmc0sJGVoF7+e0oKvhk8WYhNW2RoQlqYAUr0vEKEM9MVLrrBonW0rQ0GhIIVA5XzA/7HhDWqeXkYVcRkaMtSX8wxcarV694Aclv+KdPFaW3Hpo4dVjfmuLwys/z1VfwqZXlOkps0IAwLqmlxqVP2FoR5Rnopi9ib0Gx0j/w=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5395.eurprd04.prod.outlook.com
 (2603:10a6:208:115::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 09:05:55 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601%3]) with mapi id 15.20.4308.027; Mon, 19 Jul 2021
 09:05:55 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH net-next] net: dpaa2-mac: add support for more ethtool
 10G link modes
Thread-Topic: [RFC PATCH net-next] net: dpaa2-mac: add support for more
 ethtool 10G link modes
Thread-Index: AQHXdzUwPaLGzQ7e8U+FjyOoZK6EJqtKDCQA
Date:   Mon, 19 Jul 2021 09:05:55 +0000
Message-ID: <20210719090554.rtdztiegvrvbbybo@skbuf>
References: <E1m2y9G-0005vm-Vm@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1m2y9G-0005vm-Vm@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7625ec50-1da4-4c6d-eb7e-08d94a946aef
x-ms-traffictypediagnostic: AM0PR04MB5395:
x-microsoft-antispam-prvs: <AM0PR04MB539548E97922FB40F24C8FE0E0E19@AM0PR04MB5395.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e/7GjeG4efbGwCZAYXCF+VrHfDwN2OvX8kXU4dBl1eMujeRnW3R0z0R9g6OBa5O1WvT90xrEvS57DgBzhanN9x7Mi82a2n/hbsRm30pXUw1mGNR8N9pE+oVpzPKNfNRvpeZgr2yJMxcbAEOgC/+YagyO6F7Ly2BZVFT+jb0BYwjKEfp6pZ8Qk7LNIPCJjWRKt4m4V0+FzMpmeMXm5mXaYWg/tvhuhBlNr7a94eq8ueIAZtS9rC3W31D7hTOp2gYjOwg/nD+1zO1WXWR4O57Xk9N8SuvHziQtrIFUbDfKrTClOT4GfMggkrVjxSWr8vbbo0AcTyp1XjMpqFoKgs9LCtVyY3BNhoD621JqnIIeRMMY06apeqCDXiSJEodQwhGnMqkGqVI9sDFXwDV98fd1mnYINqnHXzz+oEgCmL2rcVAVmQLC+ITcg/vsc4+A7+K42Az3rsRVIxdA2UlMuNve6MAsb5l3wBtN2dwC3J4vb6dJmZofbWIiWEb3zaZOZ5iYWrG01Dt2hHMBdBm6JWqWL+r40YEcPnWKegV+HfATrCZYyzmK1qVTQzrU/JVSpsjEp/zZT4ZD7Y6fdimDB++JsBPCZgIIPQjvxzYAm0UyTLol69FOG67Qqco7Tq1zRgMcb9RbXmunJ35wrCgfqh0kdgDfMcsCK6kpDQu33p9HirnpLT3MG3iF3FVrMjbpAeZx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(136003)(346002)(396003)(376002)(366004)(54906003)(8936002)(478600001)(76116006)(316002)(64756008)(66476007)(6512007)(9686003)(66556008)(26005)(66946007)(1076003)(3716004)(66446008)(44832011)(8676002)(2906002)(122000001)(4326008)(83380400001)(6506007)(33716001)(186003)(5660300002)(6486002)(86362001)(38100700002)(71200400001)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tUDKuxBAfI6HVMvqAmmz9TGrVafiGGIb5C8YQQ3KBD5hYGgEPsDpUVCeMo+n?=
 =?us-ascii?Q?QcFBqdzSltJtk+Yd3XtAER/zoarIcVIICLoEC+aYliglWOmBm783TQ3NRVPW?=
 =?us-ascii?Q?65UFKJe2u7+j/gphTZ9WU0RWciRzPjMhL+5Gxmg6M2kyqe0mci5gAWCRhP/p?=
 =?us-ascii?Q?pzYrAqGdz0XVQh7kXOFnMcf/PJVr+w0ZH6KkmHwWV5OSYwD0r9cXLsZGh///?=
 =?us-ascii?Q?weqPXqpP7vJ+OXOBUoYfUHzzGGrdMwIdMnjQVyjYSu9KRpykeYKxd7N5CzOa?=
 =?us-ascii?Q?jlLxX8YIrGLoRqxxDY0pLNVk50hDhx4C14zUg1YTy0YMVdM+/wQAj61SIUPP?=
 =?us-ascii?Q?ZZjDRb/UpPNgIMGUyu5zMJ6GJp/fH39Lyv/TWM2Gi4j/j4i4PtkCmbJtCAoK?=
 =?us-ascii?Q?6Wc3oUB2wntCDtULNBMSYRGhwxThpsz5jWpz0EQS5yvb6+TpPX1HX3AFw/38?=
 =?us-ascii?Q?jIumPHaLAppgKJRUmriLw0G4b6ax3Kjve7fAONNSJkFZv4MWFesgKQaGZLfn?=
 =?us-ascii?Q?XoDv0ICtcjruMQYWMS0g4e3hHrBVgyTrXBQsEZU6uh/huCJqXLwI87EIogwO?=
 =?us-ascii?Q?8698XvaOFVczaIpJ4tdfG5rV+aVkNT7bUQm/qTmGZ7Y4nPw9e6zqisB7RNr0?=
 =?us-ascii?Q?jixjOyb447jGiZn0VIjhyCYlLucw2le9Fu6OzKX+RPkJ+e2MlpSOW2em0f38?=
 =?us-ascii?Q?3/tMlALCtgSiK4npQGyt6Uyq85jFl6jNKx6TpGVMlKLYjjYjBjLxm9FFsNz6?=
 =?us-ascii?Q?ClMOcukbt1ooGYUWBSTMENUduJvVe22pjJ9fhG1ceD5g+cYodpcZ/6m8223U?=
 =?us-ascii?Q?7Hp7qOGj8PKYXN8aEHiqLGfzP+ezCjRJcZK7fH9ZDbvRWEY/IT1MNpxDdeLG?=
 =?us-ascii?Q?tSHu7ni5APuDBc7c9dSUR4IaasgM9mWJIUb1S0/acHBbkkZxGV+gGaegnzgx?=
 =?us-ascii?Q?MC+Neww6+0iEgzPmAkouBhuUBVOCqu4ADJNbsn7jTURtM5GO46WRRNFV42Fq?=
 =?us-ascii?Q?8j3azTIj6Qsu87eX7yz5lhdPgJ/RCFGIDMLW5u0E/KX0AsBbiMVtFMXd8FRo?=
 =?us-ascii?Q?XJgujOK0DjCNDrYK5shDxAUK0V/CZzja5DmIgp5my5rnVREUt1tjU8TRekdj?=
 =?us-ascii?Q?/xdyf7Hc/fiA4rCJjQ4jeYH/ql7qwjmkXmPehQ+iibIjOwS9mXlt+ZJNJ/mp?=
 =?us-ascii?Q?Z7MweTGCIXwvjihuw68kx7amLh2975MCc2lgiMC/3FSl0GzQa3K1kLoffLPQ?=
 =?us-ascii?Q?BEN8KjS+FaNE2UkbYqVdbC2nATV+J5lTbShLWsC21pHldOli80wrF5r/RhyL?=
 =?us-ascii?Q?+LC99QlYJNZlrAFpp5Z/TMjn?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <89354E06560B1F4F8871A85F08D7FD50@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7625ec50-1da4-4c6d-eb7e-08d94a946aef
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2021 09:05:55.8029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vTXoMlk5nokTMEryTGteBZtQyJdjqbbsbtbkfICHp6GWhIZpBI2yMQFtgMJapkH8vLdQrnuVnae5iLeXCIl77w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5395
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 04:47:10PM +0100, Russell King wrote:
> Phylink documentation says:
>  * Note that the PHY may be able to transform from one connection
>  * technology to another, so, eg, don't clear 1000BaseX just
>  * because the MAC is unable to BaseX mode. This is more about
>  * clearing unsupported speeds and duplex settings. The port modes
>  * should not be cleared; phylink_set_port_modes() will help with this.
>=20
> So add the missing 10G modes.
>=20
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>

> ---
> net-next is currently closed, but I'd like to collect acks for this
> patch. Thanks.
>=20
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-mac.c
> index ae6d382d8735..543c1f202420 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -140,6 +140,11 @@ static void dpaa2_mac_validate(struct phylink_config=
 *config,
>  	case PHY_INTERFACE_MODE_10GBASER:
>  	case PHY_INTERFACE_MODE_USXGMII:
>  		phylink_set(mask, 10000baseT_Full);
> +		phylink_set(mask, 10000baseCR_Full);
> +		phylink_set(mask, 10000baseSR_Full);
> +		phylink_set(mask, 10000baseLR_Full);
> +		phylink_set(mask, 10000baseLRM_Full);
> +		phylink_set(mask, 10000baseER_Full);
>  		if (state->interface =3D=3D PHY_INTERFACE_MODE_10GBASER)
>  			break;
>  		phylink_set(mask, 5000baseT_Full);
> --=20
> 2.20.1
> =
