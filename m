Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D837F5BA5F9
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 06:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiIPEjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 00:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiIPEjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 00:39:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BBD2EF28;
        Thu, 15 Sep 2022 21:39:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBCACB8238E;
        Fri, 16 Sep 2022 04:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A5CC433C1;
        Fri, 16 Sep 2022 04:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663303187;
        bh=qaWzNt16Fu0APLvunyNPiTVzoCIa9T/+oRGyO0EdnU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ATXjEz1AuxWXLtKk29PT67fyWtC6khPZD59WAd/D0oyCrQ/p99CqRE1aySG46fVJd
         hAiye+gYYnkoB+KCtvKbU/gEsL/RB42hnHcgsWydaXiU2RWr/vjdnheyO3tEwJNORo
         04TZ53De6AXfD4D9q+puq5MUd5WCpZsGUeN8c/BTFa65oJmQ5042MPH+USYgEVtT4M
         R9s1O8ljmW/5sJcex1h8YSIEf/swd8W/xFV7kZaYd+7cc/u4iGiv1uDbLb5+tYQrNv
         7MlHuQ0B/sq9EngMXNBrR49MpOan65UdS1UxrwfuHkCVpa/AUnGohk3kmwtKC0/Ie8
         PDoqjZepVS1fQ==
Date:   Fri, 16 Sep 2022 10:09:43 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] MAINTAINERS: Add myself as a reviewer for Qualcomm
 ETHQOS Ethernet driver
Message-ID: <YyP+D/JUrXd8fDwn@matsya>
References: <20220915112804.3950680-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915112804.3950680-1-bhupesh.sharma@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15-09-22, 16:58, Bhupesh Sharma wrote:
> As suggested by Vinod, adding myself as the reviewer
> for the Qualcomm ETHQOS Ethernet driver.
> 
> Recently I have enabled this driver on a few Qualcomm
> SoCs / boards and hence trying to keep a close eye on
> it.

Thanks Bhupesh for helping out.

Acked-By: Vinod Koul <vkoul@kernel.org>

> 
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c26a5c573a5d..e8b58d4afce5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16943,6 +16943,7 @@ F:	drivers/net/ethernet/qualcomm/emac/
>  
>  QUALCOMM ETHQOS ETHERNET DRIVER
>  M:	Vinod Koul <vkoul@kernel.org>
> +R:	Bhupesh Sharma <bhupesh.sharma@linaro.org>
>  L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/qcom,ethqos.txt
> -- 
> 2.37.1

-- 
~Vinod
