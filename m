Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BA74F8E8D
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbiDHEMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 00:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiDHEMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 00:12:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4B41EA5E7;
        Thu,  7 Apr 2022 21:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DABCD61E16;
        Fri,  8 Apr 2022 04:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 346FDC385A6;
        Fri,  8 Apr 2022 04:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649391012;
        bh=s5hllkVWyKG3dwiRu2x53s6FttJzBDWJDsJdzlkdWME=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tQtUUgGg5F+MPr7OtlF15gjaq27E6Zt5oTtYbUl2IgZ5J+XKJdW2J79ZC2vsqr9X8
         p5JAhzAbMHSWGHfcw0v21guqZ1gk6W3U7dFZkvfvQtwhChgngCotkIyRL4Nq5+sSLA
         JG6oK/EWssmOZutGwnPZqTkXnK+7VIBV3gpyXO/aFgZKu0Hxfv/78DHusX3UE4C/BU
         h2BzgHPPyJQ9gh9+tHFcN9gwCKrDl49Xzngz5iaaa85nADt0A2xfWQ1ePEQJ7IW2Zu
         3/Fq6VK2PgEtF/YA3GIGhKjTGakuFDnemmdHxcGcaz6wZ5adJrKQQm/a3wiFRM1Fiv
         2q/eZALTS+MmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18876E8DBDD;
        Fri,  8 Apr 2022 04:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sfc: Stop using iommu_present()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164939101209.29309.3949750124677153031.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 04:10:12 +0000
References: <7350f957944ecfce6cce90f422e3992a1f428775.1649166055.git.robin.murphy@arm.com>
In-Reply-To: <7350f957944ecfce6cce90f422e3992a1f428775.1649166055.git.robin.murphy@arm.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  5 Apr 2022 14:40:55 +0100 you wrote:
> Even if an IOMMU might be present for some PCI segment in the system,
> that doesn't necessarily mean it provides translation for the device
> we care about. It appears that what we care about here is specifically
> whether DMA mapping ops involve any IOMMU overhead or not, so check for
> translation actually being active for our device.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> 
> [...]

Here is the summary with links:
  - [net-next] sfc: Stop using iommu_present()
    https://git.kernel.org/netdev/net-next/c/6a62924c0a81

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


