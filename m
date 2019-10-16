Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF03D8F04
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 13:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392637AbfJPLLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 07:11:39 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:24132
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730377AbfJPLLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 07:11:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYC5CD80HdStVwOOPnog9v0kWsSuw06fKnVRehkLZtZSBk3BGq/EdwV5zeYVr9vxzl6uI4iq9yT6GGn6UX02M1dw/HpkyjLcoMSDDnvuBJy4b+TfWEXupg+RYuo8DvZpIDa5dqf0rtOZyqVNVyYItlP9pwlcfugCf2oOZrD2XsfvN3oMFottmbU8nCQ7rY6lQZ0t2MlAXxSXNHaWSGJK0IoCkuM+VAJMU1FE8KMZ4dZGfnvEjSHmJD0/sOd6rke4iJpStVWlOxB1X+sRxL6Knenu59ktkIAFKrX94fZfbkKabVvoGpfYen/95QytXSj79fWU6uKSGkeolWSFMfcLvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ttjw1UQW2cf5KphJz9HGRSB+rZE7WTAChM7Z4IuNh20=;
 b=VlLhXuHW2Pw4Wwsj98IlGWBOOCXAt9yzOBFSakZg3eXoc0xp6jjZIWln2vwCq7awuNoWmusHb3dPXowYSFeh6iq6PNBBvHEypyxbjTR1jEUArVcSMnacBghCZo77zQCuBKTOl/RuzVs7aWcwphQVXOehQrgYtp8g/RnbB6LL7hUzPBSgMmJ0gTgrSfnyCwBIlyqxoJ3CVSGO0yk7589oeTi0RJMJIN4wtUNhD5V3yiqzy+xqbC8PJKYLQvRLLAsUKikv5OkVVE/eU0wG8JGgnzJAykvVHs8MLpJbRR/quyfU4xQZ8mDWoL5wpEOiKtToJgz/4IKauUmppG0+u8yHVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ttjw1UQW2cf5KphJz9HGRSB+rZE7WTAChM7Z4IuNh20=;
 b=TKgmj2rKl1z//42CHWUFpnZsaZswjgIu2GS0qmt7IDABO2bdaR1Gbal7BVGLrZgzmIs5FlYzdQPsjNbq1mcjlfS9rXeQj0TIEma57qs6UPKCze5vSxda31+ID9cUEDDxOjSLFb1fOriqRU73B0cy8XV7S/4gctrXp9kcMTeijDM=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3472.eurprd04.prod.outlook.com (52.134.5.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Wed, 16 Oct 2019 11:10:56 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::9136:9090:5b7c:433d]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::9136:9090:5b7c:433d%9]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 11:10:56 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Simon Horman <simon.horman@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>
Subject: RE: [PATCH v3 net 1/2] dpaa2-eth: add irq for the dpmac
 connect/disconnect event
Thread-Topic: [PATCH v3 net 1/2] dpaa2-eth: add irq for the dpmac
 connect/disconnect event
Thread-Index: AQHVg/RvDNrinrS7/0y9I4F2Wh5e0qddG/8AgAAAQKA=
Date:   Wed, 16 Oct 2019 11:10:56 +0000
Message-ID: <VI1PR0402MB28006BF6356B03030C245E78E0920@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1571211383-5759-1-git-send-email-ioana.ciornei@nxp.com>
 <1571211383-5759-2-git-send-email-ioana.ciornei@nxp.com>
 <20191016110751.rkt3tgdlkxjf4ip3@netronome.com>
