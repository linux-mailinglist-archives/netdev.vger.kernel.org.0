Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A09B64638E
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 23:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiLGWAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 17:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiLGWAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 17:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C384083EB9;
        Wed,  7 Dec 2022 14:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 602DD61CBC;
        Wed,  7 Dec 2022 22:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB598C433D7;
        Wed,  7 Dec 2022 22:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670450417;
        bh=BsRygm0ybmvoinvYKy48eO0wJfAQLo7Cl0htYrVRgnA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sdUxTpJrCVgb19E7LlxVoEV8joEujFnrEFqbLzoLRNi22Yb3YA+PG/G9HaThr9QVB
         owR9mzPSb9jqgcO55U9cxsihWVj46zV+xnl08HpbBKddrIl5rL3XtMPh7u8zVA7zAl
         5gZVvPlEWsK8DA1dbKD7qdYvFLmkwasqvjYL7z9JJrLib7owRP5zWHm7V8A+lUmJae
         YXnDYogaL7CYnxw99NoFbHIbc/PosMGaBqsOy73RcSdFBrSb4c/WohVDVURJ1KHaf3
         3FRP428yQ/fR/B0OhSztI+4MllrVVAGOt/LSgVnZ5n0rbC6IbNFsQodNYxbZ53OZWO
         OB0+WJYJ5aq9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8C869E49BBD;
        Wed,  7 Dec 2022 22:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH HID for-next v3 0/5] HID: bpf: remove the need for
 ALLOW_ERROR_INJECTION and Kconfig fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167045041756.21470.5170020556924386049.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 22:00:17 +0000
References: <20221206145936.922196-1-benjamin.tissoires@redhat.com>
In-Reply-To: <20221206145936.922196-1-benjamin.tissoires@redhat.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     jikos@kernel.org, revest@chromium.org, jonathanh@nvidia.com,
        alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        andrii@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Benjamin Tissoires <benjamin.tissoires@redhat.com>:

On Tue,  6 Dec 2022 15:59:31 +0100 you wrote:
> Hi,
> 
> This is a new version of the ALLOW_ERROR_INJECTION hack removal.
> 
> Compared to v2, I followed the review from Alexei which cleaned up the
> code a little bit.
> 
> [...]

Here is the summary with links:
  - [HID,for-next,v3,1/5] bpf: do not rely on ALLOW_ERROR_INJECTION for fmod_ret
    https://git.kernel.org/bpf/bpf-next/c/5b481acab4ce
  - [HID,for-next,v3,2/5] HID: bpf: do not rely on ALLOW_ERROR_INJECTION
    (no matching commit)
  - [HID,for-next,v3,3/5] HID: bpf: enforce HID_BPF dependencies
    (no matching commit)
  - [HID,for-next,v3,4/5] selftests: hid: ensures we have the proper requirements in config
    (no matching commit)
  - [HID,for-next,v3,5/5] kselftests: hid: fix missing headers_install step
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


