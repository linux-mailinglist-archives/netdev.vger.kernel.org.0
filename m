Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFE368927D
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbjBCIjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjBCIjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:39:40 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CDC9770;
        Fri,  3 Feb 2023 00:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675413578; x=1706949578;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uNNt1ypTR4iDYTvUkG99nBsFaC5udXLGJAgE6Z9HGLc=;
  b=bst3HLLv/dI1VswhRtC6aaNWKG/qGHOWf+PH2Ix5Y/A/gN7w5UF8zsgZ
   SL6HhOKSaBdb7CTlRmHUKleRd07ghfmCY6XqX9vowWJYYmZIe2GaYQ7IU
   NG6Y4MEY6oWf64U2QLNde5d6v29VvFakj0+EYjwvgYcICY4VbLCHx6L3v
   g6JRs57HWsBxHHBdHolWwSep888qhEqQDMGDMw7yIGdOdSrxqxjZcP4DT
   i3/Q6vAJ65B3S38tGs38M5IIXWDRGpxhcGsaE+WfYpTbP8hPhDrSQrnXm
   Mzxc3NNKEgNA+/aDCmuO92O4efPkqgl/4CyPvGSgvhib1Ca10RN6aJP5l
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="356035175"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="356035175"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 00:39:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="615633173"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="615633173"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 03 Feb 2023 00:39:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 00:39:36 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 00:39:36 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 3 Feb 2023 00:39:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBpsrSw9QqZ89y+SyDC6QT5WuPJLtIFxwAS57HcuRP3/BU5xSTaDOyXOIeLUZHuecrgvkgrxtZh31/8/sYQ271D/iFgiAfZBQ6lIW8N1F9BZHEV4X0v4RVL9DXAoALyhXZGPEE2bX7wYaLb9RnPj3ShuwrmAmpYktoP09ZlEHzkW6ERUomwHzO6hNkOIqxG1U8qSOZBb7AGZBk12WYmDqZOKpLXZWiGwBDdtOYAIAztLUaxNvYqNFiuMfMDHw91asOxKmLAE2Hp32LVo/UAkgmtFw8YS8rZG/xXH3Kq3wRY0pdX/16E6UxiY/F0ZB/fCgGTXLuBWmhGMrNrzns3BgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Jiy6N22lvm1NjAgGy36p6va3qs9F6c/lCkwu/VXSLE=;
 b=gyDtuICkYDz7C+sq06xpY7j39flu5sKsvscDUYMzIXVli7nAJKQ4ZhshZ1/CpDiRNBnJOC3pTg+eX12lDs/gcqwz0G4rMsCgilfpY0zxfAZxVG0XMu6ijKkll8QayqcNaqMiWRWUAZH+E/E90cToN3snrwpjBmlhb1cuiEubfcy4VCEN0NTBUPYF7izG1unyqWlbML71iUtW5m/cseIPRuQPFHNiIg/V4RAgYpgkfv/noHmGgtgegGM+dB323qPcCyP9W9THZjyLy6qiCmSe2XNN5xsAU/hq1E8mJ8lZxVPc2p97IUVde7oN4nOiVxKSK7vCJT2CEnU9CjpFYTSr9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM4PR11MB6166.namprd11.prod.outlook.com (2603:10b6:8:ad::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.29; Fri, 3 Feb 2023 08:39:35 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Fri, 3 Feb 2023
 08:39:35 +0000
Date:   Fri, 3 Feb 2023 09:39:25 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH 29/33] virtio_net: xsk: tx: support tx
Message-ID: <Y9zIPdKmTvXqyuYS@boxer>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-30-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230202110058.130695-30-xuanzhuo@linux.alibaba.com>
X-ClientProxiedBy: LNXP265CA0096.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::36) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DM4PR11MB6166:EE_
X-MS-Office365-Filtering-Correlation-Id: da7ffef6-7812-4cdf-733e-08db05c22d5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: reViz/Raoht2BJvzHwMlUBN2n4/S29e+5TISwBrTzto3Fk0rfvMOd6NRPzh8mg1PAhcJ2fbpvWtQ5Sapr6W0kkY1PYxtJB+LedHaNr5n36wseXmH2P3YQ/46W38qwIWFhIwadBmHx/XkSs2CZ1JI+VlLjO0/PB12ptpRtEGxso9SpUB7dXhsZ7aGwO4YCdaIe3/XzizRnssVHGEah1mjZ+QloWqSmqeY7im+JTB+ogJ0+Sjwb2ncfsvcVKEK6bk/MqSWtyhv5ZLfle5YpU4Y9oGmpm/T5yg7r5xXMXfAmylGQkb0jAmYSPPKTXWHrfRkUo34FEYqDOoh6haDlnxu54ID9vSAVlZeoxTiCca70vO6Mpxu5PPrheT2cFqMgGZYbCmm7Icp9PJfSDikwd/PN7etGe4kH+m0P8ze4KcRR6qGFoDsG1Ki5x4DIOEE6c65AQFhTRD+MNbGN05/6i2vod7vDsaRNQ1kqKYF1eHykhLQ1aOEzpWzPBCoNaGLiMThpkxfDbFjue/TXqsPQzt9un5QGN0JmiKJgCvRV1Qr+s80m3Qpvq7HFC9k8sb/SyEUD7X9bpH2x0Ls9rpnDmErQHyiurexB4zLlyLjiihU/046TI/CYhBapzWD4q6EaxGHo21MSSgSwY1aL5wNp2UMdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199018)(54906003)(316002)(6486002)(82960400001)(33716001)(478600001)(38100700002)(86362001)(6916009)(8676002)(4326008)(66946007)(66476007)(44832011)(6512007)(186003)(66556008)(9686003)(26005)(41300700001)(6666004)(7416002)(5660300002)(6506007)(8936002)(83380400001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dy1cCccFrISQUHLm1TbvVqMNdPKzeH9ihbZkaAfAWJ/Bv4SmkZMDPBSlJOsv?=
 =?us-ascii?Q?cvb7ff9zjxprhUtePFTNUYIqKRf6cYuriOvX6YmhiBGaKJZ0zrdPyn2Bxafg?=
 =?us-ascii?Q?7u/60T6gYkqg5fQgdyLcAvvXYzVTYDTqW7ameU+93TrA9jbXeZKGGfqVqroG?=
 =?us-ascii?Q?i9rKlAlhCFZbOm4OVC7YvIVQqYOIh4l83AdJ/EJg2RdukvAnBJQjw7CLYBGP?=
 =?us-ascii?Q?/Q774DpcVxnAtWka105jEOwRGuyDn75GnKYz5itXuxiSkH6ahGCWmP7PhmVn?=
 =?us-ascii?Q?H7iEn2rX48vsxR8EZCyXTmf9TSBRIXbCswLOFWjff9AYFCKGrgtzWUe++Tsr?=
 =?us-ascii?Q?/SP6SWueJ3wcc2NplIa4pbgnu4NLiptChCaS3EkwPsZcEky7BQ/yv8+rL7bw?=
 =?us-ascii?Q?7GD9q6f1RhGKSKzgrWXVpTGhEmJOp/wUwu6VHstJwAgFPH9ZoBkThtOAu4XH?=
 =?us-ascii?Q?GQRw7qUjT+E/hdRd4BM84ZZ0qAKwaR4Wz29ees7BgFWPYpc6NyG+LMGoJBdA?=
 =?us-ascii?Q?mPwCFRcX+IC/GZ8tZv5he0SgVA1N8QktN08zm0Xzdm44VK4OUEso97wa4QHv?=
 =?us-ascii?Q?nCFBwlmcalKm0I8iDNq7esCZ7lFg3PiHgiB3HzAZBJlHaxPEwYixXghr4ftO?=
 =?us-ascii?Q?t2JyD52gMVLKJ6RvbVcx1OOPZx/XkZiizOSzn+1/GKpWNCF3xerGS2qZPD/1?=
 =?us-ascii?Q?i7q3DsUL+isx6V5cUE6BMtisgVwtwYAjAWO7cjEvKBA6Pqukg8TWFOKWWbbr?=
 =?us-ascii?Q?jEbo6YD3pgymK9EP2m69LvsTn+56oDYl6/7s5z6it5QEwe2KMV59aC768S6A?=
 =?us-ascii?Q?sMfWMIvi6M7D1Cpp1DVeKuuo4HjiqRV7qgbXh1U+6Mxcj1nnL8gblqSdbjpX?=
 =?us-ascii?Q?rNcj8PoHeQeRD0Za/a4P1d0RekzmN5HTm9SDY6/ltXBrMaPc2zj/oF9Q/FEE?=
 =?us-ascii?Q?CoWrAOt7svxU2N+bNvnOaPIz8Pz7mu81V95jJQ1AyYp+2CAS0GcddacvYohE?=
 =?us-ascii?Q?NpOO/IWyfbOxRlY1xoGugenm5fdoMMcB78x6tt7ilu180TwOQscNJ/fhRJJ6?=
 =?us-ascii?Q?9aQzTzvvf8bvHHyYL5mJka0qVV/mVip2koXucuAHX+q04OWsj1S+E+lLujYF?=
 =?us-ascii?Q?8izx1yGiHlRMdVisNEn4NxhiPSzojfnKa1lAzfihBZg+eap8kRt1GDLTT3du?=
 =?us-ascii?Q?jl4WRQVaZnZD8qXNDroEdvnFMwznc3Ps/a4D3IwFQe6qq3II6xRik2S0h9Gz?=
 =?us-ascii?Q?i8uHVA5rVK7VCPejnnv/Tp2xr02dVyE2w9aBrD1g18+pUVSdXsB6Dhxk6Jnd?=
 =?us-ascii?Q?EDPHqKj6is+FyWcjjlb6ZtMYkvZqs5aoqz1qNb+sGDNUGOV0gQ+HGyIT2fB2?=
 =?us-ascii?Q?u+JRSeKmYP++aHFs+10g+WKc4yhyzV2sjBFMRgON9UgAmrtsXXLxeiLz2slx?=
 =?us-ascii?Q?zCa4NdnHWozycSVqa6oYG0NpL7cuGzUUvkC/fljVflZgq91qL1NHCIwFTZdB?=
 =?us-ascii?Q?fnxgrJ/e8SZJBlnOepE7MFBy91lmJh3LDeltFpJAS0zly2ewm2O5gb3uOoLb?=
 =?us-ascii?Q?s9lWYRrn4FK0o5m9kQW/9VIl2LN2b//CvVKEkX7FzIjjJkh+y7uuKOGabNSy?=
 =?us-ascii?Q?Hj1q0GHLp0KGBoWuBF7HmSM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da7ffef6-7812-4cdf-733e-08db05c22d5d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 08:39:34.8450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3jES/iwYZSKcYsR3PU/yA4T8pl9XWq7RH8qjQi+hgYW8a4T955uTnvlxP+nE/rVXOAwjxZJ/iyi6W6uKx0rjs2ulNAzy6qMKE5OlaWNIHjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6166
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:00:54PM +0800, Xuan Zhuo wrote:
> The driver's tx napi is very important for XSK. It is responsible for
> obtaining data from the XSK queue and sending it out.
> 
> At the beginning, we need to trigger tx napi.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio/main.c |  12 +++-
>  drivers/net/virtio/xsk.c  | 146 ++++++++++++++++++++++++++++++++++++++
>  drivers/net/virtio/xsk.h  |   2 +
>  3 files changed, 159 insertions(+), 1 deletion(-)
> 

(...)

> +static int virtnet_xsk_xmit_batch(struct send_queue *sq,
> +				  struct xsk_buff_pool *pool,
> +				  unsigned int budget,
> +				  struct virtnet_sq_stats *stats)
> +{
> +	int ret = XSK_XMIT_NO_BUDGET;
> +	struct xdp_desc desc;
> +	int err, packet = 0;
> +
> +	while (budget-- > 0) {
> +		if (sq->vq->num_free < 2) {
> +			__free_old_xmit(sq, true, stats);
> +			if (sq->vq->num_free < 2) {
> +				ret = XSK_XMIT_DEV_BUSY;
> +				break;
> +			}
> +		}
> +
> +		if (!xsk_tx_peek_desc(pool, &desc)) {

anything that stopped from using xsk_tx_peek_release_desc_batch() ?

> +			ret = XSK_XMIT_DONE;
> +			break;
> +		}
> +
> +		err = virtnet_xsk_xmit_one(sq, pool, &desc);
> +		if (unlikely(err)) {
> +			ret = XSK_XMIT_DEV_BUSY;
> +			break;
> +		}
> +
> +		++packet;
> +
> +		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq))
> +			++stats->kicks;
> +	}
> +
> +	if (packet) {
> +		stats->xdp_tx += packet;
> +
> +		xsk_tx_release(pool);
> +	}
> +
> +	return ret;
> +}
> +
> +bool virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
> +		      int budget)
> +{
> +	struct virtnet_sq_stats stats = {};
> +	bool busy;
> +	int ret;
> +
> +	__free_old_xmit(sq, true, &stats);
> +
> +	if (xsk_uses_need_wakeup(pool))
> +		xsk_set_tx_need_wakeup(pool);
> +
> +	ret = virtnet_xsk_xmit_batch(sq, pool, budget, &stats);
> +	switch (ret) {
> +	case XSK_XMIT_DONE:
> +		/* xsk tx qeueu has been consumed done. should complete napi. */
> +		busy = false;
> +		break;
> +
> +	case XSK_XMIT_NO_BUDGET:
> +		/* reach the budget limit. should let napi run again. */
> +		busy = true;
> +		break;
> +
> +	case XSK_XMIT_DEV_BUSY:
> +		/* sq vring is full, should complete napi. wait for tx napi been
> +		 * triggered by interrupt.
> +		 */
> +		busy = false;
> +		break;
> +	}
> +
> +	virtnet_xsk_check_queue(sq);
> +
> +	u64_stats_update_begin(&sq->stats.syncp);
> +	sq->stats.packets += stats.packets;
> +	sq->stats.bytes += stats.bytes;
> +	sq->stats.kicks += stats.kicks;
> +	sq->stats.xdp_tx += stats.xdp_tx;
> +	u64_stats_update_end(&sq->stats.syncp);
> +
> +	return busy;
> +}
> +
>  static int virtnet_rq_bind_xsk_pool(struct virtnet_info *vi, struct receive_queue *rq,
>  				    struct xsk_buff_pool *pool, struct net_device *dev)
>  {
> diff --git a/drivers/net/virtio/xsk.h b/drivers/net/virtio/xsk.h
> index ad684c812091..15f1540a5803 100644
> --- a/drivers/net/virtio/xsk.h
> +++ b/drivers/net/virtio/xsk.h
> @@ -20,4 +20,6 @@ static inline u32 ptr_to_xsk(void *ptr)
>  }
>  
>  int virtnet_xsk_pool_setup(struct net_device *dev, struct netdev_bpf *xdp);
> +bool virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
> +		      int budget);
>  #endif
> -- 
> 2.32.0.3.g01195cf9f
> 
