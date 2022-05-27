Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C694C535F29
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 13:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351262AbiE0LUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 07:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244746AbiE0LUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 07:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C570D12698F;
        Fri, 27 May 2022 04:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68D5861CC4;
        Fri, 27 May 2022 11:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAB5CC34114;
        Fri, 27 May 2022 11:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653650412;
        bh=8/A7n2z+nS5p3OnINJGS1Ca9SMmvdtuU8IXec5mnEeM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M9pqykIsxnPjyft9LZIP0C+QMLCvpKgVuEvj/z4slwErxMasFBBwYOjGsJ8h6FXc+
         FYkGb1iXSL/b4QZB6dC8+gxheisK2JlEiaR9ngaGcH5ZNE4PCQijAfKJNXUlm3O94M
         gXWd4hA0r59/LTCZ8nf2TgisORzkUHYsRcSucJCv0WHKHinsRuLE0sZd1hPalhlrY3
         N+YUMztFFUlKs+PWajNGQey3LzJ4waYdWQVaZq/d/ikGJKKsPpsl5mSBtFDpL0BKyc
         LZiS7Q4yLcAA6vqYAftjCK5G6QRfI7y4UETA/YJYQZyMhX8G5P9O25l/Tq+KmbrIJs
         0EdAsC8PAroCA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 90BB8EAC081;
        Fri, 27 May 2022 11:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: qmi_wwan: add Telit 0x1250 composition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165365041258.2876.3963171338034628755.git-patchwork-notify@kernel.org>
Date:   Fri, 27 May 2022 11:20:12 +0000
References: <20220527082906.321165-1-c.lobrano@gmail.com>
In-Reply-To: <20220527082906.321165-1-c.lobrano@gmail.com>
To:     Carlo Lobrano <c.lobrano@gmail.com>
Cc:     bjorn@mork.no, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 27 May 2022 10:29:06 +0200 you wrote:
> Add support for Telit LN910Cx 0x1250 composition
> 
> 0x1250: rmnet, tty, tty, tty, tty
> 
> Signed-off-by: Carlo Lobrano <c.lobrano@gmail.com>
> ---
> 
> [...]

Here is the summary with links:
  - net: usb: qmi_wwan: add Telit 0x1250 composition
    https://git.kernel.org/netdev/net/c/2c262b21de6d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