In-Reply-To: <20191016110751.rkt3tgdlkxjf4ip3@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5aca18fc-19b1-43a9-8048-08d75229845d
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR0402MB3472:|VI1PR0402MB3472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB34720B21872C5A2A3DF281B9E0920@VI1PR0402MB3472.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(189003)(199004)(71200400001)(7696005)(26005)(76176011)(186003)(6916009)(5660300002)(476003)(2906002)(99286004)(71190400001)(11346002)(446003)(14444005)(256004)(6506007)(102836004)(33656002)(3846002)(6116002)(81166006)(66066001)(81156014)(25786009)(8676002)(52536014)(66446008)(66476007)(66946007)(86362001)(486006)(4326008)(7736002)(6436002)(6246003)(66556008)(64756008)(316002)(54906003)(229853002)(74316002)(14454004)(305945005)(44832011)(478600001)(76116006)(9686003)(8936002)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3472;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RfLkYWjxNtLsd1voGv7TOCBvPW9XsTaXEc47MtYQsDbXTlOAce8iKjA/x69tFPuK372gLUvfCTolLh7CRTNzx7yn4gyA35IlOhcM2+UXCFivAKrLHwGlVaq6K12Cf8Y+wEYY1fI34wa4SetU5Y+bh32bpZGvmx6RiW387OL6fRqAcQP0W3fqHQG4R6apEh1Le4xtX27pTw+Xv3ZljnOB+hqheMVxZLfouvTnKguyLmUFJkAYJzt00ukkP+DjGVjnk2cwIkr86LghH/gi0YvgfzIiIie7EKlCpwT+bdjO3r9tt923c/HpB0WSH+fS+fSdW7HaoTZ2GOUF/HkJmpuJfiEBuLw+3edNefNvzqpyM9GBwklVE7L7na19ArW/BQhRQIzTGmJ+64y/wLfo/E29EnmjacbWI4EXGzU/mottl8M=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aca18fc-19b1-43a9-8048-08d75229845d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 11:10:56.3381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9o3fsSxGTKafwiELik0auC9xkGyTy4szRYo/apj7EgGr8nwMAc65Iqg/4IJVg8auJsfeH2ShY+WEREYwk4s4+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3472
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v3 net 1/2] dpaa2-eth: add irq for the dpmac
> connect/disconnect event
>=20
> On Wed, Oct 16, 2019 at 10:36:22AM +0300, Ioana Ciornei wrote:
> > From: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>
> >
> > Add IRQ for the DPNI endpoint change event, resolving the issue when a
> > dynamically created DPNI gets a randomly generated hw address when the
> > endpoint is a DPMAC object.
> >
> > Signed-off-by: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> > Changes in v2:
> >  - none
> > Changes in v3:
> >  - none
> >
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 6 +++++-
> >  drivers/net/ethernet/freescale/dpaa2/dpni.h      | 5 ++++-
> >  2 files changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > index 162d7d8fb295..5acd734a216b 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > @@ -3306,6 +3306,9 @@ static irqreturn_t dpni_irq0_handler_thread(int
> irq_num, void *arg)
> >  	if (status & DPNI_IRQ_EVENT_LINK_CHANGED)
> >  		link_state_update(netdev_priv(net_dev));
> >
> > +	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED)
> > +		set_mac_addr(netdev_priv(net_dev));
> > +
> >  	return IRQ_HANDLED;
> >  }
> >
> > @@ -3331,7 +3334,8 @@ static int setup_irqs(struct fsl_mc_device *ls_de=
v)
> >  	}
> >
> >  	err =3D dpni_set_irq_mask(ls_dev->mc_io, 0, ls_dev->mc_handle,
> > -				DPNI_IRQ_INDEX,
> DPNI_IRQ_EVENT_LINK_CHANGED);
> > +				DPNI_IRQ_INDEX,
> DPNI_IRQ_EVENT_LINK_CHANGED |
> > +				DPNI_IRQ_EVENT_ENDPOINT_CHANGED);
> >  	if (err < 0) {
> >  		dev_err(&ls_dev->dev, "dpni_set_irq_mask(): %d\n", err);
> >  		goto free_irq;
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h
> > b/drivers/net/ethernet/freescale/dpaa2/dpni.h
> > index fd583911b6c0..ee0711d06b3a 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
> > @@ -133,9 +133,12 @@ int dpni_reset(struct fsl_mc_io	*mc_io,
> >   */
> >  #define DPNI_IRQ_INDEX				0
> >  /**
> > - * IRQ event - indicates a change in link state
> > + * IRQ events:
> > + *       indicates a change in link state
> > + *       indicates a change in endpoint
> >   */
> >  #define DPNI_IRQ_EVENT_LINK_CHANGED		0x00000001
> > +#define DPNI_IRQ_EVENT_ENDPOINT_CHANGED		0x00000002
>=20
> Perhaps (as a follow-up?) this is a candidate for using the BIT() macro.
>=20

I wouldn't add another change to this patch set (targeting the net) but def=
initely will change this in net-next.

Thanks a lot,
Ioana

> >
> >  int dpni_set_irq_enable(struct fsl_mc_io	*mc_io,
> >  			u32			cmd_flags,
> > --
> > 1.9.1
> >
