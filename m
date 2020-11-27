Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C139A2C6978
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 17:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731497AbgK0Qdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 11:33:46 -0500
Received: from mail-eopbgr60071.outbound.protection.outlook.com ([40.107.6.71]:10475
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731325AbgK0Qdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 11:33:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6C4KJHzBsnv+n3ByocH0QDzbPR1ejoPwekLJuVozywWFEAJ52urO91O+Om+oFa4G0RQ8MrQNcTQyZr083+7uvCJcUDwZTg1Oh0gna1UY1bw+mDKnFVgC44tc6QhgG1Zl44wGNV8CiSOPs3xAvIfhpEfWtHyJvf5+RT6yI83x9RwKg7OkAYcCCVWgUAz/LnUxkgHIw3Tte9BU96XDgVtIwq7aniDdLCDHgWI3mA1wS3ewxDU8a6g7M5ch/HUkr062v3uKtIBKkrP/JvhOQXNXcpqTSRtf5ZIR6jlLg0/hi31N3hRaZvxj80lRU0EgxCgjhq6GG3o5vHeQYgFKHX/rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsFSDspX7sXxiy2VflUYB/JqjkTmfNn/lqe81QpHw70=;
 b=fihbs7AFP7TWlXzy0E3fDYwVw2/FvdONhDGmfthtkbbSLdIsVfXL9zwpCrN+0WunKIWDoGcSwyPiVaqfHAiV9mJRzy98fILBBxYo1zWT8ZdDkncgzddUYyPGgfj1zPXwe9LNMXFFYuXyw2QMrntKUVgdcAHBIiAnpYZzXOMqkBchIOtDHko7uZpQ9eXYjvgRqH2sylznm2S4qV7o4nwMa6W/QOk3nVdj5spiZod8MIIivIYQk/OaHNyYlj4FbK1IsbZ1VLsm+BkYz2/t1uAmAc1vABp/y6ahOI/XrNdZTrZ0E1fBcTMH4LEdlRRL9cKeKO3TxdXKle5FYvN9M5SS0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsFSDspX7sXxiy2VflUYB/JqjkTmfNn/lqe81QpHw70=;
 b=rDdIDnp6f0x0EOWePdppUHUbb8mM1Qt+9lOmAGBzzQR3/TJv+0Jf7M7pebJwGDe3iMcnpvE4Cl0g24H/S//PAQUdiOu8YPE+rT/+Q66DJTZ+z4YKcl3iXU4oqQUMQXR9jh0gcds6S0+CiK0WVfcmTKXfeU6GRXSfYC/CZJzp9J0=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB6079.eurprd04.prod.outlook.com (2603:10a6:803:f5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 27 Nov
 2020 16:33:37 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3611.025; Fri, 27 Nov 2020
 16:33:37 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v4 4/7] dpaa_eth: add XDP_TX support
Thread-Topic: [PATCH net-next v4 4/7] dpaa_eth: add XDP_TX support
Thread-Index: AQHWwb81iW4HPpJqH0qKrje1nVOayKnXsxEAgAFOQYCAAw6RgIAAINaQ
Date:   Fri, 27 Nov 2020 16:33:37 +0000
Message-ID: <VI1PR04MB5807233B01E531B602ECBAD3F2F80@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1606150838.git.camelia.groza@nxp.com>
 <6491d6ba855c7e736383e7f603321fe7184681bc.1606150838.git.camelia.groza@nxp.com>
 <20201124195204.GC12808@ranger.igk.intel.com>
 <VI1PR04MB5807BAB32C7B43C752C7B662F2FA0@VI1PR04MB5807.eurprd04.prod.outlook.com>
 <20201127142919.GB26825@ranger.igk.intel.com>
