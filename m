Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E8C2DB00E
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 16:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbgLOP2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 10:28:33 -0500
Received: from mail-eopbgr00045.outbound.protection.outlook.com ([40.107.0.45]:49070
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729640AbgLOP2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 10:28:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+bDEz9hQt5oV34n2e17Mc4R35sh4byKUUVVJdBt/yqck7egsXgz6Bw4i8jyRQLBHr99XiFXJLXx3jGIp+FucjBmRDq4clvOQ9CKxOnu6WmCX4aS+v1AjHVs4HlQ0ZcIEdOSqZ77kpc/68jXqjMTaD4htGgWAoSxRiHbmQ+a4APhw/OsWBHLu1mYKLaz1hZ1o70tHP69YdkkTsheZCaVe5d04GRsYgleNzm2UI83f7o7HPNTbvFlGAZWyXkOLCYkLDeEnpUeSZSUvq0bNvdo8Q0T4S09sbdopHj7wxz0HSVq9WzxopNTpvJc0earIPJWpkoJM9/aNWidVleeMfDwIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcb34lrOamGi6t8kFYfwnP30ht/tEd1xdBG07E7EIlQ=;
 b=CWuFHa107/n5PkrO3/DGRYVG8mIJytLHjVlcziPlKEwhcoamuFqdObERFYpZ230jkG6SOM0ml1e5uK8xgWAFHQUqOuyDn+51UzFcZFECW+Fcb06yrMWTym61d8V7Czj9LTFEvK1uk5/l9OproHqyMv7J+IagTcLd5UrbIQ3s76PYw0N8yWxgj1tAHi/yb7M3zsEOKsOtiHGuOmPh9shyIkaBZZ+f8LzcLO7bDZjrWx3Olm7AtTvTn8RCtLWh0bfavK+Nqh6yKK7AW/h45RH0NQg1HRMi4+4mOSZYzeLgvsXpCmjx7CFwS6se4urghrFwz87OGoJiVu4RoEPhPcamZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcb34lrOamGi6t8kFYfwnP30ht/tEd1xdBG07E7EIlQ=;
 b=gzzmkmlnqcaRSC0X9GmiQnsMi4o3UUwt9Z/G8hhYm1S9NRTO3s4ONfmJVEYQjI7G7/eASEMPkD+16BLqqZpoD8muStOWUm9amOiSe0EUsy9ftvF81D7teiXmaiYsPNqjFRu2ggyUaS30qKJ8JxU5tc9ARyp/ZQECpD5/DqtSEt4=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Tue, 15 Dec
 2020 15:27:31 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 15:27:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
CC:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 03/16] net: mscc: ocelot: rename
 ocelot_netdevice_port_event to ocelot_netdevice_changeupper
Thread-Topic: [RFC PATCH net-next 03/16] net: mscc: ocelot: rename
 ocelot_netdevice_port_event to ocelot_netdevice_changeupper
Thread-Index: AQHWzVrTpCXlOTJVjESD6KhGUSTYaqn4S6MAgAAHQQA=
Date:   Tue, 15 Dec 2020 15:27:30 +0000
Message-ID: <20201215152730.yozchbn7jo4cdesa@skbuf>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-4-vladimir.oltean@nxp.com>
 <20201215150132.GE1781038@piout.net>
