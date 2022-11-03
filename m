Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14267617D10
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 13:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbiKCMuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 08:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiKCMuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 08:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B614412D22;
        Thu,  3 Nov 2022 05:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7002EB8278D;
        Thu,  3 Nov 2022 12:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FDBDC433C1;
        Thu,  3 Nov 2022 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667479816;
        bh=Snn9bV7c9Qjo3JPyNTtm3u3v/lXz9obJRsQIEAuc4Ro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rUHOKeTOmtUvN1o0I+fVxhDScY28iVlL9rM5on4+n+wW3uJZZYlFwT6Jhz3sgG6AV
         lQQniAeZM4i94E6d49JZ8K+tvlwmVcRYJ82jF+0mxfHwgOAmrLbPArV9iiTI/0EHMj
         N+bkfpwuq/5JAvVHU1XMEoeQEWRzWtgf1DXFyt8ab8BoAG3puVSyKkWBCc2D9eW+P9
         Q4960Ikj+oh4GtVovnLxeRTltJGkZEu+vSgx9x5GDW+20Idwt2Z/0XcAf/2Jk/4WZY
         0Q4b1T0DF6p/F+KZbMwEEI2CYj6wKmI63XEllGv9lc/MXwSjSunG0M5MQWG/j/Mxu3
         ieSMNhhOajutQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE720E29F4C;
        Thu,  3 Nov 2022 12:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf 1/2] net/ipv4: fix linux/in.h header dependencies
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166747981590.20434.6205202822354530507.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 12:50:15 +0000
References: <20221102182517.2675301-1-andrii@kernel.org>
In-Reply-To: <20221102182517.2675301-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, kuba@kernel.org, kernel-team@fb.com,
        gustavoars@kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 2 Nov 2022 11:25:16 -0700 you wrote:
> __DECLARE_FLEX_ARRAY is defined in include/uapi/linux/stddef.h but
> doesn't seem to be explicitly included from include/uapi/linux/in.h,
> which breaks BPF selftests builds (once we sync linux/stddef.h into
> tools/include directory in the next patch). Fix this by explicitly
> including linux/stddef.h.
> 
> Given this affects BPF CI and bpf tree, targeting this for bpf tree.
> 
> [...]

Here is the summary with links:
  - [bpf,1/2] net/ipv4: fix linux/in.h header dependencies
    https://git.kernel.org/bpf/bpf/c/aec1dc972d27
  - [bpf,2/2] tools headers uapi: pull in stddef.h to fix BPF selftests build in CI
    https://git.kernel.org/bpf/bpf/c/a778f5d46b62

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


