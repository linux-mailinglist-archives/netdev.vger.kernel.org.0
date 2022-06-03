Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEC753C356
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 04:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238016AbiFCCsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 22:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiFCCsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 22:48:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CF6338BA;
        Thu,  2 Jun 2022 19:48:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5995061618;
        Fri,  3 Jun 2022 02:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D68C385A5;
        Fri,  3 Jun 2022 02:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654224517;
        bh=0yjv6yIGuuCsF28jC1oWN37CAZe1OojLqJTyuK1fAlM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dqvjSemHn4B/SAqJrv5LWrVHNQlq67l+qJ7JhnO55wKhSUt63Z+sfm0lgHM6MBH6Z
         Y5vxgRQCLYtQqTlfriFNhhQ4V0+jBttVFU5uRr8Y5tixohL+x0zjKafli4bXy1i4dY
         18CRvghUAixrc946nIYCudw7fY7p/uo9YhfacZPwb86XRbaF6qv5R5gQbhVKSZOqhB
         eJLUYX0O43Iic1S7w4EdYC0+JgSTWP221lvj5Sh3HPqxXh/MOFCR6vMXHqDYH0kTl8
         NiurbE2z8sSp0zpqCr23lubzH6eDy6uxHkELJ8YXvPPiqiCkrtBZ4qZreCMmZ79xMT
         D8mH/PO7L9hZQ==
Date:   Thu, 2 Jun 2022 19:48:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        <grygorii.strashko@ti.com>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>
Subject: Re: [PATCH v2 0/3] J7200: CPSW5G: Add support for QSGMII mode to
 am65-cpsw driver
Message-ID: <20220602194836.37e41003@kernel.org>
In-Reply-To: <20220602114558.6204-1-s-vadapalli@ti.com>
References: <20220602114558.6204-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Jun 2022 17:15:55 +0530 Siddharth Vadapalli wrote:
> Add support for QSGMII mode to am65-cpsw driver.
> 
> Change log:
> v1 -> v2:
> 1. Add new compatible for CPSW5G in ti,k3-am654-cpsw-nuss.yaml and extend
>    properties for new compatible.
> 2. Add extra_modes member to struct am65_cpsw_pdata to be used for QSGMII
>    mode by new compatible.
> 3. Add check for phylink supported modes to ensure that only one phy mode
>    is advertised as supported.
> 4. Check if extra_modes supports QSGMII mode in am65_cpsw_nuss_mac_config()
>    for register write.
> 5. Add check for assigning port->sgmii_base only when extra_modes is valid.
> 
> v1: https://lore.kernel.org/r/20220531113058.23708-1-s-vadapalli@ti.com

# Form letter - net-next is closed

We have already sent the networking pull request for 5.19
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.19-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
