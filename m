Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47832649A36
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 09:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiLLImE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 03:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiLLImC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 03:42:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A015EC779;
        Mon, 12 Dec 2022 00:42:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 558D1B80BA7;
        Mon, 12 Dec 2022 08:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D89C433EF;
        Mon, 12 Dec 2022 08:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670834519;
        bh=bp9hj0RVByKQktcC0dW/qzUFrg5xq9JprWMyU7tTG14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iQcLCJ7aZQwe9+6zjZl79n61zWOtEzrvlyRFS1IxQ0qOhRvjjHH4mhH5YEbUQqiPB
         WT4Y1hJABUHLJW2mUZ7fSej1hdbKx4jtK++PEaBOUoMIvedc/WJ/FavPwfaInmpgDa
         lKwGagt0HpwSXYINnsdB7CP4dhu48s8V0BaS8KKTLckjse2E1WCS28BTsVZ6f2MH6g
         xU7+bfVfkWm57KxjxqX94YqiU2GmN8zJGy8rkV9b17a7baqd8Ob1ON5Adh/zsweIno
         k78qYH/dihM4JAKwwh+aWTPbNKd3HbE043YdYhVoK3PPR9Q5LC4JmXIqnk48/vkSmU
         R57tb+YXlX7lg==
Date:   Mon, 12 Dec 2022 10:41:54 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] net: ksz884x: Remove the unused function
 port_cfg_force_flow_ctrl()
Message-ID: <Y5bpUnqOij8HduWh@unreal>
References: <20221212035309.33507-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212035309.33507-1-jiapeng.chong@linux.alibaba.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 11:53:09AM +0800, Jiapeng Chong wrote:
> The function port_cfg_force_flow_ctrl() is defined in the ksz884x.c file,
> but not called elsewhere, so remove this unused function.
> 
> drivers/net/ethernet/micrel/ksz884x.c:2212:20: warning: unused function 'port_cfg_force_flow_ctrl'.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3418
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/micrel/ksz884x.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
> index e6acd1e7b263..46f1fbf58b5a 100644
> --- a/drivers/net/ethernet/micrel/ksz884x.c
> +++ b/drivers/net/ethernet/micrel/ksz884x.c
> @@ -2209,12 +2209,6 @@ static inline void port_cfg_back_pressure(struct ksz_hw *hw, int p, int set)
>  		KS8842_PORT_CTRL_2_OFFSET, PORT_BACK_PRESSURE, set);
>  }
>  
> -static inline void port_cfg_force_flow_ctrl(struct ksz_hw *hw, int p, int set)
> -{
> -	port_cfg(hw, p,
> -		KS8842_PORT_CTRL_2_OFFSET, PORT_FORCE_FLOW_CTRL, set);
> -}
> -
>  static inline int port_chk_back_pressure(struct ksz_hw *hw, int p)

This function is not called too. Many functions in that file can be
removed. Please do it in one patch.

Thanks

>  {
>  	return port_chk(hw, p,
> -- 
> 2.20.1.7.g153144c
> 
