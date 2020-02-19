Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F4416445B
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 13:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgBSMfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 07:35:48 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:33832 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726491AbgBSMfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 07:35:47 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 063D9800077;
        Wed, 19 Feb 2020 12:35:46 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 19 Feb
 2020 12:35:41 +0000
Subject: Re: [PATCH v2 net-next] sfc: remove unused variable
 'efx_default_channel_type'
To:     YueHaibing <yuehaibing@huawei.com>,
        <linux-net-drivers@solarflare.com>, <ecree@solarflare.com>,
        <davem@davemloft.net>, <amaftei@solarflare.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200211141606.47180-1-yuehaibing@huawei.com>
 <20200219013458.47620-1-yuehaibing@huawei.com>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <14ded279-719b-41f6-0ee6-56e782f9cfb5@solarflare.com>
Date:   Wed, 19 Feb 2020 12:35:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200219013458.47620-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25240.003
X-TM-AS-Result: No-5.114700-8.000000-10
X-TMASE-MatchedRID: oTBA/+sdKabmLzc6AOD8DfHkpkyUphL9eouvej40T4gd0WOKRkwsh/pe
        Js18NRDdXqyKGNlj+bAOxUl2LETEm3DrA8J4/NO6bm8pd3f6T7/wKD5QtMI+mVSOymiJfTYXeUp
        nydDvXEaGy3RToYQak6q9CuM/w766nMA3Sw1wynk/ApMPW/xhXkyQ5fRSh2650AWKUvQ4UnVdaO
        8DxOlYWKT06nkcV3iq9D5vXEWlG7Z2m+j+coBLPp4CIKY/Hg3AtOt1ofVlaoLUHQeTVDUrItRnE
        QCUU+jzjoczmuoPCq3oqCWlP9IHhbGpmBtOWT82gNZ8DuQuuZDHoz0dNUiX8ZdruZ1qStaEIUNv
        dCYa2BPomz7ic/IL9UsRVrP5dTCHdThcEcVE5i3i+fTMx9KaNitss6PUa4/cD6GAt+UbooSj1CO
        4X0EqeXggXFAhtWiYlExlQIQeRG0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.114700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25240.003
X-MDID: 1582115746-XXmW6YoeFmi8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/02/2020 01:34, YueHaibing wrote:
> drivers/net/ethernet/sfc/efx.c:116:38: warning:
>  efx_default_channel_type defined but not used [-Wunused-const-variable=]
> 
> commit 83975485077d ("sfc: move channel alloc/removal code")
> left behind this, remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 83975485077d ("sfc: move channel alloc/removal code")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Martin Habets <mhabets@solarflare.com>

> ---
> v2: Add Fixes tag
> ---
>  drivers/net/ethernet/sfc/efx.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> index 4481f21..256807c 100644
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
