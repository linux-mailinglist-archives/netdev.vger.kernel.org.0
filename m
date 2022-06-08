Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2719054374B
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244339AbiFHPZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244024AbiFHPYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:24:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA88411C2D;
        Wed,  8 Jun 2022 08:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65F8CB82872;
        Wed,  8 Jun 2022 15:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 198DFC341C4;
        Wed,  8 Jun 2022 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654701613;
        bh=sc+8TXwmgI/YW0TB9tuyx5N1Xp/PSnr8gluTVZq+VqI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kgIjXret0g6pYYwvW0yUvdiB/Ug2XJOCw9qrBw0yEqQG4wi43Jo+hX7Pa0NQLJZ6b
         +ZoWO200UJtQaF4OvDQzH+jRJ5sqrcIdLLHGX+N7XAL7CfWnj3WnoGBu8RfO2PCrae
         Wy/zmEGWF8JjvNZt5Kn4S43TgqAgyOmYK6tOFnxFQ6vVlyagMrns0PPpr+ehW5eg5J
         SZIPqTO3qt007uBSXOsFtToRZD08gzIsBem4iuOJA/rdieqgVly5jDnaTkfQPCr4Fh
         pt+NzFnlmwm6q7pDLi6+N0Dei29QJhPePMHjNeVNUA8JOTVownTU1njBjecAOcxY3+
         wm75R2iC7iPnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2CDDE737F6;
        Wed,  8 Jun 2022 15:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] MAINTAINERS: Add a maintainer for bpftool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165470161299.28499.14141065960762162831.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 15:20:12 +0000
References: <20220608121428.69708-1-quentin@isovalent.com>
In-Reply-To: <20220608121428.69708-1-quentin@isovalent.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed,  8 Jun 2022 13:14:28 +0100 you wrote:
> I've been contributing and reviewing patches for bpftool for some time,
> and I'm taking care of its external mirror. On Alexei, KP, and Daniel's
> suggestion, I would like to step forwards and become a maintainer for
> the tool. This patch adds a dedicated entry to MAINTAINERS.
> 
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> 
> [...]

Here is the summary with links:
  - [bpf] MAINTAINERS: Add a maintainer for bpftool
    https://git.kernel.org/bpf/bpf/c/7c217aca85dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


