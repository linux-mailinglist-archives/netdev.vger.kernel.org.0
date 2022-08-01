Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E86587133
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiHATNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiHATMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:12:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBB3E3C
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 12:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19578612CF
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 19:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 701F4C433D7;
        Mon,  1 Aug 2022 19:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659381014;
        bh=wYsfcBTViFHNdbDd5/3U7g9tLpQVB2tnA0cYqEMoSrw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q+fO7FF6TGt78fi00+7g98EX/aATFh6o3HF0wmJO1vRW6ul3t5Le8KMksQ4/48bEm
         e1pS6UTwpWso5xnCeDfiR6f74ktJcCcKoIf6hl/a57itJAbWmxqFfCsOMFI698vdZ6
         ZPRvVPyA7dP+SjFtN1Yi0IZrz1nWyTt0p1ffsqOwULHVv6YuAbQmzeVBY45Bqu+ZZg
         5nayqBzV/WJOv4MGHdBgvcqXNFgH28/0+YTsJY4QVMG5LjOO5dkMLG3DSJlwB7mS+x
         py5haB700xnJF89XV+8oZpPGOKkt+AxLYdi08ByfZbG8lCHRqiH2EylwLr3fPVWxxr
         yKM0LqXKxmbMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50DA8C43144;
        Mon,  1 Aug 2022 19:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: add support for tunnel offload without
 key ID
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165938101432.19579.147851129760704489.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 19:10:14 +0000
References: <20220729091641.354748-1-simon.horman@corigine.com>
In-Reply-To: <20220729091641.354748-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 29 Jul 2022 11:16:41 +0200 you wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Currently nfp driver will reject to offload tunnel key action without
> tunnel key ID which means tunnel ID is 0. But it is a normal case for tc
> flower since user can setup a tunnel with tunnel ID is 0.
> 
> So we need to support this case to accept tunnel key action without
> tunnel key ID.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: add support for tunnel offload without key ID
    https://git.kernel.org/netdev/net-next/c/45490ce2ff83

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


