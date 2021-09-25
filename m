Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4E241822F
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 15:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245385AbhIYNJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 09:09:08 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:57105 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245184AbhIYNJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 09:09:06 -0400
Received: from [192.168.1.18] ([90.126.248.220])
        by mwinf5d11 with ME
        id yD7N250044m3Hzu03D7NbK; Sat, 25 Sep 2021 15:07:30 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 25 Sep 2021 15:07:30 +0200
X-ME-IP: 90.126.248.220
Subject: Re: [PATCH 3/4] net: sis: Fix a function name in comments
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Newsgroups: gmane.linux.kernel,gmane.linux.network
References: <20210925125042.1629-1-caihuoqing@baidu.com>
 <20210925125042.1629-3-caihuoqing@baidu.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <1498cb33-bbd1-ccb7-0ea3-12b319e18dbe@wanadoo.fr>
Date:   Sat, 25 Sep 2021 15:07:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925125042.1629-3-caihuoqing@baidu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 25/09/2021 à 14:50, Cai Huoqing a écrit :
> Use dma_alloc_coherent() instead of pci_alloc_consistent(),
> because only dma_alloc_coherent() is called here.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>   drivers/net/ethernet/sis/sis190.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sis/sis190.c b/drivers/net/ethernet/sis/sis190.c
> index 3d1a18a01ce5..7e107407476a 100644
> --- a/drivers/net/ethernet/sis/sis190.c
> +++ b/drivers/net/ethernet/sis/sis190.c
> @@ -1070,7 +1070,7 @@ static int sis190_open(struct net_device *dev)
>   
>   	/*
>   	 * Rx and Tx descriptors need 256 bytes alignment.
> -	 * pci_alloc_consistent() guarantees a stronger alignment.
> +	 * dma_alloc_consistent() guarantees a stronger alignment.
>   	 */
>   	tp->TxDescRing = dma_alloc_coherent(&pdev->dev, TX_RING_BYTES,
>   					    &tp->tx_dma, GFP_KERNEL);
> 

Hi,
s/consistent/coherent/

CJ
