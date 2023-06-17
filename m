Return-Path: <netdev+bounces-11697-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7358B733F1D
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 09:20:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 839EB1C21022
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 07:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5201D63D7;
	Sat, 17 Jun 2023 07:20:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176E163B3
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 07:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 855ADC433C0;
	Sat, 17 Jun 2023 07:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686986422;
	bh=axbxhwfcqMSCE380nBysXx5dBfYZA9l7izhNqwViekU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=jDgyB3FQRRuL496+2C+VBRByI0olseAjGt40HSYGpaxM9VaFWY5wJo2RmYNE0I3aU
	 AvkaxaBZZnfMRhoCkKSglfCj3XeApenBBKRCT9+3pmaue/F37OvnOyvyYELhMQj5VM
	 xR1vYOEjkhoW8ezVNqqtRTO893szHbx53tavkM3NzxfrEhYzS9tKl37J5thrSNN+Gl
	 jj5zwvmw9LDIYbMHC6rfrJ16eQI1I/+GgF70XTZh65jZOQa1+GFuanZ6caBzgiok5c
	 MKdr0HSJIC33/k3HemKdI3Tvi99ZeSVpfvUJKDZx/8/V7yKOkzbNgAeeJxI7s3IKjY
	 Mw8o2uR4GuhzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64FD9C395E0;
	Sat, 17 Jun 2023 07:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] kcm: Fix unnecessary psock unreservation.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168698642240.16794.4653349244571397318.git-patchwork-notify@kernel.org>
Date: Sat, 17 Jun 2023 07:20:22 +0000
References: <20787.1686828722@warthog.procyon.org.uk>
In-Reply-To: <20787.1686828722@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org,
 syzbot+dd1339599f1840e4cc65@syzkaller.appspotmail.com, tom@herbertland.com,
 tom@quantonium.net, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, axboe@kernel.dk, willy@infradead.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Jun 2023 12:32:02 +0100 you wrote:
> kcm_write_msgs() calls unreserve_psock() to release its hold on the
> underlying TCP socket if it has run out of things to transmit, but if we
> have nothing in the write queue on entry (e.g. because someone did a
> zero-length sendmsg), we don't actually go into the transmission loop and
> as a consequence don't call reserve_psock().
> 
> Fix this by skipping the call to unreserve_psock() if we didn't reserve a
> psock.
> 
> [...]

Here is the summary with links:
  - [net-next] kcm: Fix unnecessary psock unreservation.
    https://git.kernel.org/netdev/net-next/c/9f8d0dc0ec4a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



