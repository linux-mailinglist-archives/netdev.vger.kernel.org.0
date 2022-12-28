Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C8C658688
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiL1TpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiL1Top (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:44:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF5718B3B;
        Wed, 28 Dec 2022 11:44:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C4439CE13C1;
        Wed, 28 Dec 2022 19:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F858C433EF;
        Wed, 28 Dec 2022 19:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256651;
        bh=uR4VTyFK2HvRi8TALBY5DIOgFZEekzmTRxQzdLe6Ic4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ShlDtWQXQDiYkP3R9/2Wvc0TZW1XfrUOcfOwSjRGAOqp4AbTDrEp94bDFQLrn5lI8
         7IdkXTlXwDC+Dc19Bzbn20nYQnZQjSQ4oTVMeWNebKdbD6i6cVH7V6h7HIrn7A/225
         J3CvjZ9An+gET/j1Xkd3fQpl7YMv6ITgRpgCmbR9AeH1Sp4iUZ6sF0HUcuvMCkYmkV
         I6b44JCPzH8sZ16yr9I5RPZAaPufdIueQDjxA8EAvcS5XbYaHnNT75X1HYfJvkDowJ
         YfZWnauBFXwazEioDBDAHee4agvssfFyvaJ23DdvWTS+QC0vXTuApljMdFC+u2iC21
         aylEnTM91oIMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6AD8C395DF;
        Wed, 28 Dec 2022 19:44:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 5.15 190/731] net,
 proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167225665094.25140.3531406552486869119.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Dec 2022 19:44:10 +0000
References: <20221228144302.066590087@linuxfoundation.org>
In-Reply-To: <20221228144302.066590087@linuxfoundation.org>
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

On Wed, 28 Dec 2022 15:34:57 +0100 you wrote:
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
  - [5.15,190/731] net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
    (no matching commit)
  - [5.15,514/731] perf trace: Return error if a system call doesnt exist
    https://git.kernel.org/bpf/bpf/c/d4223e1776c3
  - [5.15,515/731] perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number
    https://git.kernel.org/bpf/bpf/c/eadcab4c7a66
  - [5.15,516/731] perf trace: Handle failure when trace point folder is missed
    https://git.kernel.org/bpf/bpf/c/03e9a5d8eb55
  - [5.15,643/731] igb: Do not free q_vector unless new one was allocated
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


