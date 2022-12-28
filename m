Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2417658685
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiL1TpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbiL1Too (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:44:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2222018B29;
        Wed, 28 Dec 2022 11:44:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAF48615FC;
        Wed, 28 Dec 2022 19:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19ED9C433F1;
        Wed, 28 Dec 2022 19:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256651;
        bh=pKEmLVzCCnoF36/wLQbSAGOm4oNLhFE2rrntvg0ty04=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M033N6tKhdhqCernrFuq6Py4Z/KhyyAt6tGUUny1qWLXzPJW9wjgSO7qcWMCExi5C
         4ooktyfhNoDIPzlvOkO5RSiWqJY0Cm5yF1LJx4DskRR5c9v/d1uw/dtnWtmHGEaKdT
         H6ZKmAwTRIl8aLH2Fyt4zeUqKYbf3gLSx8BuGNfMCSUDKn8JXNL9gZfOvcES2KAo+5
         050GUcIQmpiB77sduxI0z1U4bTlcTbvexfErJxflv0yxaVgRYLGfJwNKBSRNKm1dzB
         EY7GHg1UhfSx9rffFwYx++hw0fDPp6zMQdUnM4Eji8hOdUfL+QPJiItkQkpIWAlFmM
         FK/bBk0mK2LcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02CBEE50D71;
        Wed, 28 Dec 2022 19:44:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 6.1 0307/1146] net,
 proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167225665100.25140.12972215493523003630.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Dec 2022 19:44:11 +0000
References: <20221228144338.493695497@linuxfoundation.org>
In-Reply-To: <20221228144338.493695497@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev, lkp@intel.com,
        dhowells@redhat.com, marc.dionne@auristor.com,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        sashal@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Arnaldo Carvalho de Melo <acme@redhat.com>:

On Wed, 28 Dec 2022 15:30:46 +0100 you wrote:
> From: David Howells <dhowells@redhat.com>
> 
> [ Upstream commit c3d96f690a790074b508fe183a41e36a00cd7ddd ]
> 
> Provide a CONFIG_PROC_FS=n fallback for proc_create_net_single_write().
> 
> Also provide a fallback for proc_create_net_data_write().
> 
> [...]

Here is the summary with links:
  - [6.1,0307/1146] net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
    (no matching commit)
  - [6.1,0770/1146] perf trace: Return error if a system call doesnt exist
    https://git.kernel.org/bpf/bpf/c/d4223e1776c3
  - [6.1,0771/1146] perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number
    https://git.kernel.org/bpf/bpf/c/eadcab4c7a66
  - [6.1,0772/1146] perf trace: Handle failure when trace point folder is missed
    https://git.kernel.org/bpf/bpf/c/03e9a5d8eb55
  - [6.1,0786/1146] perf off_cpu: Fix a typo in BTF tracepoint name, it should be btf_trace_sched_switch
    https://git.kernel.org/bpf/bpf/c/167b266bf66c
  - [6.1,0975/1146] bnx2: Use kmalloc_size_roundup() to match ksize() usage
    (no matching commit)
  - [6.1,0994/1146] igb: Do not free q_vector unless new one was allocated
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


