Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76D0553058
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiFULAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiFULAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3966A29817
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 04:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDC56616C5
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 11:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32573C3411D;
        Tue, 21 Jun 2022 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655809213;
        bh=ykRENzANQVqCCz6eZBY4s4tA6fsApN35yUWJ59ZKdWE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ROMjblfTqsBegVCalZfDlDCsBatZC3Dafz5+SzdmXv77eGdQCGy6qhTO0VHYRzkKT
         xeppstWSY7InhQZoWaele5WeZvYUHmVHHhMojkg/Cv3DmGONioT/uV6P8zfiNUTu8p
         V3C1ym7rxxz2OsH0dZXHINsOig1S7gLLGYamqi9nk+wOtJLXHSNhiALyYuAKZKGown
         NzuRSxkghPXjAUcseZx1ePRR8sJGF3dxzD2MV9VTAKrEevNtCu6hc07vMI+A4mxT8U
         cBYfaeYB2xD3QvA90ydqFvgK+Sw3RIyUb2V7yFYf9+Ycr7R09QlPhNpyq+kZPe3WAg
         w1s+bT8IyrW1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16236E73875;
        Tue, 21 Jun 2022 11:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: compose firmware file name with new hwinfo
 "nffw.partno"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165580921308.31228.13702816292923701377.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Jun 2022 11:00:13 +0000
References: <20220620103912.46164-1-simon.horman@corigine.com>
In-Reply-To: <20220620103912.46164-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        yu.xiao@corigine.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 20 Jun 2022 12:39:12 +0200 you wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> During initialization of the NFP driver, a file name for loading
> application firmware is composed using the NIC's AMDA information and port
> type (count and speed). E.g.: "nic_AMDA0145-1012_2x10.nffw".
> 
> In practice there may be many variants for each NIC type, and many of the
> variants relate to assembly components which do not concern the driver and
> application firmware implementation. Yet the current scheme leads to a
> different application firmware file name for each variant, because they
> have different AMDA information.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: compose firmware file name with new hwinfo "nffw.partno"
    https://git.kernel.org/netdev/net-next/c/00bb2920cf6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


