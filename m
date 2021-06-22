Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11F23AFE57
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 09:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhFVHwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 03:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhFVHwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 03:52:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D1BC061574;
        Tue, 22 Jun 2021 00:49:56 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso1284361pjp.5;
        Tue, 22 Jun 2021 00:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wjwJ0rnNQMFJ61cELhija7bj4Ok9LpvWfDHNn8zGRYE=;
        b=t8bDAzy2g5kYmm/gs1pVc39k78Hjrj+C9JWk5L95AZX2RUaWoad53f0cOIqnQogD9G
         cNGl1k13rcXvxLb4S/K+ivR16akcN4ulYqFmW2EtrTqcyqdEt9nD0vWw4Ck2mc4CtTVj
         xbP8/qrHEMb7uere8q40RznKvRN8A6IGbkb5dScWg6hESbFIHkdktWUQGNV2RcMMzUF6
         YO3ouGtMaN/p5hZmAKOqUKP22BbxWB4s9oNg/gPUNDtaLe69/O5ONgCFk3+955yfdKf9
         KLpCTFKtvojviELv2P2zTdFg0GRQC7E0dr7PwIfaCy6y2ZPALVhnzqmSaBg3E7C6+PLf
         ymWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wjwJ0rnNQMFJ61cELhija7bj4Ok9LpvWfDHNn8zGRYE=;
        b=tFMQNTRXatQRH7620bYuN24LhQ/4l2Jar/0eNjh8BBqIEEwrJnsRQv/hhijQnTKd7W
         F6jFIE0ZD2nEF6mtKRzIBL+eW+CHitQPketDlC43wVvnXHbI19zK9pQbdvygNN5gt5Ub
         DDkuXUGHwbm6JYbwZQwpycPhBwT+WU1a+5zdIJDnWvsfwoXca6hq1O/DTyG+7CBRMU53
         G76xFCOU44/aFLgC2qM5yFBBezPY0ga9DySsQWFtzGX72Xv/johBOcuZGov4lGSpoJFm
         Valvpk5ae9+V3NB5Btwb4i+FHjEdC2QD6uZ+u+dgG5SutZy8f1m5BHXalaETj+2GxfCx
         SoTQ==
X-Gm-Message-State: AOAM532+ONTN9dogXVlq3z7p0dNZeqVBeisuF7Z3MA1t12bylZtduRJx
        uEFkzm/daEhd7NsS4l34bFw=
X-Google-Smtp-Source: ABdhPJwMkJFdb3JyaXaaWZ6U3HPeZDZS4J5HyG6XqS/k1ubCT8uc0wyi0Yuw7THNVwKpDdNLWlSrYQ==
X-Received: by 2002:a17:90a:7381:: with SMTP id j1mr2613177pjg.29.1624348196159;
        Tue, 22 Jun 2021 00:49:56 -0700 (PDT)
Received: from d3 ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id p29sm10985201pfq.55.2021.06.22.00.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 00:49:55 -0700 (PDT)
Date:   Tue, 22 Jun 2021 16:49:51 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 06/19] staging: qlge: disable flow control by default
Message-ID: <YNGWHxYF5UkPk2U5@d3>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-7-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621134902.83587-7-coiby.xu@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-21 21:48 +0800, Coiby Xu wrote:
> According to the TODO item,
> > * the flow control implementation in firmware is buggy (sends a flood of pause
> >   frames, resets the link, device and driver buffer queues become
> >   desynchronized), disable it by default
> 
> Currently, qlge_mpi_port_cfg_work calls qlge_mb_get_port_cfg which gets
> the link config from the firmware and saves it to qdev->link_config. By
> default, flow control is enabled. This commit writes the
> save the pause parameter of qdev->link_config and don't let it
> overwritten by link settings of current port. Since qdev->link_config=0
> when qdev is initialized, this could disable flow control by default and
> the pause parameter value could also survive MPI resetting,
>     $ ethtool -a enp94s0f0
>     Pause parameters for enp94s0f0:
>     Autonegotiate:  off
>     RX:             off
>     TX:             off
> 
> The follow control can be enabled manually,
> 
>     $ ethtool -A enp94s0f0 rx on tx on
>     $ ethtool -a enp94s0f0
>     Pause parameters for enp94s0f0:
>     Autonegotiate:  off
>     RX:             on
>     TX:             on
> 
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  drivers/staging/qlge/TODO       |  3 ---
>  drivers/staging/qlge/qlge_mpi.c | 11 ++++++++++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
> index b7a60425fcd2..8c84160b5993 100644
> --- a/drivers/staging/qlge/TODO
> +++ b/drivers/staging/qlge/TODO
> @@ -4,9 +4,6 @@
>    ql_build_rx_skb(). That function is now used exclusively to handle packets
>    that underwent header splitting but it still contains code to handle non
>    split cases.
> -* the flow control implementation in firmware is buggy (sends a flood of pause
> -  frames, resets the link, device and driver buffer queues become
> -  desynchronized), disable it by default
>  * some structures are initialized redundantly (ex. memset 0 after
>    alloc_etherdev())
>  * the driver has a habit of using runtime checks where compile time checks are
> diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
> index 2630ebf50341..0f1c7da80413 100644
> --- a/drivers/staging/qlge/qlge_mpi.c
> +++ b/drivers/staging/qlge/qlge_mpi.c
> @@ -806,6 +806,7 @@ int qlge_mb_get_port_cfg(struct qlge_adapter *qdev)
>  {
>  	struct mbox_params mbc;
>  	struct mbox_params *mbcp = &mbc;
> +	u32 saved_pause_link_config = 0;

Initialization is not needed given the code below, in fact the
declaration can be moved to the block below.

>  	int status = 0;
>  
>  	memset(mbcp, 0, sizeof(struct mbox_params));
> @@ -826,7 +827,15 @@ int qlge_mb_get_port_cfg(struct qlge_adapter *qdev)
>  	} else	{
>  		netif_printk(qdev, drv, KERN_DEBUG, qdev->ndev,
>  			     "Passed Get Port Configuration.\n");
> -		qdev->link_config = mbcp->mbox_out[1];
> +		/*
> +		 * Don't let the pause parameter be overwritten by
> +		 *
> +		 * In this way, follow control can be disabled by default
> +		 * and the setting could also survive the MPI reset
> +		 */

It seems this comment is incomplete. Also, it's "flow control", not
"follow control".

> +		saved_pause_link_config = qdev->link_config & CFG_PAUSE_STD;
> +		qdev->link_config = ~CFG_PAUSE_STD & mbcp->mbox_out[1];
> +		qdev->link_config |= saved_pause_link_config;
>  		qdev->max_frame_size = mbcp->mbox_out[2];
>  	}
>  	return status;
> -- 
> 2.32.0
> 
