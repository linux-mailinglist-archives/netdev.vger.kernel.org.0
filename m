Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15B5522A5A
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 05:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbfETDU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 23:20:29 -0400
Received: from mail-eopbgr20086.outbound.protection.outlook.com ([40.107.2.86]:43662
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727260AbfETDU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 23:20:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KSPuw/Sq1Ibp+P0NqsnerF/W15SHkkjfIMF+dw5oEs=;
 b=q4/XMrGlxW3oZSeorVdFh4HO4Y7PxQCaNS0b7WHibhfUYwd1MinPYblk+zQOjxZIFvfC0CVjQtK8/cRISnbt0vJeWd1FxxpEYy1dYfTjUbgPdkxfe3/7A1pKn8OAQjVE3oBmJV+oa5vcvVGuRlyYuD5rSbiydBohT+gcGupZwU8=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2240.eurprd04.prod.outlook.com (10.169.133.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Mon, 20 May 2019 03:20:23 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986%3]) with mapi id 15.20.1900.020; Mon, 20 May 2019
 03:20:23 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH 1/3] enetc: add hardware timestamping support
Thread-Topic: [EXT] Re: [PATCH 1/3] enetc: add hardware timestamping support
Thread-Index: AQHVC84AyxJ95TkLo0SObQ6CRQsOGKZt0N+AgAWGgxA=
Date:   Mon, 20 May 2019 03:20:23 +0000
Message-ID: <VI1PR0401MB2237FB387B3F5ABC70EE4285F8060@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190516100028.48256-1-yangbo.lu@nxp.com>
 <20190516100028.48256-2-yangbo.lu@nxp.com>
 <20190516143251.akbt3ns6ue2jrhl5@localhost>
In-Reply-To: <20190516143251.akbt3ns6ue2jrhl5@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29659eab-1d2a-4183-f18a-08d6dcd218ef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2240;
x-ms-traffictypediagnostic: VI1PR0401MB2240:
x-microsoft-antispam-prvs: <VI1PR0401MB22405CF6403B8BEEA5E98BC1F8060@VI1PR0401MB2240.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 004395A01C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(376002)(39860400002)(346002)(366004)(199004)(189003)(13464003)(86362001)(11346002)(446003)(476003)(4326008)(102836004)(26005)(6436002)(68736007)(186003)(6916009)(229853002)(55016002)(76176011)(3846002)(6116002)(6506007)(316002)(54906003)(99286004)(53546011)(7696005)(81156014)(81166006)(25786009)(5660300002)(8676002)(2906002)(14454004)(8936002)(9686003)(53936002)(71190400001)(71200400001)(6246003)(33656002)(52536014)(66446008)(14444005)(256004)(66476007)(66556008)(64756008)(66946007)(76116006)(73956011)(74316002)(7736002)(478600001)(1411001)(305945005)(486006)(66066001)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2240;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yFpnJ9BxJ/ZwiNwzU5ZcGdm6HMS3X6ZxaE4jjFnRJFjcd1E5VfCr/iJzxgxrrE63owHg4KdB7zIUj6UxWlxQfbSz0T214epTARGgFAtvWIUu+vQ2KOF0KockogpS1Ot1bHG6vQlek5s4Gi5/EVMY4HcJgHzg9e7Rc3zELrsYunLvS7vPOE6jGhFS2xmCQHlWwRLzYPFecImF2f06tOKtp2eWaNV84nme6jgl9KsvO+mHCBxyv/MmKfZ5v/81M5Y/ixP3o1VCqNqc4xZWE1y0J0TO8L8XtBhoOB6AhVtTuVA/EVTzkcshoGeYLXGUVZv5ezNYl8xd5NzxJT0aVnYY7UT2FYqJKVOoDfxkwrLzyj2HytHFWvngLw/nUNtZiojAbiDXHKukEUEOTdJdjZ2NrH14K596Mx76UXqaVT90mpI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29659eab-1d2a-4183-f18a-08d6dcd218ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2019 03:20:23.7763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2240
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Thursday, May 16, 2019 10:33 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: netdev@vger.kernel.org; David Miller <davem@davemloft.net>; Claudiu
> Manoil <claudiu.manoil@nxp.com>; Shawn Guo <shawnguo@kernel.org>; Rob
> Herring <robh+dt@kernel.org>; devicetree@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: [EXT] Re: [PATCH 1/3] enetc: add hardware timestamping support
>=20
>=20
> On Thu, May 16, 2019 at 09:59:08AM +0000, Y.b. Lu wrote:
>=20
> > +config FSL_ENETC_HW_TIMESTAMPING
> > +     bool "ENETC hardware timestamping support"
> > +     depends on FSL_ENETC || FSL_ENETC_VF
> > +     help
> > +       Enable hardware timestamping support on the Ethernet packets
> > +       using the SO_TIMESTAMPING API. Because the RX BD ring dynamic
> > +       allocation hasn't been supported and it's too expensive to use
>=20
> s/it's/it is/

