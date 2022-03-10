Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DD04D4012
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 05:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239391AbiCJEBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 23:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236531AbiCJEBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 23:01:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A0D12CC05
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 20:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9FA2617F7
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D2C8C36AE2;
        Thu, 10 Mar 2022 04:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646884811;
        bh=NStWDaQTn81jCKfycUPoQsHbzBxqlUCkJzCpoH+/Q9Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RfBgmU9qhCE4z7zRSW/9kp9/ZxGkrl7y3kcH7MuQmW7vBmyf1kVnXx9tOnJan+dQU
         lQ9AabCqIKY1rtdEeoOsGHtUSlHQYYOwv7bjgtCA3CFGf6a4ttFxBZd+wcdn/0HT3X
         n3Zgla7GG5VgO90lK5A0dhGn2oeCAgm58cr8znM68PrnR21r/b0BiNcqdsabDewriO
         eDCPMW+9RSKAPQ86YxqnmIkb7fkZ8U/W+We9p1FCJy4E/bK+uriF0Cn6uXed7+bve2
         EXoL7XWKaHVcmJlsNfNMjhAZC909kjKVdxrejxWDdzRomvX1NAMK11UFPTucQOF0QM
         KUp6KF8f+0H6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 29054F0383F;
        Thu, 10 Mar 2022 04:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] bnxt: revert hastily merged uAPI aberrations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688481116.32652.15650958856932030710.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 04:00:11 +0000
References: <20220308173659.304915-1-kuba@kernel.org>
In-Reply-To: <20220308173659.304915-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  8 Mar 2022 09:36:59 -0800 you wrote:
> This reverts:
>  commit 02acd399533e ("bnxt_en: parse result field when NVRAM package install fails")
>  commit 22f5dba5065d ("bnxt_en: add an nvm test for hw diagnose")
>  commit bafed3f231f7 ("bnxt_en: implement hw health reporter")
> 
> These patches are still under discussion / I don't think they
> are right, and since the authors don't reply promptly let me
> lessen my load of "things I need to resolve before next release"
> and revert them.
> 
> [...]

Here is the summary with links:
  - [net-next] bnxt: revert hastily merged uAPI aberrations
    https://git.kernel.org/netdev/net-next/c/4a5eaa2fde59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


