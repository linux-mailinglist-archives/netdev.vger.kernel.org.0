Return-Path: <netdev+bounces-5503-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99348711EA8
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C5941C20F41
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 04:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B80F211C;
	Fri, 26 May 2023 04:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464061FCF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9271C433D2;
	Fri, 26 May 2023 04:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685074221;
	bh=xYciJK0XH6WeIXR+hAsecrYVD00FM0Xh2cH8BkJ6uv8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=OZTiO2XE2yatVbp0xMfbgWD83ACkp67TkrHHfxs1ilr0MH25bgxrV22lOD+wVB3pf
	 GQvlOfOi90k0rrNfoOz+KNo/TZjMyCIvaV5XCMSSj7hBNx15iIZxLRgqjxstF2SJve
	 o6nhACHVDfOg4dtM4yl6VIBlIMygOZhq0I/OyEvj37isNp/rwx67awjdPD1ZySuFB2
	 C0vhcNQHNcYi0ZmAH+JjMlr3qGrJEe9AaYmopOu5bt/8Bl344ZFcRczpl+emZAb7X1
	 iLfIbGbxmrZAVQoGRnb4UY32/TpCQsqAqRj2Ehf+5wUQNUGuhlJc9MuduyFIpUMjLW
	 mvyoeC/wpkOGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9066E4D023;
	Fri, 26 May 2023 04:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tools: ynl: avoid dict errors on older Python versions
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168507422081.22221.8469445383581897857.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 04:10:20 +0000
References: <20230524170712.2036128-1-kuba@kernel.org>
In-Reply-To: <20230524170712.2036128-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, donald.hunter@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 May 2023 10:07:12 -0700 you wrote:
> Python 3.9.0 or newer supports combining dicts() with |,
> but older versions of Python are still used in the wild
> (e.g. on CentOS 8, which goes EoL May 31, 2024).
> With Python 3.6.8 we get:
> 
>   TypeError: unsupported operand type(s) for |: 'dict' and 'dict'
> 
> [...]

Here is the summary with links:
  - [net] tools: ynl: avoid dict errors on older Python versions
    https://git.kernel.org/netdev/net/c/081e8df68199

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



