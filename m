Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2E93466B5
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 18:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhCWRtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 13:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhCWRtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 13:49:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAB1C061574;
        Tue, 23 Mar 2021 10:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=mGEfqR1UYPmFe4Iqx4QUJhJA8g5z7S5be6OQeBV2P6c=; b=oLjBoU33t5KC2LpJ1AoIAZq7YP
        wslL/KfZNrYL74hZ0l3NZqrgA3VVOPNJz4hlbFRLVXAMvX2+vtoxz+3w6SnJmGi9Yt+CG7DOdTGI2
        rUiNdHGCRhTznZPNxfo4DO7J4Sl2XJm0737x496SomCHArahEn4rdyWOQQ0LRZR0o0IDnvzUV/fiM
        4PoLE7ZtO9YRoFKTQiJHRZfpVQMerGOnOLnbMDJwCr4lvptaSsSrBWTdfrezbm2gABHtH+Vz5k9H3
        +Laybg5WGl7qwkxrkdG8edAiaFVYK+u/tIiIkDPMCLVrqAMySATgeUDN2/LmnWJe1N59Z0DcSPvD4
        R08ut6vw==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOl9E-00AMe8-VV; Tue, 23 Mar 2021 17:48:59 +0000
Subject: Re: [PATCH V2] octeontx2-af: Few mundane typos fixed
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210323094327.2386998-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b2cb2dc4-93f6-8b0e-4d1a-56a1d1c16285@infradead.org>
Date:   Tue, 23 Mar 2021 10:48:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210323094327.2386998-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/21 2:43 AM, Bhaskar Chowdhury wrote:
> s/preceeds/precedes/  .....two different places
> s/rsponse/response/
> s/cetain/certain/
> s/precison/precision/
> 
> Fix a sentence construction as per suggestion.
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  Changes from V1:
>   Bad sentence construction missed my eyes , correced by following
>   Randy's suggestion.
> 
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> index ea456099b33c..8a6227287e34 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> @@ -74,13 +74,13 @@ struct otx2_mbox {
>  	struct otx2_mbox_dev *dev;
>  };
> 
> -/* Header which preceeds all mbox messages */
> +/* Header which precedes all mbox messages */
>  struct mbox_hdr {
>  	u64 msg_size;	/* Total msgs size embedded */
>  	u16  num_msgs;   /* No of msgs embedded */
>  };
> 
> -/* Header which preceeds every msg and is also part of it */
> +/* Header which precedes every msg and is also part of it */
>  struct mbox_msghdr {
>  	u16 pcifunc;     /* Who's sending this msg */
>  	u16 id;          /* Mbox message ID */
> @@ -277,8 +277,8 @@ struct msg_req {
>  	struct mbox_msghdr hdr;
>  };
> 
> -/* Generic rsponse msg used a ack or response for those mbox
> - * messages which doesn't have a specific rsp msg format.
> +/* Generic response msg used an ack or response for those mbox
> + * messages which don't have a specific rsp msg format.
>   */
>  struct msg_rsp {
>  	struct mbox_msghdr hdr;
> @@ -299,7 +299,7 @@ struct ready_msg_rsp {
> 
>  /* Structure for requesting resource provisioning.
>   * 'modify' flag to be used when either requesting more
> - * or to detach partial of a cetain resource type.
> + * or to detach partial of a certain resource type.
>   * Rest of the fields specify how many of what type to
>   * be attached.
>   * To request LFs from two blocks of same type this mailbox
> @@ -489,7 +489,7 @@ struct cgx_set_link_mode_rsp {
>  };
> 
>  #define RVU_LMAC_FEAT_FC		BIT_ULL(0) /* pause frames */
> -#define RVU_LMAC_FEAT_PTP		BIT_ULL(1) /* precison time protocol */
> +#define RVU_LMAC_FEAT_PTP		BIT_ULL(1) /* precision time protocol */
>  #define RVU_MAC_VERSION			BIT_ULL(2)
>  #define RVU_MAC_CGX			BIT_ULL(3)
>  #define RVU_MAC_RPM			BIT_ULL(4)
> --


-- 
~Randy

