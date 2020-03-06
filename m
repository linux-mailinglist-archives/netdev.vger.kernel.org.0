Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F33B517B719
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 07:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgCFG60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 01:58:26 -0500
Received: from ivanoab7.miniserver.com ([37.128.132.42]:50624 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgCFG60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 01:58:26 -0500
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1jA6vx-00052L-Va; Fri, 06 Mar 2020 06:58:10 +0000
Received: from sleer.kot-begemot.co.uk ([192.168.3.72])
        by jain.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1jA6vv-0004hT-MA; Fri, 06 Mar 2020 06:58:09 +0000
Subject: Re: [PATCH net-next 1/7] um: reject unsupported coalescing params
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org,
        dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org,
        linux-rdma@vger.kernel.org, edumazet@google.com,
        jasowang@redhat.com, mkubecek@suse.cz, hayeswang@realtek.com,
        doshir@vmware.com, pv-drivers@vmware.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, gregkh@linuxfoundation.org,
        merez@codeaurora.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20200306010602.1620354-1-kuba@kernel.org>
 <20200306010602.1620354-2-kuba@kernel.org>
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
Organization: Cambridge Greys
Message-ID: <fd59e667-38cb-6b16-8a27-311c7da523d0@cambridgegreys.com>
Date:   Fri, 6 Mar 2020 06:58:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200306010602.1620354-2-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/03/2020 01:05, Jakub Kicinski wrote:
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
> 
> This driver did not previously reject unsupported parameters.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   arch/um/drivers/vector_kern.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
> index 0ff86391f77d..e98304d0219e 100644
> --- a/arch/um/drivers/vector_kern.c
> +++ b/arch/um/drivers/vector_kern.c
> @@ -1508,6 +1508,7 @@ static int vector_set_coalesce(struct net_device *netdev,
>   }
>   
>   static const struct ethtool_ops vector_net_ethtool_ops = {
> +	.supported_coalesce_params = ETHTOOL_COALESCE_TX_USECS,
>   	.get_drvinfo	= vector_net_get_drvinfo,
>   	.get_link	= ethtool_op_get_link,
>   	.get_ts_info	= ethtool_op_get_ts_info,
> 

Acked-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/
