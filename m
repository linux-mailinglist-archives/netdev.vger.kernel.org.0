Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB674C7009
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 15:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbiB1Ouu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 09:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiB1Out (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 09:50:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419EB70CD8;
        Mon, 28 Feb 2022 06:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D215260E73;
        Mon, 28 Feb 2022 14:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C771C340F0;
        Mon, 28 Feb 2022 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646059810;
        bh=cFBfY/fLFmtTsDUlYBq68VyDF1uktnmTFCrJLrn4gJw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o4G+z6MmA4tZaYlB49EP2bH8WT+1aVTVN8TBSM7x9XPyli9ICKyza5G8ThenEBZLN
         /WfevvlvWRrq2ZotIXmK90UsB7bzB/8idAO2/pOsZUbF5QNuiRvvPWocYHB4m7uU3K
         hL3nOoNpY2GdzX4DAUvdc5st35VpyJAuTu2hflTD65x84/ecolfV9iwQEb/8QPSAzH
         3R7bPXaxvJCcd4QLM0zUyhIJMoofvSbDis7PHvEb4xs+oYVQ/jkQX7p6lGBRfGpBPT
         o3QoTqq4nrafgiIYZ6T8osl012WI16tqq4eRNJtpP1tDkEgjc89KuJgZUUZm5baVhM
         tR9hF+3531Umg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B842E5D087;
        Mon, 28 Feb 2022 14:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2] xsk: fix race at socket teardown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164605981010.28346.16023482692929405783.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 14:50:10 +0000
References: <20220228094552.10134-1-magnus.karlsson@gmail.com>
In-Reply-To: <20220228094552.10134-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, elza.mathew@intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon, 28 Feb 2022 10:45:52 +0100 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a race in the xsk socket teardown code that can lead to a null
> pointer dereference splat. The current xsk unbind code in
> xsk_unbind_dev() starts by setting xs->state to XSK_UNBOUND, sets
> xs->dev to NULL and then waits for any NAPI processing to terminate
> using synchronize_net(). After that, the release code starts to tear
> down the socket state and free allocated memory.
> 
> [...]

Here is the summary with links:
  - [bpf,v2] xsk: fix race at socket teardown
    https://git.kernel.org/bpf/bpf/c/18b1ab7aa76b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


