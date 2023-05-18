Return-Path: <netdev+bounces-3498-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EC06707930
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:41:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1017D1C2104F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 04:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9EA20F2;
	Thu, 18 May 2023 04:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CA3644
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B69CC433A1;
	Thu, 18 May 2023 04:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684384821;
	bh=HNtcMb/VfDLe0ACDuAu/cHjFBh8SkcwKlm9Fd23w66I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=cMyQazfftNg5F0J0DSWMUpO3iaY243//rKMHlcFDx65bR1yFZzRrwbESmIL7R5IqM
	 GLi8erXnsyJhlFDmBhMw90kVgmIsO3IKZHQItDVdW5pZfl+lHas1hr/0PgyzjAj2QO
	 6tiEnKCv0YhHOv7HhCAf2UwJgSDPUbDgdqrOKq0XzQfavKy1bjfQxG5Raj9mW6T+z4
	 CcVo2pYSnprpR3nmTedVLgzUrc0iwp9/p+YXpG9WiuMcy0j92V4U2nHQU9v6OGvVki
	 e1CHhoQfmkqXt2/p5Gwdg5BlNKAeeKVu6Gthstx/+TFkXuTyJ7xAOzyOdBJcjYFqVD
	 O0BOd/KxvAAPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 87E41C32795;
	Thu, 18 May 2023 04:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: libwx: Replace zero-length array with
 flexible-array member
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168438482154.9978.14767472960947160118.git-patchwork-notify@kernel.org>
Date: Thu, 18 May 2023 04:40:21 +0000
References: <ZGKGwtsobVZecWa4@work>
In-Reply-To: <ZGKGwtsobVZecWa4@work>
To: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: jiawenwu@trustnetic.com, mengyuanlou@net-swift.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 May 2023 13:23:46 -0600 you wrote:
> Zero-length arrays as fake flexible arrays are deprecated, and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Transform zero-length array into flexible-array member in struct
> wx_q_vector.
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/286
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> [...]

Here is the summary with links:
  - [next] net: libwx: Replace zero-length array with flexible-array member
    https://git.kernel.org/netdev/net-next/c/fe6559fab328

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



