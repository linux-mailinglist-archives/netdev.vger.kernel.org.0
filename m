Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548B56B58B2
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 06:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCKFkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 00:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCKFkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 00:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC932E8CC3;
        Fri, 10 Mar 2023 21:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 695D9B824C1;
        Sat, 11 Mar 2023 05:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05B75C433D2;
        Sat, 11 Mar 2023 05:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678513218;
        bh=bJyckNVrVTbB93+vVGGowYUJvTM3LO9ZY+Ci+t4WU30=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ryJ+lYUiLYeVRvnPkhEzIUuYoGfkMut996iWxwfttVnv89TTIbofWsF+EoDhn5FP0
         msFB1sTE8Z73Jwju/aIsZ4lHwN8N8HgISb46mNdKEAMhoT+x0I/j2SUNYjMtcZGX9A
         WpSg0QMus0g8FSxWZlRzKoB7Vw/u4zV+ViMg8iHNYGb2Lq8TpulpUVcG4QQjVoZtPZ
         tIlRylnRZF6em95u2opIY+Y0l2sawRrdkM2no9v94DgDLwhzoEjkB1ZViUuHiAQ+aK
         AubqEZg6752+m635rrVgYqY2mxCAAIgkF20LGqv+cGwq6VydDnBm12dSRIGAQz1Rx4
         6NHraX3Z1aIbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E14DCE270C7;
        Sat, 11 Mar 2023 05:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] qede: remove linux/version.h and linux/compiler.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167851321791.18470.11928056741442093099.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 05:40:17 +0000
References: <20230309225206.2473644-1-usama.anjum@collabora.com>
In-Reply-To: <20230309225206.2473644-1-usama.anjum@collabora.com>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kernel@collabora.com, kernel-janitors@vger.kernel.org,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Mar 2023 03:52:05 +0500 you wrote:
> make versioncheck reports the following:
> ./drivers/net/ethernet/qlogic/qede/qede.h: 10 linux/version.h not needed.
> ./drivers/net/ethernet/qlogic/qede/qede_ethtool.c: 7 linux/version.h not needed.
> 
> So remove linux/version.h from both of these files. Also remove
> linux/compiler.h while at it as it is also not being used.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] qede: remove linux/version.h and linux/compiler.h
    https://git.kernel.org/netdev/net-next/c/95b744508d4d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


