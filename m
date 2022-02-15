Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2004B75A6
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240214AbiBOSKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 13:10:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241373AbiBOSKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 13:10:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A40119438;
        Tue, 15 Feb 2022 10:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B44C616AC;
        Tue, 15 Feb 2022 18:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8584C340F3;
        Tue, 15 Feb 2022 18:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644948609;
        bh=ewM3iYU7kAoN6H2M/VR/gYey9U7fk0al4AKoyGcPurI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DuVYWi9SfCC7dym1ql/qK/Z0/Io4vnCGXRnja2tQtSHjggB6PeE/aIuam/k8RsGi1
         Mdk6bt9EH9u4LbcCKouZAMCy3xs8AGQpX/xKkAZJcQFb74IpwIYcqmJD+rVLPp7ePl
         jXg7LYLyz4532ByBiPOAy4hWcXW6uwdgt07C0JY6Gg+dnMJD9FmRJbU9HHEvkVd81H
         Nuk0YcAZFk8JQ4WyJcAemyOfgUUjPPz+cWyWNu6wLIQZsZmieT6vmMZJl4Ys9wuDK5
         1GIB4wDAS3x3q2CFqtWzd/ZkoF4hbiKQa+luqFlkMEdLofzI/WumzsULLXIRVjNWQ1
         3OROsKgayTiRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1201E6BBD2;
        Tue, 15 Feb 2022 18:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v4] bpf: reject kfunc calls that overflow insn->imm
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164494860978.24331.14438587212301214226.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 18:10:09 +0000
References: <20220215065732.3179408-1-houtao1@huawei.com>
In-Reply-To: <20220215065732.3179408-1-houtao1@huawei.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     ast@kernel.org, yhs@fb.com, daniel@iogearbox.net, kafai@fb.com,
        andrii@kernel.org, songliubraving@fb.com, kpsingh@kernel.org,
        davem@davemloft.net, kuba@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Alexei Starovoitov <ast@kernel.org>:

On Tue, 15 Feb 2022 14:57:32 +0800 you wrote:
> Now kfunc call uses s32 to represent the offset between the address of
> kfunc and __bpf_call_base, but it doesn't check whether or not s32 will
> be overflowed. The overflow is possible when kfunc is in module and the
> offset between module and kernel is greater than 2GB. Take arm64 as an
> example, before commit b2eed9b58811 ("arm64/kernel: kaslr: reduce module
> randomization range to 2 GB"), the offset between module symbol and
> __bpf_call_base will in 4GB range due to KASLR and may overflow s32.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v4] bpf: reject kfunc calls that overflow insn->imm
    https://git.kernel.org/bpf/bpf-next/c/8cbf062a250e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


