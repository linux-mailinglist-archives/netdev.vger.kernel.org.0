Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBF549D0B8
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 18:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243721AbiAZRaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 12:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242785AbiAZRaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 12:30:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEE7C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 09:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92CF561B29
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED5C5C340E8;
        Wed, 26 Jan 2022 17:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643218213;
        bh=puixU33cvR+IGHSi+tkyXO/jXHJChCjwZ/WDBWvSvWA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aIatp7KMOM+rHum8yXRv0IGN1O5M4WxjezmtJtLNyoLMBO4UAD3kkMHxiOyI2tocY
         77qdKfFyORnRhLqQPj1AJtItIWQmlIbUo48BhoAcGDnyudpqSAgUDPx4hcq20G3+yl
         HSCgfcIHnWDnlTRBfnsvVl4j4e3yXiWnBrieOJ4NgmTTwb0NJvRJUJKtmE1rfUwFhW
         rCK3APRSDUte7qwH5SPV29VuDlLRd+1XdCT/omwxg24dZH47FOwRUZvi+dyOSTahb/
         bwJ94JsUUq/TotJZouRLdkg2Wjp4W7rAryCMWjdAVKG1wGuIsyMIuh8dhhe8/pKVhB
         zDskzxIGaWNkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA39EF607B4;
        Wed, 26 Jan 2022 17:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 iproute2-next 00/11] fix clang warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164321821288.31441.13571616190879839110.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Jan 2022 17:30:12 +0000
References: <20220120211153.189476-1-stephen@networkplumber.org>
In-Reply-To: <20220120211153.189476-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu, 20 Jan 2022 13:11:42 -0800 you wrote:
> This patch set makes iproute2-next main branch compile without warnings
> on Clang 11 (and probably later versions).
> 
> v4
>   - fix indentation in masked_type with newline (ct action)
> 
> Stephen Hemminger (11):
>   tc: add format attribute to tc_print_rate
>   utils: add format attribute
>   netem: fix clang warnings
>   flower: fix clang warnings
>   tc_util: fix clang warning in print_masked_type
>   ipl2tp: fix clang warning
>   can: fix clang warning
>   tipc: fix clang warning about empty format string
>   tunnel: fix clang warning
>   libbpf: fix clang warning about format non-literal
>   json_print: suppress clang format warning
> 
> [...]

Here is the summary with links:
  - [v4,iproute2-next,01/11] tc: add format attribute to tc_print_rate
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=343c4f52b698
  - [v4,iproute2-next,02/11] utils: add format attribute
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=9d5e29e60f54
  - [v4,iproute2-next,03/11] netem: fix clang warnings
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=4e27d5389560
  - [v4,iproute2-next,04/11] flower: fix clang warnings
    (no matching commit)
  - [v4,iproute2-next,05/11] tc_util: fix clang warning in print_masked_type
    (no matching commit)
  - [v4,iproute2-next,06/11] ipl2tp: fix clang warning
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=8d27eee50cd9
  - [v4,iproute2-next,07/11] can: fix clang warning
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=371c13e8f22f
  - [v4,iproute2-next,08/11] tipc: fix clang warning about empty format string
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=c02488786f6d
  - [v4,iproute2-next,09/11] tunnel: fix clang warning
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=5632cf69ad59
  - [v4,iproute2-next,10/11] libbpf: fix clang warning about format non-literal
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=bf71c8f214b7
  - [v4,iproute2-next,11/11] json_print: suppress clang format warning
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=ba5ac984eb00

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


