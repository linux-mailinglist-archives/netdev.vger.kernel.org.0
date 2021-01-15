Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F001F2F6F81
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 01:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731294AbhAOAax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 19:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731247AbhAOAaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 19:30:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 60CAE23AA7;
        Fri, 15 Jan 2021 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610670612;
        bh=mPkJVAlpmgDKHqCx8k5Y+tKNO9Tb78FE+mwbfsuY8zI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qzeFAkpI563a6x9768lgvgYnxLohBuuuxwN5w1eq8xxfn8l6fWLvUyntGbNWBBJiZ
         LOyjC/CSSHO2yhh0J/HOcT390ffItlRM1QG+m90vXUFMeBnpSQPFnivU8C+i5VU0Op
         3Lv7dREP+l/AIGP56+LNdwVNHSSkXhiixcm6uvl1ueuZmYv9Qvd9DPcAGsA4ETKYZM
         ytCswqHyCNAujq96bJaWbM0+fDlDzujDurMkGuxojbrvkdBYUwgQe/FSLu++Kl4RFL
         fNFPon/YiW1eZqY3PewC0qXy6ZdP7YsXYF90lGCWy+KEcAr4QJCfK+eQKiiyzZ6Akh
         qrgUogM7H+1ZA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 5422760593;
        Fri, 15 Jan 2021 00:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 00/13] selftests: Updates to allow single instance
 of nettest for client and server
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161067061233.29721.1836797813772844498.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jan 2021 00:30:12 +0000
References: <20210114030949.54425-1-dsahern@kernel.org>
In-Reply-To: <20210114030949.54425-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        schoen@loyalty.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 13 Jan 2021 20:09:36 -0700 you wrote:
> Update nettest to handle namespace change internally to allow a
> single instance to run both client and server modes. Device validation
> needs to be moved after the namespace change and a few run time
> options need to be split to allow values for client and server.
> 
> v4
> - really fix the memory leak with stdout/stderr buffers
> 
> [...]

Here is the summary with links:
  - [net-next,v4,01/13] selftests: Move device validation in nettest
    https://git.kernel.org/netdev/net-next/c/3a70a6451551
  - [net-next,v4,02/13] selftests: Move convert_addr up in nettest
    https://git.kernel.org/netdev/net-next/c/6fc90e18994c
  - [net-next,v4,03/13] selftests: Move address validation in nettest
    https://git.kernel.org/netdev/net-next/c/f2f575840a59
  - [net-next,v4,04/13] selftests: Add options to set network namespace to nettest
    https://git.kernel.org/netdev/net-next/c/092e0ceb12f2
  - [net-next,v4,05/13] selftests: Add support to nettest to run both client and server
    https://git.kernel.org/netdev/net-next/c/6469403c97b4
  - [net-next,v4,06/13] selftests: Use separate stdout and stderr buffers in nettest
    https://git.kernel.org/netdev/net-next/c/f222c37cf75a
  - [net-next,v4,07/13] selftests: Add missing newline in nettest error messages
    https://git.kernel.org/netdev/net-next/c/db9993359e58
  - [net-next,v4,08/13] selftests: Make address validation apply only to client mode
    https://git.kernel.org/netdev/net-next/c/9a8d584964fc
  - [net-next,v4,09/13] selftests: Consistently specify address for MD5 protection
    https://git.kernel.org/netdev/net-next/c/a824e261d7cd
  - [net-next,v4,10/13] selftests: Add new option for client-side passwords
    https://git.kernel.org/netdev/net-next/c/d3857b8f0d19
  - [net-next,v4,11/13] selftests: Add separate options for server device bindings
    https://git.kernel.org/netdev/net-next/c/8a909735fa29
  - [net-next,v4,12/13] selftests: Remove exraneous newline in nettest
    https://git.kernel.org/netdev/net-next/c/f26a008c4512
  - [net-next,v4,13/13] selftests: Add separate option to nettest for address binding
    https://git.kernel.org/netdev/net-next/c/5265a0142f57

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