[Y.b. Lu] Will modify it. BTW, may I know what's the purpose of dropping si=
ngle quote character? For searching, script checking, or something else?
If require to not use single quote character, I will also modify some other=
 places in Kconfig messages.

>=20
> > +       extended RX BDs if timestamping isn't used, the option was used
> > +       to control hardware timestamping/extended RX BDs to be enabled
> > +       or not.
>=20
> ..., this option enables extended RX BDs in order to support hardware
> timestamping.

[Y.b. Lu] Will rephrase it.

>=20
> >  static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int
> > napi_budget)  {
> >       struct net_device *ndev =3D tx_ring->ndev;
> > +     struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
> >       int tx_frm_cnt =3D 0, tx_byte_cnt =3D 0;
> >       struct enetc_tx_swbd *tx_swbd;
> > +     union enetc_tx_bd *txbd;
> > +     bool do_tstamp;
> >       int i, bds_to_clean;
> > +     u64 tstamp =3D 0;
>=20
> Please keep in reverse Christmas tree order as much as possible:
>=20
>         union enetc_tx_bd *txbd;
>         int i, bds_to_clean;
>         bool do_tstamp;
>         u64 tstamp =3D 0;
>=20
> >       i =3D tx_ring->next_to_clean;
> >       tx_swbd =3D &tx_ring->tx_swbd[i];
> >       bds_to_clean =3D enetc_bd_ready_count(tx_ring, i);
> >
> > +     do_tstamp =3D false;
> > +
> >       while (bds_to_clean && tx_frm_cnt < ENETC_DEFAULT_TX_WORK) {
> >               bool is_eof =3D !!tx_swbd->skb;
> >
> > +             if (unlikely(tx_swbd->check_wb)) {
> > +                     txbd =3D ENETC_TXBD(*tx_ring, i);
> > +
> > +                     if (!(txbd->flags & ENETC_TXBD_FLAGS_W))
> > +                             goto no_wb;
> > +
> > +                     if (tx_swbd->do_tstamp) {
> > +                             enetc_get_tx_tstamp(&priv->si->hw, txbd,
> > +                                                 &tstamp);
> > +                             do_tstamp =3D true;
> > +                     }
> > +             }
> > +no_wb:
>=20
> This goto seems strange and unnecessary.  How about this instead?
>=20
>                         if (txbd->flags & ENETC_TXBD_FLAGS_W &&
>                             tx_swbd->do_tstamp) {
>                                 enetc_get_tx_tstamp(&priv->si->hw, txbd,
> &tstamp);
>                                 do_tstamp =3D true;
>                         }
>=20
> >               enetc_unmap_tx_buff(tx_ring, tx_swbd);
> >               if (is_eof) {
> > +                     if (unlikely(do_tstamp)) {
> > +                             enetc_tstamp_tx(tx_swbd->skb, tstamp);
> > +                             do_tstamp =3D false;
> > +                     }
> >                       napi_consume_skb(tx_swbd->skb, napi_budget);
> >                       tx_swbd->skb =3D NULL;
> >               }
> > @@ -167,6 +169,11 @@ struct enetc_cls_rule {
> >
> >  #define ENETC_MAX_BDR_INT    2 /* fixed to max # of available cpus */
> >
> > +enum enetc_hw_features {
>=20
> This is a poor choice of name.  It sounds like it describes HW capabiliti=
es, but
> you use it to track whether a feature is requested at run time.
>=20
> > +     ENETC_F_RX_TSTAMP       =3D BIT(0),
> > +     ENETC_F_TX_TSTAMP       =3D BIT(1),
> > +};
> > +
> >  struct enetc_ndev_priv {
> >       struct net_device *ndev;
> >       struct device *dev; /* dma-mapping device */ @@ -178,6 +185,7
> @@
> > struct enetc_ndev_priv {
> >       u16 rx_bd_count, tx_bd_count;
> >
> >       u16 msg_enable;
> > +     int hw_features;
>=20
> This is also poorly named.  How about "tstamp_request" instead?
>=20
> >
> >       struct enetc_bdr *tx_ring[16];
> >       struct enetc_bdr *rx_ring[16];
>=20
> Thanks,
> Richard
