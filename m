Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63D85908B0
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 00:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbiHKWUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 18:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbiHKWUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 18:20:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A59911A2C;
        Thu, 11 Aug 2022 15:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA040B82300;
        Thu, 11 Aug 2022 22:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D9FEC433D7;
        Thu, 11 Aug 2022 22:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660256414;
        bh=4DE+2rkRrSJypifXeUmFu/ZlM8o+6184LRxXOsvLKHE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=urOKOqznZCd7dcN7VgXlPhXCIcralpx9VMC+r4qiRYKVAtc00pjlPHz6Nh+pAB3fx
         UCLXfhKAKPk0Olbf9n9QDCjE/52x69rUKK0zUX4i28WglP6D/k/P7ALZXHsct732BK
         KU9IO6pe8u+yY5+0dqnbyAvyQwBZ4REMkMvAMh6RKYPaCqhe+BOlUtl8HWwrqIaZKf
         GCApgYxJRdh+VA+qOIWbij3M+xXWziz6+Ry84WTOh6h4iN/DJZ/BU0bcZZErNN0CmP
         04NWde6FHogZJRQfZLYNKR23BbQtIij1v0EfVBkCp6K10fWvYi8YAdPKIYnTYcsfSl
         LOzlKV4Dlp6Bw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71174C43142;
        Thu, 11 Aug 2022 22:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 bpf-next] libbpf: Add names for auxiliary maps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166025641445.7395.1437251099610923659.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 22:20:14 +0000
References: <20220811034020.529685-1-liuhangbin@gmail.com>
In-Reply-To: <20220811034020.529685-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, quentin@isovalent.com, andrii@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, bpf@vger.kernel.org
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

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Thu, 11 Aug 2022 11:40:20 +0800 you wrote:
> The bpftool self-created maps can appear in final map show output due to
> deferred removal in kernel. These maps don't have a name, which would make
> users confused about where it comes from.
> 
> With a libbpf_ prefix name, users could know who created these maps.
> It also could make some tests (like test_offload.py, which skip base maps
> without names as a workaround) filter them out.
> 
> [...]

Here is the summary with links:
  - [PATCHv3,bpf-next] libbpf: Add names for auxiliary maps
    https://git.kernel.org/bpf/bpf-next/c/10b62d6a38f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


