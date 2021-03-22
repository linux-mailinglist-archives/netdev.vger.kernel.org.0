Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E642344F5D
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 19:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbhCVS6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 14:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhCVS57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 14:57:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49651C061764;
        Mon, 22 Mar 2021 11:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=F1VGSYHn4YFG1IOMrKB92bbrxwOjzJNXg/ULli3TtCw=; b=WA1YJUF1Tr2KfR4cyVdTjaEOCa
        k09mPE0c/52m3XNIZJwaP1D8MB+7IpUcBEwXrCJuR4B9Oeg6puozV056mVScAWDlDgDlkvOlHAX1V
        9Msgo91ETTpKRgPd+4sAF2ZFJONOhlU8osEIPtyI9EN9ps6bLcB9r7soLKfSm1pMe+m20u9vtGilz
        /u1rZ5AWToRSLP1xQwveGajykaOi4JI+Y+50vn+6Hv+czzCpoO48nGfsgftxzv0fhIMU2xnSi7TuE
        VS5H1saBWmuS68q/TtkCPCW7wzrM9acWzpsMS/FYCUW2rKa2ZV5qTAjbXd3a2q6Aw8YLiVCkEI+xP
        SON0VqaQ==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOPjv-008wey-Qk; Mon, 22 Mar 2021 18:57:28 +0000
Subject: Re: [PATCH] liquidio: Fix a typo
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210322063122.3397260-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <865331ba-242f-fa94-e8ca-a1dbedc4832d@infradead.org>
Date:   Mon, 22 Mar 2021 11:57:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322063122.3397260-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/21 11:31 PM, Bhaskar Chowdhury wrote:
> 
> s/struture/structure/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/ethernet/cavium/liquidio/octeon_device.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.h b/drivers/net/ethernet/cavium/liquidio/octeon_device.h
> index fb380b4f3e02..b402facfdc04 100644
> --- a/drivers/net/ethernet/cavium/liquidio/octeon_device.h
> +++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.h
> @@ -880,7 +880,7 @@ void octeon_set_droq_pkt_op(struct octeon_device *oct, u32 q_no, u32 enable);
>  void *oct_get_config_info(struct octeon_device *oct, u16 card_type);
> 
>  /** Gets the octeon device configuration
> - *  @return - pointer to the octeon configuration struture
> + *  @return - pointer to the octeon configuration structure

No, that's not proper kernel-doc syntax.

>   */
>  struct octeon_config *octeon_get_conf(struct octeon_device *oct);
> 
> --


-- 
~Randy

