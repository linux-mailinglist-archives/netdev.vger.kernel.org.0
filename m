Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A004AB5F5
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 08:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbiBGHjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 02:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236495AbiBGHa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 02:30:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30DDC043181;
        Sun,  6 Feb 2022 23:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01232B80EC3;
        Mon,  7 Feb 2022 07:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97CFC340F2;
        Mon,  7 Feb 2022 07:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644219022;
        bh=X5x54A97y8sC6EJ8vY4+xVcfKe5Kr8eIeAtgrOdb7PI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xmtiPzq6woXbK1rKgj2OauivMavcBfXFmLJKvZSk5GIXG/I+SFrdHFDJILqRgL/W2
         rn7hwL2vy4trbcFOg1xApr0a+0ErzQvEB6VmDpZH5SeZ3W5TagTwVeZF+dcBk3u4t9
         C8nbAotCa56GvhudBiXqqnsRUkNltECxmT6n3dI0=
Date:   Mon, 7 Feb 2022 08:30:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ayan Choudhary <ayanchoudhary1025@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Fix checkpatch errors in the module
Message-ID: <YgDKikJ27pCq0lfZ@kroah.com>
References: <20220207071500.2679-1-ayanchoudhary1025@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207071500.2679-1-ayanchoudhary1025@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 06, 2022 at 11:15:00PM -0800, Ayan Choudhary wrote:
> The qlge module had many checkpatch errors, this patch fixes most of them.
> The errors which presently remain are either false positives or
> introduce unncessary comments in the code.
> 
> Signed-off-by: Ayan Choudhary <ayanchoudhary1025@gmail.com>
> ---
>  drivers/staging/qlge/Kconfig     |  8 +++++---
>  drivers/staging/qlge/TODO        |  1 -
>  drivers/staging/qlge/qlge.h      | 24 ++++++++++++------------
>  drivers/staging/qlge/qlge_main.c | 12 +++++++++---
>  drivers/staging/qlge/qlge_mpi.c  | 11 +++++------
>  5 files changed, 31 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/staging/qlge/Kconfig b/drivers/staging/qlge/Kconfig
> index 6d831ed67965..21fd3f6e33d6 100644
> --- a/drivers/staging/qlge/Kconfig
> +++ b/drivers/staging/qlge/Kconfig
> @@ -5,7 +5,9 @@ config QLGE
>  	depends on ETHERNET && PCI
>  	select NET_DEVLINK
>  	help
> -	This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
> +		This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
>  
> -	To compile this driver as a module, choose M here. The module will be
> -	called qlge.
> +		Say Y here to enable support for QLogic ISP8XXX 10Gb Ethernet cards.
> +
> +		To compile this driver as a module, choose M here. The module will be
> +		called qlge.
> diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
> index c76394b9451b..3b57a36d867c 100644
> --- a/drivers/staging/qlge/TODO
> +++ b/drivers/staging/qlge/TODO
> @@ -30,4 +30,3 @@
>  * fix weird line wrapping (all over, ex. the ql_set_routing_reg() calls in
>    qlge_set_multicast_list()).
>  * fix weird indentation (all over, ex. the for loops in qlge_get_stats())
> -* fix checkpatch issues
> diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
> index 55e0ad759250..7de71bcdb928 100644
> --- a/drivers/staging/qlge/qlge.h
> +++ b/drivers/staging/qlge/qlge.h
> @@ -45,9 +45,8 @@
>  /* Calculate the number of (4k) pages required to
>   * contain a buffer queue of the given length.
>   */
> -#define MAX_DB_PAGES_PER_BQ(x) \
> -		(((x * sizeof(u64)) / DB_PAGE_SIZE) + \
> -		(((x * sizeof(u64)) % DB_PAGE_SIZE) ? 1 : 0))
> +#define MAX_DB_PAGES_PER_BQ(x) ((((x) * sizeof(u64)) / DB_PAGE_SIZE) + \
> +		((((x) * sizeof(u64)) % DB_PAGE_SIZE) ? 1 : 0))
>  
>  #define RX_RING_SHADOW_SPACE	(sizeof(u64) + \
>  		MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN) * sizeof(u64) + \
> @@ -1273,7 +1272,7 @@ struct qlge_net_req_iocb {
>   */
>  struct wqicb {
>  	__le16 len;
> -#define Q_LEN_V		(1 << 4)
> +#define Q_LEN_V		BIT(4)
>  #define Q_LEN_CPP_CONT	0x0000
>  #define Q_LEN_CPP_16	0x0001
>  #define Q_LEN_CPP_32	0x0002
> @@ -1308,7 +1307,7 @@ struct cqicb {
>  #define FLAGS_LI	0x40
>  #define FLAGS_LC	0x80
>  	__le16 len;
> -#define LEN_V		(1 << 4)
> +#define LEN_V		BIT(4)
>  #define LEN_CPP_CONT	0x0000
>  #define LEN_CPP_32	0x0001
>  #define LEN_CPP_64	0x0002
> @@ -1365,7 +1364,7 @@ struct tx_ring_desc {
>  	struct tx_ring_desc *next;
>  };
>  
> -#define QL_TXQ_IDX(qdev, skb) (smp_processor_id() % (qdev->tx_ring_count))
> +#define QL_TXQ_IDX(qdev, skb) (smp_processor_id() % ((qdev)->tx_ring_count))
>  
>  struct tx_ring {
>  	/*
> @@ -2030,9 +2029,9 @@ enum {
>  	STS_PAUSE_STD = 0x00000040,
>  	STS_PAUSE_PRI = 0x00000080,
>  	STS_SPEED_MASK = 0x00000038,
> -	STS_SPEED_100Mb = 0x00000000,
> -	STS_SPEED_1Gb = 0x00000008,
> -	STS_SPEED_10Gb = 0x00000010,
> +	STS_SPEED_100MB = 0x00000000,
> +	STS_SPEED_1GB = 0x00000008,
> +	STS_SPEED_10GB = 0x00000010,
>  	STS_LINK_TYPE_MASK = 0x00000007,
>  	STS_LINK_TYPE_XFI = 0x00000001,
>  	STS_LINK_TYPE_XAUI = 0x00000002,
> @@ -2072,6 +2071,7 @@ struct qlge_adapter *netdev_to_qdev(struct net_device *ndev)
>  
>  	return ndev_priv->qdev;
>  }
> +
>  /*
>   * The main Adapter structure definition.
>   * This structure has all fields relevant to the hardware.
> @@ -2097,8 +2097,8 @@ struct qlge_adapter {
>  	u32 alt_func;		/* PCI function for alternate adapter */
>  	u32 port;		/* Port number this adapter */
>  
> -	spinlock_t adapter_lock;
> -	spinlock_t stats_lock;
> +	spinlock_t adapter_lock; /* Spinlock for adapter */
> +	spinlock_t stats_lock; /* Spinlock for stats */
>  
>  	/* PCI Bus Relative Register Addresses */
>  	void __iomem *reg_base;
> @@ -2116,7 +2116,7 @@ struct qlge_adapter {
>  	u32 mailbox_in;
>  	u32 mailbox_out;
>  	struct mbox_params idc_mbc;
> -	struct mutex	mpi_mutex;
> +	struct mutex	mpi_mutex; /* Mutex for mpi */
>  
>  	int tx_ring_size;
>  	int rx_ring_size;
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 9873bb2a9ee4..6e4639237334 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -3890,7 +3890,7 @@ static int qlge_close(struct net_device *ndev)
>  	 * (Rarely happens, but possible.)
>  	 */
>  	while (!test_bit(QL_ADAPTER_UP, &qdev->flags))
> -		msleep(1);
> +		usleep_range(100, 1000);
>  
>  	/* Make sure refill_work doesn't re-enable napi */
>  	for (i = 0; i < qdev->rss_ring_count; i++)
> @@ -4085,7 +4085,11 @@ static struct net_device_stats *qlge_get_stats(struct net_device
>  	int i;
>  
>  	/* Get RX stats. */
> -	pkts = mcast = dropped = errors = bytes = 0;
> +	pkts = 0;
> +	mcast = 0;
> +	dropped = 0;
> +	errors = 0;
> +	bytes = 0;
>  	for (i = 0; i < qdev->rss_ring_count; i++, rx_ring++) {
>  		pkts += rx_ring->rx_packets;
>  		bytes += rx_ring->rx_bytes;
> @@ -4100,7 +4104,9 @@ static struct net_device_stats *qlge_get_stats(struct net_device
>  	ndev->stats.multicast = mcast;
>  
>  	/* Get TX stats. */
> -	pkts = errors = bytes = 0;
> +	pkts = 0;
> +	errors = 0;
> +	bytes = 0;
>  	for (i = 0; i < qdev->tx_ring_count; i++, tx_ring++) {
>  		pkts += tx_ring->tx_packets;
>  		bytes += tx_ring->tx_bytes;
> diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
> index 96a4de6d2b34..6020e337fc0d 100644
> --- a/drivers/staging/qlge/qlge_mpi.c
> +++ b/drivers/staging/qlge/qlge_mpi.c
> @@ -935,13 +935,12 @@ static int qlge_idc_wait(struct qlge_adapter *qdev)
>  			netif_err(qdev, drv, qdev->ndev, "IDC Success.\n");
>  			status = 0;
>  			break;
> -		} else {
> -			netif_err(qdev, drv, qdev->ndev,
> -				  "IDC: Invalid State 0x%.04x.\n",
> -				  mbcp->mbox_out[0]);
> -			status = -EIO;
> -			break;
>  		}
> +		netif_err(qdev, drv, qdev->ndev,
> +			  "IDC: Invalid State 0x%.04x.\n",
> +			  mbcp->mbox_out[0]);
> +		status = -EIO;
> +		break;
>  	}
>  
>  	return status;
> -- 
> 2.17.1
> 
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch did many different things all at once, making it difficult
  to review.  All Linux kernel patches need to only do one thing at a
  time.  If you need to do multiple things (such as clean up all coding
  style issues in a file/driver), do it in a sequence of patches, each
  one doing only one thing.  This will make it easier to review the
  patches to ensure that they are correct, and to help alleviate any
  merge issues that larger patches can cause.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
