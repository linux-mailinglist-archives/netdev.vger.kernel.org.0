Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34B615925C
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 15:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbgBKO5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 09:57:02 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:48274 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728874AbgBKO5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 09:57:01 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 49F184C006F;
        Tue, 11 Feb 2020 14:57:00 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 11 Feb
 2020 14:56:50 +0000
Subject: Re: [PATCH net-next] sfc: remove unused variable
 'efx_default_channel_type'
To:     YueHaibing <yuehaibing@huawei.com>,
        <linux-net-drivers@solarflare.com>, <ecree@solarflare.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200211141606.47180-1-yuehaibing@huawei.com>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <e246665f-fe9b-ec62-a621-0ea0dff06771@solarflare.com>
Date:   Tue, 11 Feb 2020 14:56:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200211141606.47180-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25224.003
X-TM-AS-Result: No-6.311000-8.000000-10
X-TMASE-MatchedRID: hls5oAVArl/mLzc6AOD8DfHkpkyUphL9eouvej40T4gd0WOKRkwsh/pe
        Js18NRDdXqyKGNlj+bAOxUl2LETEm3DrA8J4/NO6AZ0lncqeHqE6En2bnefhoGmycYYiBYyZks5
        8+L3Ws1sEyFVhFPegL3HhDjUSt94q9juqgbPpsfEaLqFbxdotGXpDIEzkG1Rbva4hxzuVF7iHWB
        ThHZKIVEY7rq7vfUPSj0IvV7jlqDgNqsPpeYMTRQKDWtq/hHcNMf5Pdi+0fLaKIo9dsR2z7nimo
        7zurlpw6qOcH3wqCoCRk6XtYogiau9c69BWUTGwVnRXm1iHN1bEQdG7H66TyKsQd9qPXhnJyQqQ
        ZrAazVxrL0lCM08Fjy/znIWgItwCFPvEepO3VJpudG3FQXoSjwDmDh4iZYYoDtU0eCvOON0gttP
        P1len/on1TMBcKDRorp80Pt009yRR029mOM6P0LrcE8xytxC5d5hZXZFoB8PxWx93BSYyycC+ks
        T6a9fy
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.311000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25224.003
X-MDID: 1581433021-xzmZwC1-6Iwd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/02/2020 14:16, YueHaibing wrote:
> drivers/net/ethernet/sfc/efx.c:116:38: warning:
>  efx_default_channel_type defined but not used [-Wunused-const-variable=]

This is a good fix, but net-next is closed at the moment. Please resubmit it when it reopens.

> commit 83975485077d ("sfc: move channel alloc/removal code")
> left behind this, remove it.

Please add this info with a "Fixes:" tag.

Thanks,
Martin

> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/sfc/efx.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> index 4481f21a1f43..256807c28ff7 100644
> --- a/drivers/net/ethernet/sfc/efx.c
> +++ b/drivers/net/ethernet/sfc/efx.c
> @@ -113,7 +113,6 @@ MODULE_PARM_DESC(debug, "Bitmapped debugging message enable value");
>   *
>   *************************************************************************/
>  
> -static const struct efx_channel_type efx_default_channel_type;
>  static void efx_remove_port(struct efx_nic *efx);
>  static int efx_xdp_setup_prog(struct efx_nic *efx, struct bpf_prog *prog);
>  static int efx_xdp(struct net_device *dev, struct netdev_bpf *xdp);
> 
