Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E326B57C9
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 03:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjCKCUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 21:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjCKCUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 21:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6494F1691
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 18:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50A5761D93
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 02:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB09AC433D2;
        Sat, 11 Mar 2023 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678501217;
        bh=OEynhwVfaNWLnisHYACfxWBG6kuU9HXBybllTFsk7W4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FWeXwn5I+Cnj6ytnZ8XAAlkxftFo6FlpvFfGUkeLqvglU4Q2XWKFprGMCKQJiAT+M
         8Id+EZzB1zlYXMx31NhPQx/G9zPYWPA7QHenrpe61JkKc7Wsfsl7yPZ09lJOhyx0Mh
         J5ykCibz/hIfo3Gp3c66U/vg/ub0U3YB8zjfHGJoIHM/XTF4XNbKDExK6wuVD/CFV9
         DHdUzOKJKzR6RTTfhIDik22gTK0hI/IhS95IU688j0iSAEcxFaracnuDyvd8x8Spym
         QWoNfND1jIfhLKIdhtuKK6Lb2A/zG/XrQdUmn+93y/VaZ4tf/7TFjCuZyYtNqZ0VqW
         mh67J1rknFNxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91D90E61B66;
        Sat, 11 Mar 2023 02:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next] MAINTAINERS: make my email address consistent
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167850121759.30210.9589737970741261140.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 02:20:17 +0000
References: <20230309114911.923460-1-jiri@resnulli.us>
In-Reply-To: <20230309114911.923460-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Mar 2023 12:49:11 +0100 you wrote:
> Use jiri@resnulli.us in all MAINTAINERS entries and fixup .mailmap
> so all other addresses point to that one.
> 
> Signed-off-by: Jiri Pirko <jiri@resnulli.us>
> ---
>  .mailmap    | 3 +++
>  MAINTAINERS | 6 +++---
>  2 files changed, 6 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] MAINTAINERS: make my email address consistent
    https://git.kernel.org/netdev/net/c/71582371a5ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


