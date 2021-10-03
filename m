Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4944201C0
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 15:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhJCNl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 09:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230050AbhJCNly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 09:41:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5CD9B61A08;
        Sun,  3 Oct 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633268407;
        bh=HzdD3wwnI/fJV4p7hPcSMxvxjTul+mK8Pe4ojCeWV0g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K4HHhWMTBLy1IwKqI+9GBjCFu4Dkp9VnWjwsX0U1dx3kpsuHmulmxJ/Por3I0Xmsg
         b2kefguLG/wzn5ABvc5GZdWdqDIPiUqaA1yBxGsL90/EttQPDvZUq8jWsTnNstlF7q
         zFursDvB8syNKg54TFDBZ188c6EqmDkYvSGgRQ0T1yrtRF2JyQ3CtBJfqmMs7q3Irz
         kYrMSTTl+UJ1ze2mdlAJRgipbHLosTJ12MtTWuPW1vkvt5CK85S+lAnFsZfA6wvHKA
         MCeJOz8Yy/NMN0ZxWRJQLm5es/v1mAtlRl31xeqZDo7eDmkDYmePY2UJS7QPw5QAz5
         F2lKKfMAAOYtg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 470C2609D8;
        Sun,  3 Oct 2021 13:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] MCTP kunit tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163326840728.4764.11628970855041046796.git-patchwork-notify@kernel.org>
Date:   Sun, 03 Oct 2021 13:40:07 +0000
References: <20211003031708.132096-1-jk@codeconstruct.com.au>
In-Reply-To: <20211003031708.132096-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, brendanhiggins@google.com,
        linux-kselftest@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun,  3 Oct 2021 11:17:03 +0800 you wrote:
> This change adds some initial kunit tests for the MCTP core. We'll
> expand the coverage in a future series, and augment with a few
> selftests, but this establishes a baseline set of tests for now.
> 
> Thanks to the kunit folks for the framework!
> 
> Cheers,
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] mctp: Add initial test structure and fragmentation test
    https://git.kernel.org/netdev/net-next/c/161eba50e183
  - [net-next,v2,2/5] mctp: Add test utils
    https://git.kernel.org/netdev/net-next/c/ded21b722995
  - [net-next,v2,3/5] mctp: Add packet rx tests
    https://git.kernel.org/netdev/net-next/c/b504db408c34
  - [net-next,v2,4/5] mctp: Add route input to socket tests
    https://git.kernel.org/netdev/net-next/c/8892c0490779
  - [net-next,v2,5/5] mctp: Add input reassembly tests
    https://git.kernel.org/netdev/net-next/c/1e5e9250d422

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


