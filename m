Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E52450A677
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 19:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390494AbiDURDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 13:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbiDURDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 13:03:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBAD49259;
        Thu, 21 Apr 2022 10:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5D67B82779;
        Thu, 21 Apr 2022 17:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E31FC385AE;
        Thu, 21 Apr 2022 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650560413;
        bh=CoLsn958x3fiMjs8GjcOOZ+6XqtOgBdC9BJVZp5WP/I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TXW08gVXbWfdX4lpa2AvJjjmk5Pz3ioALOE52oDs0v+Kf7R+T1llkXz5CHvLQdkhL
         sSjsQZWfrjJcSWOW6jkzpGarloo1F3MRgbtYPmNinLL9LeY8Swh+Qx+xbZ5gBSKRbF
         ucppNxK4WtLS/CFHM34IeQFyQIffwDl347MXVSC78i/4jygbc33sy9KupNCEv2KOXP
         e6wk2ti3O1vOszonWMPOO2MY4HZ0K2faVgCu8qzutulwGeMBWr1PlGz8fG7MuGsOjm
         qkThU0C7iuOOAdTREMPfUEM0PLYGFrUFTl8xHdD3t+IM4vOgUq0m8BxBZwDfdzjVUG
         Wwz7b7vUL9KXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7EF14E8DBDA;
        Thu, 21 Apr 2022 17:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: fix prog_tests/uprobe_autoattach
 compilation error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165056041351.10585.8509341938702940506.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Apr 2022 17:00:13 +0000
References: <20220421132317.1583867-1-asavkov@redhat.com>
In-Reply-To: <20220421132317.1583867-1-asavkov@redhat.com>
To:     Artem Savkov <asavkov@redhat.com>
Cc:     alan.maguire@oracle.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 21 Apr 2022 15:23:17 +0200 you wrote:
> I am getting the following compilation error for prog_tests/uprobe_autoattach.c
> 
> tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c: In function ‘test_uprobe_autoattach’:
> ./test_progs.h:209:26: error: pointer ‘mem’ may be used after ‘free’ [-Werror=use-after-free]
> 
> mem variable is now used in one of the asserts so it shouldn't be freed right
> away. Move free(mem) after the assert block.
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: fix prog_tests/uprobe_autoattach compilation error
    https://git.kernel.org/bpf/bpf-next/c/6a12b8e20d7e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