In-Reply-To: <20201127142919.GB26825@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ab4a5897-e352-4de4-6d16-08d892f2311c
x-ms-traffictypediagnostic: VI1PR04MB6079:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6079DC056B1E1DD2ED98AF59F2F80@VI1PR04MB6079.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s/lrRio0FfzDSWEcaImAwLrDb5b5RPNfNz1drODsvNIIKQpwWzA6UZEvG44MGI/4oo6/CGM3OI8ky/wlTRkkbnaCDfBbseC4gLo9v0YYxcQYkbzDu2SM/F2n4idPd4eAHOnmbeBdAc7RF6h3hSDxhoDzk0LFUQXG3ohvnsxBa5PcQNChqAIUfLzj9LUFN4LWy4zfcCl0iQXJXzpNAKQyRM75fE3RuwMUAD3JmxAS0Hg2u7VwPQaNyhP9TUL1mn4jdIVPB8pd70igR9EBO37NXghx00C5bUoxcqbg8xuQvnbKgTUZicWovglqtdRq6hCUEB7iIFDCLVS+PEmCji0xTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(30864003)(26005)(33656002)(8676002)(2906002)(7696005)(8936002)(71200400001)(9686003)(6506007)(53546011)(55016002)(83380400001)(6916009)(52536014)(86362001)(54906003)(478600001)(316002)(66556008)(76116006)(4326008)(186003)(64756008)(66946007)(5660300002)(66446008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?m2aSEVnC0RUWXRkbbISyT6aBRWgJTFtj2p9JPLgd8wD6aw2uxgG/UWSgef6h?=
 =?us-ascii?Q?ZmmqYbT7R/1lePnufTUa133wSKOu8qL/coBgBmFWDo3ur08iptjFSSMiS8DY?=
 =?us-ascii?Q?txfvG8Ea49vhsCH63griqQIFOqoXoHOqktC89kEEAveVTmhVYkIW3ukSFflB?=
 =?us-ascii?Q?0WgFD1Ut8jUjoRSHSg6FsKKddKMZO3QQRErkd1SdMd0Xglp8tIgHErK1C8K1?=
 =?us-ascii?Q?x7hoh8VkjbVfOs/k2eAZO/yr7axtsrO3s/B91gj55gg/mFt6DwAZl18rKcHV?=
 =?us-ascii?Q?igPz3AEuVK27y1g0Y5I65Uu5nsIenQdKdwK3GYtyEwiPtKBmi2LrRRYUJbP9?=
 =?us-ascii?Q?nlr5ue2VDYR0TMU6hJXjcOfBgsVLR5/iMuZmuS2onmCv+mUZVKp4bYyNON1F?=
 =?us-ascii?Q?0eX95baVsxGH7XCD2dWbJlqBGDC6szW8jJR0kSkhO4aF9CgG7DuxxKIGUjsO?=
 =?us-ascii?Q?DnIoI89lQdn3xoCMOM14mxDRSrXEh2R8+mmo5BOqBTZS7EC6gSy0qcbyEvt5?=
 =?us-ascii?Q?SGeZywLKHCOUd0Q3+WzfsFrtGvNwG31HsbCyLdt54v3huKB0c17ohfPFPoJD?=
 =?us-ascii?Q?jJ3T3w+wTb8HDjqTXgEW1F4kUtcAvKUqXlM81U5kARVo4HX57+gaSN1VE/04?=
 =?us-ascii?Q?tjJWbW9RZIBxAok+37Xf6w/R2RTzBfgYBBvK+94JJuAbdqWrqRzBDAE4yuUZ?=
 =?us-ascii?Q?ZYpA3m8V8VEWhcKGDJnVOxG0W7hsmPStVI33fsdyeO3ObdQQ0XIG6Tbbp5/c?=
 =?us-ascii?Q?S3KG2ezlaa1JodUSquwmfjG2YaWLdRa/2CRx3MtjCzRvOQkLy4j8y9LSMXnw?=
 =?us-ascii?Q?mCBiMT4XzcWy8S90de3OYWbGYWfRKsBJbjAhd0d1BZZFG2zzqeboo03XBMf0?=
 =?us-ascii?Q?09aZHP1jigC2NPgTo6Wfkr8StnnuMoENI6bpR9bRDuDG9qCKMvrM4Fnowmey?=
 =?us-ascii?Q?WjJiPmKsAp6nFmRgg20tMzaOkkPYutXTDz2HpK6l9sw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab4a5897-e352-4de4-6d16-08d892f2311c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2020 16:33:37.5583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BaqyuwGdv/Q3ky8H1uNIz7EYhkLGNbPCbgjXl3QlR2OlpTeEHhzjs06zyE2xIDe3Y3NmU3cb4EKdq2YpOYLaXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6079
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Friday, November 27, 2020 16:29
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> davem@davemloft.net; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v4 4/7] dpaa_eth: add XDP_TX support
>=20
> On Wed, Nov 25, 2020 at 03:49:45PM +0000, Camelia Alexandra Groza wrote:
> > > -----Original Message-----
> > > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > Sent: Tuesday, November 24, 2020 21:52
> > > To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> > > Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> > > davem@davemloft.net; Madalin Bucur (OSS)
> > > <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> > > netdev@vger.kernel.org
> > > Subject: Re: [PATCH net-next v4 4/7] dpaa_eth: add XDP_TX support
> > >
> > > On Mon, Nov 23, 2020 at 07:36:22PM +0200, Camelia Groza wrote:
> > > > Use an xdp_frame structure for managing the frame. Store a
> backpointer
> > > to
> > > > the structure at the start of the buffer before enqueueing for clea=
nup
> > > > on TX confirmation. Reserve DPAA_TX_PRIV_DATA_SIZE bytes from
> the
> > > frame
> > > > size shared with the XDP program for this purpose. Use the XDP
> > > > API for freeing the buffer when it returns to the driver on the TX
> > > > confirmation path.
> > > >
> > > > The frame queues are shared with the netstack.
> > >
> > > Can you also provide the info from cover letter about locklessness (i=
s
> > > that even a word?) in here?
> >
> > Sure.
> >
> > > One question below and:
> > >
> > > Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > >
> > > >
> > > > This approach will be reused for XDP REDIRECT.
> > > >
> > > > Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > > > Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> > > > ---
> > > > Changes in v4:
> > > > - call xdp_rxq_info_is_reg() before unregistering
> > > > - minor cleanups (remove unneeded variable, print error code)
> > > > - add more details in the commit message
> > > > - did not call qman_destroy_fq() in case of xdp_rxq_info_reg() fail=
ure
> > > > since it would lead to a double free of the fq resources
> > > >
> > > >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 128
> > > ++++++++++++++++++++++++-
> > > >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   2 +
> > > >  2 files changed, 125 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > index ee076f4..0deffcc 100644
> > > > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > @@ -1130,6 +1130,24 @@ static int dpaa_fq_init(struct dpaa_fq
> *dpaa_fq,
> > > bool td_enable)
> > > >
> > > >  	dpaa_fq->fqid =3D qman_fq_fqid(fq);
> > > >
> > > > +	if (dpaa_fq->fq_type =3D=3D FQ_TYPE_RX_DEFAULT ||
> > > > +	    dpaa_fq->fq_type =3D=3D FQ_TYPE_RX_PCD) {
> > > > +		err =3D xdp_rxq_info_reg(&dpaa_fq->xdp_rxq, dpaa_fq-
> > > >net_dev,
> > > > +				       dpaa_fq->fqid);
> > > > +		if (err) {
> > > > +			dev_err(dev, "xdp_rxq_info_reg() =3D %d\n", err);
> > > > +			return err;
> > > > +		}
> > > > +
> > > > +		err =3D xdp_rxq_info_reg_mem_model(&dpaa_fq->xdp_rxq,
> > > > +						 MEM_TYPE_PAGE_ORDER0,
> > > NULL);
> > > > +		if (err) {
> > > > +			dev_err(dev, "xdp_rxq_info_reg_mem_model() =3D
> > > %d\n", err);
> > > > +			xdp_rxq_info_unreg(&dpaa_fq->xdp_rxq);
> > > > +			return err;
> > > > +		}
> > > > +	}
> > > > +
> > > >  	return 0;
> > > >  }
> > > >
> > > > @@ -1159,6 +1177,11 @@ static int dpaa_fq_free_entry(struct device
> > > *dev, struct qman_fq *fq)
> > > >  		}
> > > >  	}
> > > >
> > > > +	if ((dpaa_fq->fq_type =3D=3D FQ_TYPE_RX_DEFAULT ||
> > > > +	     dpaa_fq->fq_type =3D=3D FQ_TYPE_RX_PCD) &&
> > > > +	    xdp_rxq_info_is_reg(&dpaa_fq->xdp_rxq))
> > > > +		xdp_rxq_info_unreg(&dpaa_fq->xdp_rxq);
> > > > +
> > > >  	qman_destroy_fq(fq);
> > > >  	list_del(&dpaa_fq->list);
> > > >
> > > > @@ -1625,6 +1648,9 @@ static int dpaa_eth_refill_bpools(struct
> dpaa_priv
> > > *priv)
> > > >   *
> > > >   * Return the skb backpointer, since for S/G frames the buffer
> containing it
> > > >   * gets freed here.
> > > > + *
> > > > + * No skb backpointer is set when transmitting XDP frames. Cleanup
> the
> > > buffer
> > > > + * and return NULL in this case.
> > > >   */
> > > >  static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv
> *priv,
> > > >  					  const struct qm_fd *fd, bool ts)
> > > > @@ -1664,13 +1690,21 @@ static struct sk_buff
> > > *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
> > > >  		}
> > > >  	} else {
> > > >  		dma_unmap_single(priv->tx_dma_dev, addr,
> > > > -				 priv->tx_headroom +
> > > qm_fd_get_length(fd),
> > > > +				 qm_fd_get_offset(fd) +
> > > qm_fd_get_length(fd),
> > > >  				 dma_dir);
> > > >  	}
> > > >
> > > >  	swbp =3D (struct dpaa_eth_swbp *)vaddr;
> > > >  	skb =3D swbp->skb;
> > > >
> > > > +	/* No skb backpointer is set when running XDP. An xdp_frame
> > > > +	 * backpointer is saved instead.
> > > > +	 */
> > > > +	if (!skb) {
> > > > +		xdp_return_frame(swbp->xdpf);
> > > > +		return NULL;
> > > > +	}
> > > > +
> > > >  	/* DMA unmapping is required before accessing the HW provided
> > > info */
> > > >  	if (ts && priv->tx_tstamp &&
> > > >  	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> > > > @@ -2350,11 +2384,76 @@ static enum qman_cb_dqrr_result
> > > rx_error_dqrr(struct qman_portal *portal,
> > > >  	return qman_cb_dqrr_consume;
> > > >  }
> > > >
> > > > +static int dpaa_xdp_xmit_frame(struct net_device *net_dev,
> > > > +			       struct xdp_frame *xdpf)
> > > > +{
> > > > +	struct dpaa_priv *priv =3D netdev_priv(net_dev);
> > > > +	struct rtnl_link_stats64 *percpu_stats;
> > > > +	struct dpaa_percpu_priv *percpu_priv;
> > > > +	struct dpaa_eth_swbp *swbp;
> > > > +	struct netdev_queue *txq;
> > > > +	void *buff_start;
> > > > +	struct qm_fd fd;
> > > > +	dma_addr_t addr;
> > > > +	int err;
> > > > +
> > > > +	percpu_priv =3D this_cpu_ptr(priv->percpu_priv);
> > > > +	percpu_stats =3D &percpu_priv->stats;
> > > > +
> > > > +	if (xdpf->headroom < DPAA_TX_PRIV_DATA_SIZE) {
> > > > +		err =3D -EINVAL;
> > > > +		goto out_error;
> > > > +	}
> > > > +
> > > > +	buff_start =3D xdpf->data - xdpf->headroom;
> > > > +
> > > > +	/* Leave empty the skb backpointer at the start of the buffer.
> > > > +	 * Save the XDP frame for easy cleanup on confirmation.
> > > > +	 */
> > > > +	swbp =3D (struct dpaa_eth_swbp *)buff_start;
> > > > +	swbp->skb =3D NULL;
> > > > +	swbp->xdpf =3D xdpf;
> > > > +
> > > > +	qm_fd_clear_fd(&fd);
> > > > +	fd.bpid =3D FSL_DPAA_BPID_INV;
> > > > +	fd.cmd |=3D cpu_to_be32(FM_FD_CMD_FCO);
> > > > +	qm_fd_set_contig(&fd, xdpf->headroom, xdpf->len);
> > > > +
> > > > +	addr =3D dma_map_single(priv->tx_dma_dev, buff_start,
> > > > +			      xdpf->headroom + xdpf->len,
> > > > +			      DMA_TO_DEVICE);
> > >
> > > Not sure if I asked that.  What is the purpose for including the head=
room
> > > in frame being set? I would expect to take into account only frame fr=
om
> > > xdpf->data.
> >
> > The xdpf headroom becomes the fd's offset, the area before the data
> where the backpointers for cleanup are stored. This area isn't sent out w=
ith
> the frame.
>=20
> But if I'm reading this right you clearly include the headroom space in
> the DMA region that you are mapping. Why this couldn't be:
>=20
> 	addr =3D dma_map_single(priv->tx_dma_dev, xdpf->data,
> 			      xdpf->len, DMA_TO_DEVICE);
>=20
> And then frame descriptor wouldn't need to have the offset at all?
> Probably that's implementation details, but this way it seems
> cleaner/easier to follow to me.

The headroom is included in the mapped DMA region because we need access to=
 the xdpf reference for cleanup on the confirmation path. The reference is =
stored in the headroom. We also use the headroom for other offloads such as=
 TX checksum, but those aren't available on XDP yet. Overall, this is the d=
river's design and we need to map the headroom as well as the data.

> >
> > > > +	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
> > > > +		err =3D -EINVAL;
> > > > +		goto out_error;
> > > > +	}
> > > > +
> > > > +	qm_fd_addr_set64(&fd, addr);
> > > > +
> > > > +	/* Bump the trans_start */
> > > > +	txq =3D netdev_get_tx_queue(net_dev, smp_processor_id());
> > > > +	txq->trans_start =3D jiffies;
> > > > +
> > > > +	err =3D dpaa_xmit(priv, percpu_stats, smp_processor_id(), &fd);
> > > > +	if (err) {
> > > > +		dma_unmap_single(priv->tx_dma_dev, addr,
> > > > +				 qm_fd_get_offset(&fd) +
> > > qm_fd_get_length(&fd),
> > > > +				 DMA_TO_DEVICE);
> > > > +		goto out_error;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +
> > > > +out_error:
> > > > +	percpu_stats->tx_errors++;
> > > > +	return err;
> > > > +}
> > > > +
> > > >  static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, =
void
> > > *vaddr,
> > > > -			unsigned int *xdp_meta_len)
> > > > +			struct dpaa_fq *dpaa_fq, unsigned int
> > > *xdp_meta_len)
> > > >  {
> > > >  	ssize_t fd_off =3D qm_fd_get_offset(fd);
> > > >  	struct bpf_prog *xdp_prog;
> > > > +	struct xdp_frame *xdpf;
> > > >  	struct xdp_buff xdp;
> > > >  	u32 xdp_act;
> > > >
> > > > @@ -2370,7 +2469,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv
> *priv,
> > > struct qm_fd *fd, void *vaddr,
> > > >  	xdp.data_meta =3D xdp.data;
> > > >  	xdp.data_hard_start =3D xdp.data - XDP_PACKET_HEADROOM;
> > > >  	xdp.data_end =3D xdp.data + qm_fd_get_length(fd);
> > > > -	xdp.frame_sz =3D DPAA_BP_RAW_SIZE;
> > > > +	xdp.frame_sz =3D DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
> > > > +	xdp.rxq =3D &dpaa_fq->xdp_rxq;
> > > >
> > > >  	xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > > >
> > > > @@ -2381,6 +2481,22 @@ static u32 dpaa_run_xdp(struct dpaa_priv
> *priv,
> > > struct qm_fd *fd, void *vaddr,
> > > >  	case XDP_PASS:
> > > >  		*xdp_meta_len =3D xdp.data - xdp.data_meta;
> > > >  		break;
> > > > +	case XDP_TX:
> > > > +		/* We can access the full headroom when sending the frame
> > > > +		 * back out
> > > > +		 */
> > > > +		xdp.data_hard_start =3D vaddr;
> > > > +		xdp.frame_sz =3D DPAA_BP_RAW_SIZE;
> > > > +		xdpf =3D xdp_convert_buff_to_frame(&xdp);
> > > > +		if (unlikely(!xdpf)) {
> > > > +			free_pages((unsigned long)vaddr, 0);
> > > > +			break;
> > > > +		}
> > > > +
> > > > +		if (dpaa_xdp_xmit_frame(priv->net_dev, xdpf))
> > > > +			xdp_return_frame_rx_napi(xdpf);
> > > > +
> > > > +		break;
> > > >  	default:
> > > >  		bpf_warn_invalid_xdp_action(xdp_act);
> > > >  		fallthrough;
> > > > @@ -2415,6 +2531,7 @@ static enum qman_cb_dqrr_result
> > > rx_default_dqrr(struct qman_portal *portal,
> > > >  	u32 fd_status, hash_offset;
> > > >  	struct qm_sg_entry *sgt;
> > > >  	struct dpaa_bp *dpaa_bp;
> > > > +	struct dpaa_fq *dpaa_fq;
> > > >  	struct dpaa_priv *priv;
> > > >  	struct sk_buff *skb;
> > > >  	int *count_ptr;
> > > > @@ -2423,9 +2540,10 @@ static enum qman_cb_dqrr_result
> > > rx_default_dqrr(struct qman_portal *portal,
> > > >  	u32 hash;
> > > >  	u64 ns;
> > > >
> > > > +	dpaa_fq =3D container_of(fq, struct dpaa_fq, fq_base);
> > > >  	fd_status =3D be32_to_cpu(fd->status);
> > > >  	fd_format =3D qm_fd_get_format(fd);
> > > > -	net_dev =3D ((struct dpaa_fq *)fq)->net_dev;
> > > > +	net_dev =3D dpaa_fq->net_dev;
> > > >  	priv =3D netdev_priv(net_dev);
> > > >  	dpaa_bp =3D dpaa_bpid2pool(dq->fd.bpid);
> > > >  	if (!dpaa_bp)
> > > > @@ -2494,7 +2612,7 @@ static enum qman_cb_dqrr_result
> > > rx_default_dqrr(struct qman_portal *portal,
> > > >
> > > >  	if (likely(fd_format =3D=3D qm_fd_contig)) {
> > > >  		xdp_act =3D dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
> > > > -				       &xdp_meta_len);
> > > > +				       dpaa_fq, &xdp_meta_len);
> > > >  		if (xdp_act !=3D XDP_PASS) {
> > > >  			percpu_stats->rx_packets++;
> > > >  			percpu_stats->rx_bytes +=3D qm_fd_get_length(fd);
> > > > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > > b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > > > index 94e8613..5c8d52a 100644
> > > > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > > > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > > > @@ -68,6 +68,7 @@ struct dpaa_fq {
> > > >  	u16 channel;
> > > >  	u8 wq;
> > > >  	enum dpaa_fq_type fq_type;
> > > > +	struct xdp_rxq_info xdp_rxq;
> > > >  };
> > > >
> > > >  struct dpaa_fq_cbs {
> > > > @@ -150,6 +151,7 @@ struct dpaa_buffer_layout {
> > > >   */
> > > >  struct dpaa_eth_swbp {
> > > >  	struct sk_buff *skb;
> > > > +	struct xdp_frame *xdpf;
> > > >  };
> > > >
> > > >  struct dpaa_priv {
> > > > --
> > > > 1.9.1
> > > >
