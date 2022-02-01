Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E2E4A55B0
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 04:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbiBADuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 22:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiBADuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 22:50:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D59BC061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 19:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C69A9B82CA3
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 03:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95D77C340EE;
        Tue,  1 Feb 2022 03:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643687410;
        bh=cx8esFmTJ370Cy1ElviyUgoTQT+FF8ZQEf8fNv7SdJM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qm8G810Cxvmny8PYqGnBz08lpDjvdb9PokvPKqIl+3cqUPOcFqwHvM3OY2/PgTkPh
         SVOSoCBn8g9j6sINL4j5B42B6D01tcgs4LcfyUmdMPVcF3ewr6MB/5B+1d09RkV1mh
         /LoqDDC0RXkmfiAPUokb7cjp8AM1CK1DfevCWLHeyrXPKA7LoiQZ5CsXkzldIOg4tV
         9zc0gid/57Xs6vZckMJz2k3o/pg9QvFSbD9No1mOrk1hQgloboc6h9PSMeIFEK1HdW
         4rW2RhKJ+8hXdFsig6KB4JwFI0JwT0tUTQ80NJHOqpd0JFA1ksYWgrc1IiEE0arU9o
         POYqDelweVIxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7EAE1E5D08C;
        Tue,  1 Feb 2022 03:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164368741051.29164.7274079279797936323.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Feb 2022 03:50:10 +0000
References: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
In-Reply-To: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
To:     Baowen Zheng <baowen.zheng@corigine.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com, jhs@mojatatu.com, victor@mojatatu.com,
        simon.horman@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed, 26 Jan 2022 14:54:39 +0800 you wrote:
> Add skip_hw and skip_sw flags for user to control whether
> offload action to hardware.
> 
> Also we add hw_count to show how many hardwares accept to offload
> the action.
> 
> Change man page to describe the usage of skip_sw and skip_hw flag.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v2] tc: add skip_hw and skip_sw to control action offload
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=f4cd4f127047

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


