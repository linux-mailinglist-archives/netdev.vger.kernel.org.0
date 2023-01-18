Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790AC671B9D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjARMLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjARMKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:10:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D97C4689;
        Wed, 18 Jan 2023 03:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 030FBB81C54;
        Wed, 18 Jan 2023 11:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCC4C433D2;
        Wed, 18 Jan 2023 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674041413;
        bh=wYh26QEkOVgnC4Jwvggs/1VX+pgdOvwPisiu0/vGJY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MAmp3jigIdgpYoymR5GLeOKBDqILizSsosDi/KzYw/H31lh0VLIPZkbYthLUikjZ7
         5WFS0KilKZaUm0M5yS11VHCCw6c+KB1yd6caqDBRo3pjKHAlCdBaVzgv9jj0Enadfb
         PPSCiLA6CQQI+aBd8GdKD3w8O/yjtgrUjwuuif0zSHGhFOP7rA0WHDTZ6r1jhDyI6n
         /YTfa8F42W8qCYUYBmJfgA7WjERHd5fIzP+QeKxJ0TBMM2winbxgkMTzxfwxGAhDUj
         SIA1gSM4L3Jr2NlPL5l2FaIfDrBtb68LnqEWflKle+EtLsHuLk0J2TRiLXVByGZZJV
         9ufutYYnJhhQA==
Date:   Wed, 18 Jan 2023 13:30:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, pabeni@redhat.com, rogerq@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, vigneshr@ti.com, srk@ti.com
Subject: Re: [PATCH net-next v3 1/2] net: ethernet: ti: am65-cpsw: Delete
 unreachable error handling code
Message-ID: <Y8fYPpymw0vxYJOz@unreal>
References: <20230118095439.114222-1-s-vadapalli@ti.com>
 <20230118095439.114222-2-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118095439.114222-2-s-vadapalli@ti.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 03:24:38PM +0530, Siddharth Vadapalli wrote:
> The am65_cpts_create() function returns -EOPNOTSUPP only when the config
> "CONFIG_TI_K3_AM65_CPTS" is disabled. Also, in the am65_cpsw_init_cpts()
> function, am65_cpts_create() can only be invoked if the config
> "CONFIG_TI_K3_AM65_CPTS" is enabled. Thus, the error handling code for the
> case in which the return value of am65_cpts_create() is -EOPNOTSUPP, is
> unreachable. Hence delete it.
> 
> Reported-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 5 -----
>  1 file changed, 5 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
