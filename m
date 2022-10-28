Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07746611960
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 19:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJ1RiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 13:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ1RiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 13:38:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD0822B79D;
        Fri, 28 Oct 2022 10:38:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C7C26299B;
        Fri, 28 Oct 2022 17:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCF1C433C1;
        Fri, 28 Oct 2022 17:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666978699;
        bh=pSH5TbZ4op8f2G25l5havY6JqLWPvfAfAEWvyxloAGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ki/WuuaTC0CqMRrkL3PdRkOsUynzz5otdqvITRi2vKXFZZiD9i4nQAGl9prbZjEC4
         yoEiQmX78l6Tq8dduc/HBsBkndcQfdQNOqfb1ygbONppjTR6lP7YmtZFbJxCmtliya
         2RZDkxdt65erVttCqUz3t3Mgv5iVOKzNdx5G/pxItkEuTADlHQ0ALoTRMJAsoSO9dF
         VJDi0W6OY76V7ZPoanyfPCHK9lS8xo5dGJLY1kFb9UmY0RTbJkxGiRpPHoWGRhVUOC
         XkKo2BungZxgnSxJ4z7pgXUlX4a8yVDP2DeHavPDtnY7LYpYIHNGpNgxqiu5ssVBKS
         qXxg4lXxVkbkg==
Date:   Fri, 28 Oct 2022 23:08:10 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Fabio Porcedda <fabio.porcedda@gmail.com>
Cc:     mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, dnlplm@gmail.com
Subject: Re: [PATCH 2/2] bus: mhi: host: pci_generic: Add a secondary AT port
 to Telit FN990
Message-ID: <20221028173810.GI13880@thinkpad>
References: <20220916144329.243368-1-fabio.porcedda@gmail.com>
 <20220916144329.243368-3-fabio.porcedda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220916144329.243368-3-fabio.porcedda@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 04:43:29PM +0200, Fabio Porcedda wrote:
> Add a secondary AT port using one of OEM reserved channel.
> 
> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>

Applied to mhi-next!

Thanks,
Mani

> ---
>  drivers/bus/mhi/host/pci_generic.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
> index 51e2b901bae0..caa4ce28cf9e 100644
> --- a/drivers/bus/mhi/host/pci_generic.c
> +++ b/drivers/bus/mhi/host/pci_generic.c
> @@ -507,6 +507,8 @@ static const struct mhi_channel_config mhi_telit_fn990_channels[] = {
>  	MHI_CHANNEL_CONFIG_DL(13, "MBIM", 32, 0),
>  	MHI_CHANNEL_CONFIG_UL(32, "DUN", 32, 0),
>  	MHI_CHANNEL_CONFIG_DL(33, "DUN", 32, 0),
> +	MHI_CHANNEL_CONFIG_UL(92, "DUN2", 32, 1),
> +	MHI_CHANNEL_CONFIG_DL(93, "DUN2", 32, 1),
>  	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0_MBIM", 128, 2),
>  	MHI_CHANNEL_CONFIG_HW_DL(101, "IP_HW0_MBIM", 128, 3),
>  };
> -- 
> 2.37.3
> 
> 

-- 
மணிவண்ணன் சதாசிவம்
