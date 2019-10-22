Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7FB0E0DB0
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 23:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731559AbfJVVOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 17:14:46 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42425 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731528AbfJVVOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 17:14:45 -0400
Received: by mail-lf1-f68.google.com with SMTP id z12so14240996lfj.9
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 14:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=vYqMjummwERb5IofjR9czKB3FoZwQgBzjXJ48cqEbE0=;
        b=sJmKHk7eO1gkBDnSs47w4j2IrMqgr9eBu5b50OpbtoCkB5AokcUFUcb+449GgmWwGm
         VM5daNll4E/AaX0bE/JuMLzdyCR90wq8Q8n90LfaxjT4qRr95X/7KGSm/KbDn5wO3soa
         88wg7Irv7U1Nuy51nZOFYdMFMieVhus0stf4vJCl6MNtn5hX63+1lsP9bXz+yezmjo36
         6ibLKqIUHTtBKHSHE6blwz9MgC2smu52ruEV+3fLWw6tfhG9+9QdAjIwcLWVyHPz3p2b
         xVpS+jD5o1AQdwjdI+881sy/EzhSRWMzcLZ1lj6WU2eetW/OluCIS8MEl9WYbzaunATZ
         1S1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vYqMjummwERb5IofjR9czKB3FoZwQgBzjXJ48cqEbE0=;
        b=CuSSjx0BSqZb2usa+8Y9goCK1qztMnpKXKu+utpzsspDJl84IMSasU3bE3GNv420MX
         XpZh6EUOtRnmY4ZJGP/eMG0YoNONG8XrtELG5dRZG3PwnaevnT2liZ2AACOBDOicuTJz
         gD95m2pTJXj66FqdsXcIqQorssB9BXCzNxau43cPpW6xT70dQxf9FB92eJW4M5iAS8Sv
         dxawR1cyaXRr6h+nFzA3yc8XHnqwtbJUDts3+6v+XGyvSpN2L1vaKYo6zB5lsyeDT9vh
         EFxrmcvjdlZEXOVFMaejw//0KBIB2/ygXSueLtmsD6vwQPuXcE0aC0MN5vQeNcwMrTW/
         DY+A==
X-Gm-Message-State: APjAAAVGy79fLtQkHVLqjqiVaP9/qW8KrJdFIa7yZ3+y/Sfk9CRkgxbl
        rAHixmv9tSMM+i+R8V5gMAPhgzQ0S9c=
X-Google-Smtp-Source: APXvYqxaE87C63jUoyV00hkaj932fGMK8ei+OSs93RbmjGMpKe82gB0Gr82sal/TrXDXEaAGmYZ1kQ==
X-Received: by 2002:a19:6f0e:: with SMTP id k14mr20192449lfc.79.1571778883629;
        Tue, 22 Oct 2019 14:14:43 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y189sm13333150lfc.9.2019.10.22.14.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 14:14:43 -0700 (PDT)
Date:   Tue, 22 Oct 2019 14:14:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, roy.pledge@nxp.com,
        laurentiu.tudor@nxp.com
Subject: Re: [PATCH net-next v2 5/6] dpaa_eth: change DMA device
Message-ID: <20191022141436.4f727890@cakuba.netronome.com>
In-Reply-To: <1571742901-22923-6-git-send-email-madalin.bucur@nxp.com>
References: <1571742901-22923-1-git-send-email-madalin.bucur@nxp.com>
        <1571742901-22923-6-git-send-email-madalin.bucur@nxp.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 14:15:00 +0300, Madalin Bucur wrote:
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 8d5686d88d30..639cafaa59b8 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -1335,15 +1335,15 @@ static void dpaa_fd_release(const struct net_device *net_dev,
>  		vaddr = phys_to_virt(qm_fd_addr(fd));
>  		sgt = vaddr + qm_fd_get_offset(fd);
>  
> -		dma_unmap_single(dpaa_bp->dev, qm_fd_addr(fd), dpaa_bp->size,
> -				 DMA_FROM_DEVICE);
> +		dma_unmap_single(dpaa_bp->priv->rx_dma_dev, qm_fd_addr(fd),
> +				 dpaa_bp->size, DMA_FROM_DEVICE);
>  
>  		dpaa_release_sgt_members(sgt);
>  
> -		addr = dma_map_single(dpaa_bp->dev, vaddr, dpaa_bp->size,
> -				      DMA_FROM_DEVICE);
> -		if (dma_mapping_error(dpaa_bp->dev, addr)) {
> -			dev_err(dpaa_bp->dev, "DMA mapping failed");
> +		addr = dma_map_single(dpaa_bp->priv->rx_dma_dev, vaddr,
> +				      dpaa_bp->size, DMA_FROM_DEVICE);
> +		if (dma_mapping_error(dpaa_bp->priv->rx_dma_dev, addr)) {
> +			netdev_err(net_dev, "DMA mapping failed");

You seem to be missing new line chars at the end of the "DMA mapping
failed" messages :( Could you please fix all of them and repost?

>  			return;
>  		}
>  		bm_buffer_set64(&bmb, addr);
