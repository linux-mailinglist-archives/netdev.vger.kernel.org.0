Return-Path: <netdev+bounces-3499-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B906A707931
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB77F1C20F30
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 04:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B927631;
	Thu, 18 May 2023 04:40:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E476649
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA026C433AE;
	Thu, 18 May 2023 04:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684384821;
	bh=yfnXiSe2KXaaG9RnHeM4DlMW9YaXUTs+zIC2OR+JZrY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XmMo0p6nkkOwHJ2lLFykMGlj67FErOJBYCoCHfR62qLZofoTmk1QJfS41YzrDVJWq
	 lRmmB9Gzkm+eDikx0fOWN/g3+EvbZ7OZqTpsG/OEQqur1otXSiQR1NwbKjw9rquwtu
	 ZvJxB5p6ijgNxA3KewgNS5XqDtHttgTyIzrv1s9FhUIBjrZo1TK034h0KflyrUWujN
	 qgrj+fgDSiVWVEV/NtX79MwThRCX0es7R62c8gtaWz3QLGdlSUySaCgLYKPXWXkdxk
	 swX9h2vrDdGVIfBjyFRwJvVkAav5+293yG5XJb7vBKhWE0tYnRwdbgBkAFpxZft6Og
	 BT+20bBpHzDyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 944BBE49FA3;
	Thu, 18 May 2023 04:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] mlxfw: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168438482160.9978.15626489948914257775.git-patchwork-notify@kernel.org>
Date: Thu, 18 May 2023 04:40:21 +0000
References: <ZGKGiBxP0zHo6XSK@work>
In-Reply-To: <ZGKGiBxP0zHo6XSK@work>
To: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, mlxsw@nvidia.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 May 2023 13:22:48 -0600 you wrote:
> Zero-length arrays are deprecated and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations alone in structs with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members alone in structs.
> 
> [...]

Here is the summary with links:
  - [next] mlxfw: Replace zero-length array with DECLARE_FLEX_ARRAY() helper
    https://git.kernel.org/netdev/net-next/c/b1cf7a561515

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



