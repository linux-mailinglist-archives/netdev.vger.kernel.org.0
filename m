Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DFC6C54EB
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjCVTas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCVTar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:30:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2946C144A5;
        Wed, 22 Mar 2023 12:30:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B59E862287;
        Wed, 22 Mar 2023 19:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C1CC4339B;
        Wed, 22 Mar 2023 19:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679513446;
        bh=qb4Cqk1IJpCYq+KM7+9+6ckaVY3hfSvOkYqDCxvpBOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mBKyr5mrDxlJzrv5/FpKNxCbNbgSfE4Q1NQ4Rio/BNAXn2noygE2iQHwIEVboxKut
         wieKngtlSyTVSD0/DAgrwbDCjoS5rILrPm1lbawCZ0dQyueq20xbwpPrZsDA2Qy1o2
         sZ83ifw44z+Ntiur8kEtv3agcsI+gO1fsRbhPZps=
Date:   Wed, 22 Mar 2023 20:30:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Khadija Kamran <kamrankhadijadj@gmail.com>
Cc:     outreachy@lists.linux.dev, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Coiby Xu <coiby.xu@gmail.com>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: avoid multiple assignments
Message-ID: <ZBtXYxrrGtyCyBzK@kroah.com>
References: <ZBtVMs1wHWyyl2A6@khadija-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBtVMs1wHWyyl2A6@khadija-virtual-machine>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 12:21:22AM +0500, Khadija Kamran wrote:
> Linux kernel coding style does not allow multiple assignments on a
> single line.
> Avoid multiple assignments by assigning value to each variable in a
> separate line.
> 
> Signed-off-by: Khadija Kamran <kamrankhadijadj@gmail.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 1ead7793062a..b35fb7db2a77 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
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

Nah, the original is fine, it makes it more obvious what is happening.

thanks,

greg k-h
