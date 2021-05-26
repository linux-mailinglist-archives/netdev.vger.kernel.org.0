Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4FF391E4F
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhEZRoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbhEZRob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 13:44:31 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8E2C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 10:42:59 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id m124so1543636pgm.13
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 10:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=dQR5wC4sRUElDhdYdkCuizmf2tTQ15gyq2zjrPUDPMg=;
        b=YppP9lWP+G+B7P7GfnPrz45Bd65n1A7tmjTzjzifQsDG0qfTx5TjRTxNXWUdNMt0Fm
         xUKP8VN4RtKjvfDXOcUhdtZ3vjMqe1h9XZ6psxJXpL4bVZpvHxm6j9aEVDTLHGxhnxIt
         CVGSWWVuVLvGGeBOp2T9DlNOKYumQFgxZc7uWP/sAmCjST1y7WsgvHiP7C44vYnjRupK
         90+U54RifDNNA2r4h+Cng+wcI+o0L7DteXrwa8uhKtq0+FY7GZtc9e499XVPrZYmEVGl
         7WXF+74sFaTQEBXrxpDKlNwEViQrmQpgROlRF4CWwOeCSbDtp5ogodVPUoD09gjhR+jl
         +FUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dQR5wC4sRUElDhdYdkCuizmf2tTQ15gyq2zjrPUDPMg=;
        b=ImoSW5G9VE3v202hOb7J4GkR765M0jXt5N7FHoyyssBFaeMnZvPi2QX7Q/J/RfFQcJ
         X/Dw38cyEdt11kppe2/Y+3H3KY22v1jnqoFt5SjGGaYRsOi6DnqyVy3I3sYgZFP47ylf
         sGsmVoG5V6XGHd4n89bWVa19boW5Hxhn8Oco9jrWB/mdkT3ayXxctfkbt9QOl1MkLXG0
         GcFaic3carJpR2usGrrVkzNLcV/OWdGOhn4zmfAx8EVdmUALkje8waFyIGZhqm2mOCpL
         EXGMjEI/BRTMcvi4HrbWC4qobzVjEYJBhsWzG8yiQREcrGtGVBONYiKXfS5HD53mQ7Kg
         o3+w==
X-Gm-Message-State: AOAM530h5NElOWlzyq/oSpguEq+MER6ILb6i9YZZSmtmVNLi6CAIXNcu
        +1IhSqu5e804AB0c+g+lxBYUZA==
X-Google-Smtp-Source: ABdhPJxgP64Nhk0LJmNu2dVTCL/7sxQN+o1GB9UvUdT1D50/SLarbwgmYbti7sYYMSp+eispl3gmlA==
X-Received: by 2002:a63:7107:: with SMTP id m7mr26702393pgc.287.1622050978739;
        Wed, 26 May 2021 10:42:58 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id o17sm6283pgj.25.2021.05.26.10.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 10:42:57 -0700 (PDT)
Subject: Re: [PATCH net-next 11/11] ixgbe: reduce checker warnings
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Dave Switzer <david.switzer@intel.com>
References: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
 <20210526172346.3515587-12-anthony.l.nguyen@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <b55ddf53-6456-2bf6-b58e-640b0ec7fcd3@pensando.io>
Date:   Wed, 26 May 2021 10:42:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210526172346.3515587-12-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/21 10:23 AM, Tony Nguyen wrote:
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
>
> Fix the sparse warnings in the ixgbe crypto offload code. These
> changes were made in the most conservative way (force cast)
> in order to hopefully not break the code. I suspect that the
> code might still be broken on big-endian architectures, but
> no one is complaining, so I'm just leaving it functionally
> the same.
>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Shannon Nelson <snelson@pensando.io>
> Tested-by: Dave Switzer <david.switzer@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Acked-by: Shannon Nelson <snelson@pensando.io>

> ---
> Warning Detail:
> .../ixgbe/ixgbe_ipsec.c:514:56: warning: restricted __be32 degrades to integer
> .../ixgbe/ixgbe_ipsec.c:521:48: warning: restricted __be32 degrades to integer
> .../ixgbe/ixgbe_ipsec.c:536:59: warning: restricted __be32 degrades to integer
> .../ixgbe/ixgbe_ipsec.c:546:59: warning: restricted __be32 degrades to integer
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> index 54d47265a7ac..e596e1a9fc75 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> @@ -511,14 +511,14 @@ static int ixgbe_ipsec_check_mgmt_ip(struct xfrm_state *xs)
>   					continue;
>   
>   				reg = IXGBE_READ_REG(hw, MIPAF_ARR(3, i));
> -				if (reg == xs->id.daddr.a4)
> +				if (reg == (__force u32)xs->id.daddr.a4)
>   					return 1;
>   			}
>   		}
>   
>   		if ((bmcipval & BMCIP_MASK) == BMCIP_V4) {
>   			reg = IXGBE_READ_REG(hw, IXGBE_BMCIP(3));
> -			if (reg == xs->id.daddr.a4)
> +			if (reg == (__force u32)xs->id.daddr.a4)
>   				return 1;
>   		}
>   
> @@ -533,7 +533,7 @@ static int ixgbe_ipsec_check_mgmt_ip(struct xfrm_state *xs)
>   
>   			for (j = 0; j < 4; j++) {
>   				reg = IXGBE_READ_REG(hw, MIPAF_ARR(i, j));
> -				if (reg != xs->id.daddr.a6[j])
> +				if (reg != (__force u32)xs->id.daddr.a6[j])
>   					break;
>   			}
>   			if (j == 4)   /* did we match all 4 words? */
> @@ -543,7 +543,7 @@ static int ixgbe_ipsec_check_mgmt_ip(struct xfrm_state *xs)
>   		if ((bmcipval & BMCIP_MASK) == BMCIP_V6) {
>   			for (j = 0; j < 4; j++) {
>   				reg = IXGBE_READ_REG(hw, IXGBE_BMCIP(j));
> -				if (reg != xs->id.daddr.a6[j])
> +				if (reg != (__force u32)xs->id.daddr.a6[j])
>   					break;
>   			}
>   			if (j == 4)   /* did we match all 4 words? */

