Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5F94D87C3
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 16:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242421AbiCNPLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 11:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242424AbiCNPLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:11:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3B643AFC
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 08:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCDE76125C
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 15:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2BFD5C340EE;
        Mon, 14 Mar 2022 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647270611;
        bh=rQA+oc2Vrkix8oP4erur2vd9l3HbpEzz21P3tkPqBRk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ErWzzWslyIpewg4o/d8z14KSY3l/wDSxxQJSk6LYhJbriPbzHjxrXNboJ10WZm1m4
         L81dfQHtnEpagdhqbeAllMHKCYghAO/jef0ZOKkI9apBmnhHQt78Z4M+BQ+F0u+gx8
         n5t/cQtWi7EtBaWGAWvlRX3zkhg/N21VbHCajEXHDP2wvUwmHOXdIkBhanRGORtNGY
         F8C3gSJd0wntkXWcrAnLp0f8JLfxXh/3Jj82WCmzk3HhxMdsnV/9TJHFdMfLe/6Cax
         YK/dMdFM5YpIul3ceGbgFxUhMLcaCdvQsypHVXyf2qVqZhFkMNyIpzzciXosB3DhPb
         cQNauyzHP63TA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0265CE73C67;
        Mon, 14 Mar 2022 15:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 0/4] vdpa tool enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164727061099.9987.2509911294556710415.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 15:10:10 +0000
References: <20220313171219.305089-1-elic@nvidia.com>
In-Reply-To: <20220313171219.305089-1-elic@nvidia.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     dsahern@kernel.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        jasowang@redhat.com, si-wei.liu@oracle.com, mst@redhat.com,
        lulu@redhat.com, parav@nvidia.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Sun, 13 Mar 2022 19:12:15 +0200 you wrote:
> Hi,
> 
> The following four patch series enhances vdpa to show negotiated
> features for a vdpa device, max features for a management device and
> allows to configure max number of virtqueue pairs.
> 
> v6->v7:
> Fix minor checkpatch warning
> 
> [...]

Here is the summary with links:
  - [v7,1/4] vdpa: Remove unsupported command line option
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=2d1954c8a54b
  - [v7,2/4] vdpa: Allow for printing negotiated features of a device
    (no matching commit)
  - [v7,3/4] vdpa: Support for configuring max VQ pairs for a device
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=16482fd4df11
  - [v7,4/4] vdpa: Support reading device features
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=56eb8bf45aa3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


