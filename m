Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999D766E6C8
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 20:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjAQTPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 14:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjAQTL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 14:11:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBFF1BAEB;
        Tue, 17 Jan 2023 10:26:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14BDE614D9;
        Tue, 17 Jan 2023 18:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263B0C433D2;
        Tue, 17 Jan 2023 18:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673979973;
        bh=Q90VKPgW+JFewMBMzsuqXxzkJi00frMGuUon88lOkq4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WKUzgGiVxZPomNN4Vll7M7TaAlTGSxJlPBgepOpf9lT+Oim9Gn4s6/+RVIejzX3ji
         ClOaH5eELzunGqHvd8uW1lmpe1dsg5Ua2sgalCQ4GqrbxOUom/ex25fVlOsWQHSVH9
         wnZ2DGZ/n6Gz7YTYDNUCJEFzMVkHTExRnjKDuDVo=
Date:   Tue, 17 Jan 2023 19:26:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aldas =?utf-8?B?VGFyYcWha2V2acSNaXVz?= <aldas60@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: remove unnecessary spaces before function
 pointer args
Message-ID: <Y8boQ0T9yZ+78t7y@kroah.com>
References: <20221214205147.2172-1-aldas60@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221214205147.2172-1-aldas60@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 10:51:47PM +0200, Aldas Taraškevičius wrote:
> Remove unnecessary spaces before the function pointer arguments as
> warned by checkpatch.
> 
> Signed-off-by: Aldas Taraškevičius <aldas60@gmail.com>
> ---
>  drivers/staging/qlge/qlge.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
> index fc8c5ca89..05e4f4744 100644
> --- a/drivers/staging/qlge/qlge.h
> +++ b/drivers/staging/qlge/qlge.h
> @@ -2057,8 +2057,8 @@ enum {
>  };
>  
>  struct nic_operations {
> -	int (*get_flash) (struct ql_adapter *);
> -	int (*port_initialize) (struct ql_adapter *);
> +	int (*get_flash)(struct ql_adapter *);
> +	int (*port_initialize)(struct ql_adapter *);
>  };
>  
>  /*
> -- 
> 2.37.2
> 
> 

Does not apply to my tree :(
