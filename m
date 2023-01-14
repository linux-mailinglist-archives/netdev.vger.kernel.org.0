Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A26466ACC8
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 18:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjANRCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 12:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjANRCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 12:02:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB92A5F0
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 09:02:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 417ACB80A23
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 17:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A58A8C433F1;
        Sat, 14 Jan 2023 17:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673715717;
        bh=GMqlf0KYJiRQ2a4KrJN5/7XyTd7VHjN5+1wIQo1ACZ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UVsNdFSJpCoa1AdGvpEr2xBH3MPrvg7J66XCNM20DlrnTMMPGlPtTk7sqkzLpAGf4
         wocI6dNrwT2Cw8ceNLo0AOiGr72bYN+/dlQbqyea0FKxvRUi6vUiKGyExEB69cWlpQ
         xLwlf0XTuCpHJ1a+cgByLNR+vF9N3fCJNePw1apGC8KpyuIFtlUmnPygKcVzeO4zZo
         NwomBpggh8UzRuWQaSXinTI8AKMGNwhHx6YU5iq/9uZ6TcxrZ4WzW7vdgLamHVB7fJ
         Kd+DeKoeBLcxT4InS2q/DQhQummRn0qnt/eVzz+xv0gawbzeFn+bEwB4xK2wiEdTzu
         D0//gm5HFMQTw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89AF1C395C8;
        Sat, 14 Jan 2023 17:01:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] man: ss: remove duplicated option name
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167371571755.23476.8594056667846001084.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 17:01:57 +0000
References: <20230114062944.3246-1-jwilk@jwilk.net>
In-Reply-To: <20230114062944.3246-1-jwilk@jwilk.net>
To:     Jakub Wilk <jwilk@jwilk.net>
Cc:     netdev@vger.kernel.org, peilin.ye@bytedance.com, dsahern@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Sat, 14 Jan 2023 07:29:44 +0100 you wrote:
> Signed-off-by: Jakub Wilk <jwilk@jwilk.net>
> ---
>  man/man8/ss.8 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [iproute2] man: ss: remove duplicated option name
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=221da6275eb2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


