Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4802C957E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 04:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbgLADBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 22:01:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgLADBo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 22:01:44 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 852392084C;
        Tue,  1 Dec 2020 03:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606791663;
        bh=6aFXGkwevyzlfDmesoBGvpBj54ZArXwIjgNsw19fi8E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PtUdw53U/VQEApWwKxaULSfxhDWPRiLJCCgdRf4XprojDKz7OxRTw9HNl863YMgXe
         tq8Akfs1BKX162Mvu41L80gicPBg5YO+HaMVh/Cv3k2+lOvntfapc26OrHldDc4sdE
         qhaznIrgWMY3SekUClI/0VtHtj64xJ13ZYRaR4lM=
Date:   Mon, 30 Nov 2020 19:01:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     rmody@marvell.com, skalluru@marvell.com, davem@davemloft.net,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bna: remove trailing semicolon in macro definition
Message-ID: <20201130190102.3220d9eb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127165550.2693417-1-trix@redhat.com>
References: <20201127165550.2693417-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 08:55:50 -0800 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> The macro use will already have a semicolon.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/net/ethernet/brocade/bna/bna_hw_defs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/brocade/bna/bna_hw_defs.h b/drivers/net/ethernet/brocade/bna/bna_hw_defs.h
> index f335b7115c1b..4b19855017d7 100644
> --- a/drivers/net/ethernet/brocade/bna/bna_hw_defs.h
> +++ b/drivers/net/ethernet/brocade/bna/bna_hw_defs.h
> @@ -218,7 +218,7 @@ do {									\
>  
>  /* Set the coalescing timer for the given ib */
>  #define bna_ib_coalescing_timer_set(_i_dbell, _cls_timer)		\
> -	((_i_dbell)->doorbell_ack = BNA_DOORBELL_IB_INT_ACK((_cls_timer), 0));
> +	((_i_dbell)->doorbell_ack = BNA_DOORBELL_IB_INT_ACK((_cls_timer), 0))
>  
>  /* Acks 'events' # of events for a given ib while disabling interrupts */
>  #define bna_ib_ack_disable_irq(_i_dbell, _events)			\
> @@ -260,7 +260,7 @@ do {									\
>  
>  #define bna_txq_prod_indx_doorbell(_tcb)				\
>  	(writel(BNA_DOORBELL_Q_PRD_IDX((_tcb)->producer_index), \
> -		(_tcb)->q_dbell));
> +		(_tcb)->q_dbell))
>  
>  #define bna_rxq_prod_indx_doorbell(_rcb)				\
>  	(writel(BNA_DOORBELL_Q_PRD_IDX((_rcb)->producer_index), \

Same story here as Daniel pointed out for the BPF patch.

There are 2 macros right below here which also have a semicolon at the
end. And these ones are used. So the patch appears to be pretty arbitrary.
