Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE9830F69B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 16:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbhBDPlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 10:41:50 -0500
Received: from mail-vi1eur05on2043.outbound.protection.outlook.com ([40.107.21.43]:9440
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237389AbhBDPk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 10:40:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SrpbIf5IA8M+nMHo9oJlWsclIvE/d+VXU6/l4Jo2jUV8yWx+YE4diQvUreLWA7GomGxD31Z9ML9Ksq3QFh5S7T1YE1GgBu4AfsxwubNkewsB+lpuJS58H75MudV4y2QisD+XjwHs2s2wBu6KtfY/Gkj4JQ+UltY5WQGLckDjSIqX63Tufm5+HfTO/+59Lpo5pRJjWED7zgwD8z5HKowV21TKU2Swl3hzbT3tkagkql06Bn27E+gWXUHjOH8J5JHK8vKzQuuoYEuytxsfKtW6/aR8B5eT8bkdlLAbj+hPdYAMEQQKq3ldRkX4bPAFesqc7HXxvJTwp3VxIKZ+8XX1Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dsAD7enA+Pp7OlBl4n64SygRUe/WiIchUt9lJw6c04=;
 b=IQsRyC02IVEGR7lMI0vlTCu3fbB4jxL/iNVrZVvicGvRGVNrREE2LEgth1PnZ+Ln9StNXcVajEIT7eeUqQHtQRSqSGsapnTwe1HvoyUwU2spO2oU/v7SeWFRDSkN4pslJk4QD3T9sD/JKG4rTSx8lwLS43bvkrNX8Um8kM28udeVbze5knPX2tidTlJeOY++qU2zBEWIc0U/nimw/kYd3ngvy7543jWfFKTbmpz2q+aMYg3+loqE2RteZZz08B8H0G1jYsFMxLXYKdM+p9txCexI0nTy4YUUVbnzL1EbsThDlP4zYDKl7ephiqVUoKoO9fpHV+GAt35pg/6oDyo0bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dsAD7enA+Pp7OlBl4n64SygRUe/WiIchUt9lJw6c04=;
 b=R3Gsawg6w3BTF+aoLDv885ht3r/BGfhDQRTLx4dXbiRTytmTuBfdvFb6VxWAvtRVY8JHmg3Zv7/3edpERXmnNyejR7p6O7z62+lo11kQ+GpVCRlhWJn5xvDtQE4+u+uWUZnzgYS7zJ8qo/6MwGF7XmEoPpcAkiA3I+LhhAxJmxo=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3469.eurprd04.prod.outlook.com
 (2603:10a6:803:d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.22; Thu, 4 Feb
 2021 15:40:06 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88%3]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 15:40:05 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dpaa2-mac: add backplane link mode
 support
Thread-Topic: [PATCH net-next 3/3] net: dpaa2-mac: add backplane link mode
 support
Thread-Index: AQHW7njS/2CbT1uvRk+Ml5k8hJE4TqoxF48AgBcV6QCAAA2YgA==
Date:   Thu, 4 Feb 2021 15:40:05 +0000
Message-ID: <20210204154003.mslw54uqzyzfokfr@skbuf>
References: <20210119153545.GK1551@shell.armlinux.org.uk>
 <E1l1t3B-0005Vn-2N@rmk-PC.armlinux.org.uk>
 <20210120221900.i6esmk6uadgqpdtu@skbuf>
 <20210204145124.GZ1463@shell.armlinux.org.uk>
In-Reply-To: <20210204145124.GZ1463@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d4b9d11e-9041-4ed9-7f04-08d8c923254b
x-ms-traffictypediagnostic: VI1PR0402MB3469:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB346953895D92AAC8FD61E535E0B39@VI1PR0402MB3469.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1wKlUjtcSiN6zr9ImMgzesRlCL+laA/dVHHB5s6bUt+MP/7cdHgUvzp96AshH6JLyW0c40hVO6dpS/Ee6jfw7Gxl/UVoFmh3nmq1D/iRS4fu9zB9VvkVUWk4tu18idv668uTtGsXY39z/dwnqqDI+APyEFUEL2LBajgj1h2HZ/NBxBGqcsu9VSaIBK3Qlq8E1DA2juioI9GkY/SjXgeLE4KtbTSriJ92quFGIlvSMHDyjtfKRlURPliRzY8972YLV58gtb+rGvzXQF5Y2K9udsyubUPeJq6Z4eHZjf2mdBUQhccPSmRHYK4ebTCeb9KEEib71lbmFEi8P6SBg9mu/6n1wuV/4uvxV36+jUOSOcYQAR/COla35Op63sprHEgrgb2gOgkUal6cRQK2qMrxKxAcBHXSYRPhdA/S8VsFCE/+Jbav19XLHC0Dr6hUhmDYniP1EQhy4ykmRPIJ6nTkGCtQkN7QK7YLXlcT4ropYD0QB/ZIkuhuWZyQpadQ+U0ni69ckyVpSOFC3db2qyAgPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(1076003)(71200400001)(33716001)(316002)(478600001)(66556008)(2906002)(44832011)(8936002)(26005)(8676002)(66946007)(91956017)(6506007)(76116006)(4326008)(186003)(86362001)(6486002)(66476007)(6512007)(54906003)(83380400001)(9686003)(66446008)(6916009)(5660300002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Cc+9YrcCSFHDOahSFOMZsc/lhDKCYzwOt5BqFrovRxK7cuHCxuuMV/yk3Nfv?=
 =?us-ascii?Q?ecKIOFTOrJFpA1o9ed2B12gMo49aw+fdMu6MTJVbtgKX4tXTyAFScUwMoGIk?=
 =?us-ascii?Q?+Cout/HTpl6wseFouTGL3es7iEFD72C0Q8ot16oP9eGQxED3tzkXK2HwnkGQ?=
 =?us-ascii?Q?5ETiSo8vuesD5CqRnycRit+2B2pAkAVAiWgQWh3RoTbMaqc60rGt9xCh5leY?=
 =?us-ascii?Q?YOfaEFfZJKZijARBnEa/V++L2stv7s+zIdQxooM+Oldu7gNAfGtlCYcFJ23X?=
 =?us-ascii?Q?7NI9xVV0J63CCDQ849S4Z1sHGm4sjU2ZrsaYa0yGhV2oDjH17dwDgon9R7+f?=
 =?us-ascii?Q?bg0vY79swK0nNavaSLGfrVeRm/+8eoSZKzgutQmH84J3SXe7rMtOcKC8sqFu?=
 =?us-ascii?Q?wj/onYDi0uRDav3oYrt34HBabD/2xANXCJuLxJ7SO+XrCtUKeUR8nlgto5QV?=
 =?us-ascii?Q?5QDURDXOVXus1A54igTM3D2LsxYT/flJCF274tnGUR5CNMyFKh/1RHVbIRSg?=
 =?us-ascii?Q?kuzdsSwkaZJ9hIdeMyW5Asdqb0FAf5ItOggyuEGOSqg7EDepHxQQkmBC2OCc?=
 =?us-ascii?Q?6X/z89chLc8SwVZDSdTD2wEwHDNY52GUumNyvU6XICeorqF/TG4e2Md70dXT?=
 =?us-ascii?Q?DxjRO1yE01sN+0MZeZlmzRPv6CgnDkGMzXZYbjIos4rKgyphu3psA/xLnxwH?=
 =?us-ascii?Q?RPvqTIX96twkqBS8fiFT22jVgz7NrT2jCR4aogLTGksnn2+I3XHY5nTqRUPi?=
 =?us-ascii?Q?JelGolLyIJYXLhJUZ+zrcTqEeLl7wxsEeJBpvQhiSVnyvGUmhnfP/2JvVW/V?=
 =?us-ascii?Q?EgmhtDg2LF0Hs0R9zWrARiQkWbouTMIx4bcpZpK5k4UvEP5uGOhtXdmbBKpH?=
 =?us-ascii?Q?rD9NgAtQy5bXBTAvkVxfvmvhlVfTsalM/3TUSPz/K8d4fL1ZIp7ycm7m3/Xt?=
 =?us-ascii?Q?hK/adBgnVLC7z4yAVlEoEWq37BZsghtYMEqXNjFx6A4f1sAbkB/riWZwtJZW?=
 =?us-ascii?Q?yFiBWIBF/hfsRqFlNyBhYuD7Bmbpd0VjGrOnQFJmFa+6BW+/UuPNlAO7oXHI?=
 =?us-ascii?Q?jjB39E1zlCkEJmESLB7+20dbCQVYsuA61xVB8CJ/0v+I0qAt9MrJ6Fne87Oh?=
 =?us-ascii?Q?nhAGbH3ZbydnEyZsPpZK5mTzzRlbAQwRn4jU8rdRXn+wig2uR6SuqxDjaIxi?=
 =?us-ascii?Q?KjSNAE/wqVToSwX+lCCk4IBw2ShAHI74mZuTKKq4Ijfhd6SRl/yEPmKyALCb?=
 =?us-ascii?Q?exJFXCWU3kyvRETdl7HVk0PkA3TmD7cudeEysRmzAH6+SZzAb3o0UfZP7GEL?=
 =?us-ascii?Q?0CqQ/K9acPzn7gTsMAhwKryo?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FEF308FDAB129D46A2434F026AA977B7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4b9d11e-9041-4ed9-7f04-08d8c923254b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 15:40:05.8518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9fHQaxAK2XdVLrpVUsOdUG4v0mZ9MGCiBLc3m0+cf94+p9Ypbxuvurt5SBq5fPZ8f4tW5SX275EvJFhz8gCwlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3469
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 02:51:24PM +0000, Russell King - ARM Linux admin wr=
ote:
> On Wed, Jan 20, 2021 at 10:19:01PM +0000, Ioana Ciornei wrote:
> > On Tue, Jan 19, 2021 at 03:36:09PM +0000, Russell King wrote:
> > > Add support for backplane link mode, which is, according to discussio=
ns
> > > with NXP earlier in the year, is a mode where the OS (Linux) is able =
to
> > > manage the PCS and Serdes itself.
> >=20
> > Indeed, DPMACs in TYPE_BACKPLANE can have both their PCS and SerDes man=
aged
> > by Linux (since the firmware is not touching these).
> > That being said, DPMACs in TYPE_PHY (the type that is already supported
> > in dpaa2-mac) can also have their PCS managed by Linux (no interraction
> > from the firmware's part with the PCS, just the SerDes).
> >=20
> > All in all, this patch is not needed for this particular usecase, where
> > the switch between 1000Base-X and SGMII is done by just a minor
> > reconfiguration in the PCS, without the need for SerDes changes.
> >=20
> > Also, with just the changes from this patch, a interface connected to a
> > DPMAC in TYPE_BACKPLANE is not even creating a phylink instance. It's
> > mainly because of this check from dpaa2-eth:
> >=20
> > 	if (dpaa2_eth_is_type_phy(priv)) {
> > 		err =3D dpaa2_mac_connect(mac);
> >=20
> >=20
> > I would suggest just dropping this patch.
>=20
> Hi Ioana,
>=20
> So what is happening with this series given our discussions off-list?
>=20

Let's also accept TYPE_BACKPLANE as you suggested.

> Do I resend it as-is?
>=20

For the net-next, you would also need the following diff on top of your cha=
nges in patch 3/3:

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -695,7 +695,9 @@ static inline unsigned int dpaa2_eth_rx_head_room(struc=
t dpaa2_eth_priv *priv)

 static inline bool dpaa2_eth_is_type_phy(struct dpaa2_eth_priv *priv)
 {
-       if (priv->mac && priv->mac->attr.link_type =3D=3D DPMAC_LINK_TYPE_P=
HY)
+       if (priv->mac &&
+           (priv->mac->attr.link_type =3D=3D DPMAC_LINK_TYPE_PHY ||
+            priv->mac->attr.link_type =3D=3D DPMAC_LINK_TYPE_BACKPLANE))
                return true;

        return false;

Would you mind amending your commit with this and resending the series?

Thanks,
Ioana


