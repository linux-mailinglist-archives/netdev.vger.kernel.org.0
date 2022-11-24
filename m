Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3476381C6
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 00:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiKXXhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 18:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiKXXhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 18:37:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CD331FAE;
        Thu, 24 Nov 2022 15:35:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD773B828FD;
        Thu, 24 Nov 2022 23:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71813C433D6;
        Thu, 24 Nov 2022 23:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669332616;
        bh=Z9yUZa4U9UgBEHy8xYQRS04iHfkW2jbGjpKVxRd8HEk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i+sVmx+qQ7echEisdy5UCq88vKoeuuMI7DmJcnxRDMPzip9IKKzqqqCmAWPvQChIa
         ec/s8nJEbCWLaxx/WI8X2U2kOg1QbtgH667PXq6usOs6HmFv73HsBlEhVQnCF5+9G5
         3b8f1jflZmQ2iG7S+SS1CDl3vrCJigCOvLyfTcwdsQk9XpOqBH3exviUZplJgEMXHi
         W6fRbhuBOWmtJIzkgZru01vYdaltQcvocCZKU0LnyZ5tnlSGYjOuAJIwV0s1baN9VO
         kcdcxdTDp2F9L8F98ON4W6hLMIIyS3QgVnIemn5EJkxOyTRBlOnxzG8gMXb/0tvnAu
         xkJnhbd9b/PqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 541DFE270C7;
        Thu, 24 Nov 2022 23:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] samples/bpf: xdp_router_ipv4_user: Fix write
 overflow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166933261633.8867.4416066132556284849.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 23:30:16 +0000
References: <tencent_F9E2E81922B0C181D05B96DAE5AB0ACE6B06@qq.com>
In-Reply-To: <tencent_F9E2E81922B0C181D05B96DAE5AB0ACE6B06@qq.com>
To:     Rong Tao <rtoax@foxmail.com>
Cc:     ast@kernel.org, rongtao@cestc.cn, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 22 Nov 2022 10:32:56 +0800 you wrote:
> From: Rong Tao <rongtao@cestc.cn>
> 
> prefix_key->data allocates three bytes using alloca(), but four bytes are
> accessed in the program.
> 
> Signed-off-by: Rong Tao <rongtao@cestc.cn>
> 
> [...]

Here is the summary with links:
  - [bpf-next] samples/bpf: xdp_router_ipv4_user: Fix write overflow
    https://git.kernel.org/bpf/bpf-next/c/19a2bdbaaddc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