In-Reply-To: <20201215150132.GE1781038@piout.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 24a9df2a-95db-4460-6558-08d8a10df055
x-ms-traffictypediagnostic: VE1PR04MB6637:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB66377FE944B93368FF0C7B2FE0C60@VE1PR04MB6637.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EbUpcxJP8/3DpvM/3Z50327KG0D7wxgePzSsIc9GzZ0JcNQCRfjC6WcGR6Ct4tcMy5MVs1KHdNvQYoQu4DSl+enE2w0GZ2Pkbynt9tnQ0hiIn2MQh08edaVM2LMSOUuX2Mo4KoFhusrrfIel6SO3h3lJjiVrXd5yjtuC9+i+4sjosF+UJNt3ItefVmWsqnNJWeESil+1wtj7pMPk9dnxpyVI3JlvHZ1uHmnuDZMzEbA0qgexDhrYHqNa3Nc7kpO1t1eY0pcOy6wt/dGFKy4K0mbY4F/yAM80CibmQ1iPCnL4VIlyFugnMXEG6r8psE/e
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(71200400001)(5660300002)(6486002)(6916009)(54906003)(33716001)(6506007)(9686003)(91956017)(186003)(4326008)(4744005)(76116006)(66476007)(498600001)(2906002)(1076003)(66556008)(44832011)(6512007)(8936002)(8676002)(64756008)(66446008)(66946007)(26005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DoHXQbWkjO/Qf02QQBOyFfQmpEtRoOJ8WS5psx5EVsiydvxUICG2d6wH3/B0?=
 =?us-ascii?Q?s0Ym0jHz3vm3jkfi1ZPXIRijknH+pKT89Si1UQwKdFvqzWvV0Y+2sorkU6Ku?=
 =?us-ascii?Q?uX99igyw9vgTQ0/SKTzdccRb5luhrVKGamq2/ZMViRSb5U+bNrhPt64ciTN9?=
 =?us-ascii?Q?/9+K+aZNsA3NDKZH9wS7W+QFRWqDDoEm1Gmx40oqgxFeFRlJ/t1JzWYDDrw4?=
 =?us-ascii?Q?uYtTbXSmfo1nGe/75nIEzXC0o7laaZwtSS6kwsaPLQ46JxdvSnpkDfDZuzT8?=
 =?us-ascii?Q?dn1PubfDcg70ZbBvbFNjHczaeWOHpRnCMf2K5KpPOV2xhN+08BED30TZUIYV?=
 =?us-ascii?Q?eNShKaPIScafBpnF7FFLS19I+R2P89NnvrIRcNoBoXXCFMe3ItF7Hl85PrTz?=
 =?us-ascii?Q?vKNwl9iFcnpqyTS6Ss0Qg8jn7iXBYjWwKPrLH9Rmd/Hg7VRoRpcbJzLZXF1a?=
 =?us-ascii?Q?7IBiqFsdPXNHISswlFuyE/epowsgC2kPKsgVDHK0ZqjVr6GR+845A8phixNh?=
 =?us-ascii?Q?GlVP58mnnvNdefJDJSVSELcWKyna2lr60ePSHvwkSMImOjn37nrhK4Ahn+M4?=
 =?us-ascii?Q?b5gK1GTF8HxGjh9OKonowEM1K0FRsbzyBDnMpVBMG9uu1rhwnkjZnn4kP1ZO?=
 =?us-ascii?Q?+RzTeNWPDEOSUbS9x8TnKqIXQwtA3Wc9ZLvP45LyK13GQpQpvihp5WVhw2qH?=
 =?us-ascii?Q?oSksFK2UKiMCcpIr4i6hBMPfMFhBB3htTLCoSQQMYBSIOmfavMAqil3HRACp?=
 =?us-ascii?Q?AgLy7qcqIs/Vg7Bjqf0vzjb7VQAVERHODOC+ez2w2t2IZ0AiCDUn6o3wwA1q?=
 =?us-ascii?Q?9/efKJwNwQECztx+3kqWzWd3DRxjKR3ahJnNyKghLTgbWOrekNdv/jFA2JFQ?=
 =?us-ascii?Q?CcEBn7Ht0oxsDAYCrApbNp4yc7lB3w1Hrxx20Oz7pC/v1Fsz4kcG6DSuwGaY?=
 =?us-ascii?Q?OwjSyj6OPJc8eYWkxtifcE2L5cngvb3uGHwyjjsF+Sv5CJ2OYS8eHwteJc6k?=
 =?us-ascii?Q?8rGX?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AEC9A0B1CF73B746ACDE447B998A7D1A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24a9df2a-95db-4460-6558-08d8a10df055
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2020 15:27:31.1090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SdLQkio2QfkrC4HcX3cohthHBqeULWuwAb2vNmvNzwoOAFQGy013aypYnCOibskkOh55glEym/J4nsprDJm2Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 04:01:32PM +0100, Alexandre Belloni wrote:
> Hi,
>=20
> On 08/12/2020 14:07:49+0200, Vladimir Oltean wrote:
> > -static int ocelot_netdevice_port_event(struct net_device *dev,
> > -				       unsigned long event,
> > -				       struct netdev_notifier_changeupper_info *info)
> > +static int ocelot_netdevice_changeupper(struct net_device *dev,
> > +					struct netdev_notifier_changeupper_info *info)
>=20
> [...]
>=20
> > -		netdev_for_each_lower_dev(dev, slave, iter) {
> > -			ret =3D ocelot_netdevice_port_event(slave, event, info);
> > -			if (ret)
> > -				goto notify;
> > +			netdev_for_each_lower_dev(dev, slave, iter) {
> > +				ret =3D ocelot_netdevice_changeupper(slave, event, info);
> > +				if (ret)
> > +					goto notify;
> > +			}
> > +		} else {
> > +			ret =3D ocelot_netdevice_changeupper(dev, event, info);
>=20
> Does that compile?

No it doesn't.

> Shouldn't event be dropped?

It is, but in the next patch. I'll fix it, thanks.=
