Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64845B1FDD
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 15:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbiIHN71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 09:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbiIHN7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 09:59:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D9B1316F0;
        Thu,  8 Sep 2022 06:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=F+/Dxjohl88DP9zeW/Xq+d0mtw7wj+FfyyXk6EaZSa8=; b=URjDC6QafAo8lH5tx9N07vvvRg
        7U/2jNIrM6zD2kAmhisaZZcqoycHrpRbj0oE3acueFAa5SVqP8WHnqRJAz+QEl9qHGRkEWD2fZTQE
        HjbbYmKLWkebzrfHQoNE/5kl2Yc+uY5rgC3HFhmPVVLTl8sYAOF1BQW+Wd5XFcqTuBrvHx+g5xT8r
        +XdVKx1WlcaLrSRYfwE1phdKUIo8XYGvzHA1V9rGlihPu2A9jSkiiQaY9BuQjN13pUWXAY73Fwabp
        EqAPnHXI1drft5hKgKcYpqDCHS0n9IKMxdoxpTzg2EQQxxkUOjVhYhI9HVF814Xdwc5/WwyarCWNn
        uALq/oEw==;
Received: from [2601:1c0:6280:3f0::a6b3]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oWI2Z-004Gmq-L3; Thu, 08 Sep 2022 13:57:59 +0000
Message-ID: <f76d0607-4753-3131-3b09-9d2ef4b3a60f@infradead.org>
Date:   Thu, 8 Sep 2022 06:57:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] mellanox/mlxsw: fix repeated words in comments
Content-Language: en-US
To:     wangjianli <wangjianli@cdjrlc.com>, idosch@nvidia.com,
        petrm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220908124350.22861-1-wangjianli@cdjrlc.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220908124350.22861-1-wangjianli@cdjrlc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/22 05:43, wangjianli wrote:
> Delete the redundant word 'in'.
> 
> Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> index 2c4443c6b964..48f1fa62a4fd 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> @@ -1819,7 +1819,7 @@ void mlxsw_sp_ipip_entry_demote_tunnel(struct mlxsw_sp *mlxsw_sp,
>  /* The configuration where several tunnels have the same local address in the
>   * same underlay table needs special treatment in the HW. That is currently not
>   * implemented in the driver. This function finds and demotes the first tunnel
> - * with a given source address, except the one passed in in the argument
> + * with a given source address, except the one passed in the argument

Yeah, either way is OK.

>   * `except'.
>   */
>  bool

-- 
~Randy
