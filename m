Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BDC58320E
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiG0ScJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbiG0Sbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:31:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA80726E5
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0491B821E5
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 17:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A27BDC433D7;
        Wed, 27 Jul 2022 17:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658943013;
        bh=/sfHO75qUMN0w4SeCEEcNvbLB0CJ4B19tjOPQWO1gpI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VgfinSp/wgdY+baLSJ26FsboFPmaefJsqUPF1A4wCTZsuj2X4L+/WDac/5ggYbVsr
         XfZ2zVdbFECGopZKtzSeNsmchgakSWldji8V0zH9OvJYlFp5/xEl48jLCp9qEF2AvW
         QRo/gVxDJ/R6LklEQweImn8ZevdrIOnW21DeBY8KsQdslWPo4urXFZDTZFiIqXzC++
         8f9SvaPKnUMCcEe7dt+2rGcr+ZJiNCmerU9FfI/rB79ySZulNYq1L0B1jRcCd2Vg4e
         3w/mvFmQCG7LZnbY8+oCQBXipEQZnWGtc4O1Vkyv76MT/A86B0UQm7+mSWNajvuA3M
         w82zdkQBLEs3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 85921C43143;
        Wed, 27 Jul 2022 17:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: md5: fix IPv4-mapped support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165894301354.12646.18027757487570283684.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jul 2022 17:30:13 +0000
References: <20220726115743.2759832-1-edumazet@google.com>
In-Reply-To: <20220726115743.2759832-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, brianvv@google.com,
        dima@arista.com, dsahern@kernel.org, cdleonard@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Jul 2022 11:57:43 +0000 you wrote:
> After the blamed commit, IPv4 SYN packets handled
> by a dual stack IPv6 socket are dropped, even if
> perfectly valid.
> 
> $ nstat | grep MD5
> TcpExtTCPMD5Failure             5                  0.0
> 
> [...]

Here is the summary with links:
  - [net] tcp: md5: fix IPv4-mapped support
    https://git.kernel.org/netdev/net/c/e62d2e110356

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


