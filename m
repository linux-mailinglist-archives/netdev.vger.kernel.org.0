Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9565665FB09
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 06:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbjAFFu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 00:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbjAFFuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 00:50:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC716C7D8
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 21:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B36AB81BF2
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAFD1C433B4;
        Fri,  6 Jan 2023 05:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672984217;
        bh=S/O8j+EyicKR6lXLVmQ60qjYRkgTTQOp4MYvQR6obkQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KJlYbnP1Tomx7P3OEGO7+Iu6ZwBcjuzg+wAEwK1wMyJk2C7W+RTlqN998jQ7uO2Hk
         4gexEdobVxDmRYefgj1VCqpiHcOPL6cG7YhFh6W0oYGY+7Pdhg3Z39fQ7Q8z0DTnHz
         H+BWm99OoTRXjeYywVbRkIVow0f45llBLVit5JuBJq4rgsbUaiqofVRnC5NDpYD2/+
         lBcxA1f6eYMYCqDLO1gRAhK7iaX4sSOAR9yw6MFhX2fXG0yM9MYCVKl1kfrXqQinY8
         HGJS/qklFUxRhfcsH1dE64ntxKTCWOKhYWmqRNqDMfV+Ub+v7urMYyNhukTfdA00tI
         KqDLjwSfvXTQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CABBCE21EEB;
        Fri,  6 Jan 2023 05:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/3] enetc: unlock XDP_REDIRECT for XDP non-linear
 buffers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167298421682.25075.4103122980233811312.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Jan 2023 05:50:16 +0000
References: <cover.1672840490.git.lorenzo@kernel.org>
In-Reply-To: <cover.1672840490.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 Jan 2023 14:57:09 +0100 you wrote:
> Unlock XDP_REDIRECT for S/G XDP buffer and rely on XDP stack to properly
> take care of the frames.
> Rely on XDP_FLAGS_HAS_FRAGS flag to check if it really necessary to access
> non-linear part of the xdp_buff/xdp_frame.
> 
> Changes since v1:
> - rebase on top of net-next
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/3] net: ethernet: enetc: unlock XDP_REDIRECT for XDP non-linear buffers
    https://git.kernel.org/netdev/net-next/c/8feb020f92a5
  - [v2,net-next,2/3] net: ethernet: enetc: get rid of xdp_redirect_sg counter
    https://git.kernel.org/netdev/net-next/c/59cc773a352c
  - [v2,net-next,3/3] net: ethernet: enetc: do not always access skb_shared_info in the XDP path
    https://git.kernel.org/netdev/net-next/c/c7030d14c78e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


