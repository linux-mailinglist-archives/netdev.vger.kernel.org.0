Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C79613BC1
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 17:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiJaQxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 12:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiJaQwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 12:52:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9337D12AFD;
        Mon, 31 Oct 2022 09:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F4B36132A;
        Mon, 31 Oct 2022 16:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DEAC433D6;
        Mon, 31 Oct 2022 16:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667235165;
        bh=0JIVdmCSxvBhopJ9FdzrsaVhQ2YhdJAYxPIqL5Dx9Nw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lx4okneXGlHAOFuF4ANbl2tFOqdatXWlr/6aLNid7s0gmE8P6KrYH5TqGjJoTzuUb
         6AXU6fCpjJw0x3DfhRjVmKh7F6Uso3WZeXPlEuU/xuPeX2f8BICwbbHaTocbsG0sEi
         cm98rdagkNeqFzQ0L8HrLo5vGb2DCLDuiVxQ2vQE=
Date:   Mon, 31 Oct 2022 17:53:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     drake@draketalley.com
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: qlge: Separate multiple assignments
Message-ID: <Y1/9lQpZuDFYsjnT@kroah.com>
References: <20221031142516.266704-1-drake@draketalley.com>
 <20221031142516.266704-2-drake@draketalley.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031142516.266704-2-drake@draketalley.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 10:25:14AM -0400, drake@draketalley.com wrote:
> From: Drake Talley <drake@draketalley.com>
> 
> Adhere to coding style.
> 
> Reported by checkpatch:
> 
> > CHECK: multiple assignments should be avoided
> > #4088: FILE: drivers/staging/qlge/qlge_main.c:4088
> 
> > CHECK: multiple assignments should be avoided
> > #4108: FILE: drivers/staging/qlge/qlge_main.c:4108:
> 
> Signed-off-by: Drake Talley <drake@draketalley.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 1ead7793062a..8c1fdd8ebba0 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -4085,7 +4085,12 @@ static struct net_device_stats *qlge_get_stats(struct net_device
>  	int i;
>  
>  	/* Get RX stats. */
> -	pkts = mcast = dropped = errors = bytes = 0;
> +	pkts = 0;
> +	mcast = 0;
> +	dropped = 0;
> +	errors = 0;
> +	bytes = 0;
> +
>  	for (i = 0; i < qdev->rss_ring_count; i++, rx_ring++) {
>  		pkts += rx_ring->rx_packets;
>  		bytes += rx_ring->rx_bytes;
> @@ -4100,7 +4105,10 @@ static struct net_device_stats *qlge_get_stats(struct net_device
>  	ndev->stats.multicast = mcast;
>  
>  	/* Get TX stats. */
> -	pkts = errors = bytes = 0;
> +	pkts = 0;
> +	errors = 0;
> +	bytes = 0;
> +
>  	for (i = 0; i < qdev->tx_ring_count; i++, tx_ring++) {
>  		pkts += tx_ring->tx_packets;
>  		bytes += tx_ring->tx_bytes;
> -- 
> 2.34.1
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

- You did not specify a description of why the patch is needed, or
  possibly, any description at all, in the email body.  Please read the
  section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what is needed in order to
  properly describe the change.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
