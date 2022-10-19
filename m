Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A85A60388E
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 05:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJSDU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 23:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJSDU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 23:20:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBCD3F33A;
        Tue, 18 Oct 2022 20:20:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FA48B8221A;
        Wed, 19 Oct 2022 03:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3237C433D7;
        Wed, 19 Oct 2022 03:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666149623;
        bh=gJEycanUf9gGnp3L1PIi2dkk5e+q+qTRjE3BZMq6M1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cj3LKLm1xcz0NEH444TVlqaZVbIMaO9mGGB8cIOR7/BxNK81Kp/YZlSZ/3aQM4A0m
         mq8p/Bruk2OgDO6URl9xrYKP9ysviVnm9fAuTueNuxxHJbEvOtTUS8p29s5Ilh3PkS
         CceAYZFKWLQejLkWD3v3wrsXE0swKHvSeOAwaP7FqDUu+VD9cW/OwSZ+JHO9qCnGUa
         MvDV6LR0WfwwRdO0HOhKGInvYFIBQ4sWOt70qBh8F1r9wIO0J7DCPgzhzwq+owoPCw
         ZMxK9i7PtwcsrZEGgsQ/Mj9YZvD/vX/7dE7aomCCC4QJax9MDwntM76+OuIG+8Zacc
         MuP7kaGYZLOOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BBE04C395E8;
        Wed, 19 Oct 2022 03:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-10-18
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166614962276.9993.11727617349988879636.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 03:20:22 +0000
References: <20221018210631.11211-1-daniel@iogearbox.net>
In-Reply-To: <20221018210631.11211-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Oct 2022 23:06:31 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 33 non-merge commits during the last 14 day(s) which contain
> a total of 31 files changed, 874 insertions(+), 538 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-10-18
    https://git.kernel.org/netdev/net-next/c/3566a79c9e36

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


