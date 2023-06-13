Return-Path: <netdev+bounces-10269-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B34E72D54D
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 02:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5F4E1C20BFC
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 00:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 406AD5CBB;
	Tue, 13 Jun 2023 00:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937B34402;
	Tue, 13 Jun 2023 00:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 163F1C4339B;
	Tue, 13 Jun 2023 00:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686614424;
	bh=ejP2zOU7tKEEXBd532d7YQRPeaxHw7CzRYHpB1izQJ4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=nmcYwxruMeSny0UTLfqbrvXR+UhnWDhCeoaMMy0oOt29NVueMD6CWC+vYalTwiYlf
	 LvdGmAheoyR4fzkjl7lsSgvT57EN2XG5gGZ+qw1oQzHU9D0CIWfMY3j/uSYNLPjI5L
	 QTEezCsSe8byoPifLF6vxtfoXcgf0EMU3NLaLQWHePyF2N/kXMGSdsthUIsFqyvlSY
	 QDwpT9AvzpkabnESYSfURroMw4v0Capv6JCxOQ2/tAAGU/818TDExsK+pSPxphpZb3
	 2V4h4v21U6qk5nRC4YxU20JmsTglh+8+4lpuGD8MSNZFoPeKoUNr4bqHkFRT3dwJee
	 ZjSwtq/6w+RaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E30E0E1CF31;
	Tue, 13 Jun 2023 00:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/17] selftests: mptcp: lib: skip if not below kernel
 version
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168661442392.10094.4616497599019441750.git-patchwork-notify@kernel.org>
Date: Tue, 13 Jun 2023 00:00:23 +0000
References: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-1-2896fe2ee8a3@tessares.net>
In-Reply-To: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-1-2896fe2ee8a3@tessares.net>
To: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: mptcp@lists.linux.dev, martineau@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
 fw@strlen.de, dcaratti@redhat.com, cpaasch@apple.com, geliangtang@gmail.com,
 geliang.tang@suse.com, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, stable@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 10 Jun 2023 18:11:36 +0200 you wrote:
> Selftests are supposed to run on any kernels, including the old ones not
> supporting all MPTCP features.
> 
> A new function is now available to easily detect if a feature is
> missing by looking at the kernel version. That's clearly not ideal and
> this kind of check should be avoided as soon as possible. But sometimes,
> there are no external sign that a "feature" is available or not:
> internal behaviours can change without modifying the uAPI and these
> selftests are verifying the internal behaviours. Sometimes, the only
> (easy) way to verify if the feature is present is to run the test but
> then the validation cannot determine if there is a failure with the
> feature or if the feature is missing. Then it looks better to check the
> kernel version instead of having tests that can never fail. In any case,
> we need a solution not to have a whole selftest being marked as failed
> just because one sub-test has failed.
> 
> [...]

Here is the summary with links:
  - [net,01/17] selftests: mptcp: lib: skip if not below kernel version
    https://git.kernel.org/netdev/net/c/b1a6a38ab8a6
  - [net,02/17] selftests: mptcp: join: use 'iptables-legacy' if available
    https://git.kernel.org/netdev/net/c/0c4cd3f86a40
  - [net,03/17] selftests: mptcp: join: helpers to skip tests
    https://git.kernel.org/netdev/net/c/cdb50525345c
  - [net,04/17] selftests: mptcp: join: skip check if MIB counter not supported
    (no matching commit)
  - [net,05/17] selftests: mptcp: join: skip test if iptables/tc cmds fail
    https://git.kernel.org/netdev/net/c/4a0b866a3f7d
  - [net,06/17] selftests: mptcp: join: support local endpoint being tracked or not
    https://git.kernel.org/netdev/net/c/d4c81bbb8600
  - [net,07/17] selftests: mptcp: join: skip Fastclose tests if not supported
    https://git.kernel.org/netdev/net/c/ae947bb2c253
  - [net,08/17] selftests: mptcp: join: support RM_ADDR for used endpoints or not
    https://git.kernel.org/netdev/net/c/425ba803124b
  - [net,09/17] selftests: mptcp: join: skip implicit tests if not supported
    https://git.kernel.org/netdev/net/c/36c4127ae8dd
  - [net,10/17] selftests: mptcp: join: skip backup if set flag on ID not supported
    https://git.kernel.org/netdev/net/c/07216a3c5d92
  - [net,11/17] selftests: mptcp: join: skip fullmesh flag tests if not supported
    https://git.kernel.org/netdev/net/c/9db34c4294af
  - [net,12/17] selftests: mptcp: join: skip userspace PM tests if not supported
    https://git.kernel.org/netdev/net/c/f2b492b04a16
  - [net,13/17] selftests: mptcp: join: skip fail tests if not supported
    https://git.kernel.org/netdev/net/c/ff8897b51894
  - [net,14/17] selftests: mptcp: join: skip MPC backups tests if not supported
    https://git.kernel.org/netdev/net/c/632978f0a961
  - [net,15/17] selftests: mptcp: join: skip PM listener tests if not supported
    https://git.kernel.org/netdev/net/c/0471bb479af0
  - [net,16/17] selftests: mptcp: join: uniform listener tests
    https://git.kernel.org/netdev/net/c/96b84195df61
  - [net,17/17] selftests: mptcp: join: skip mixed tests if not supported
    https://git.kernel.org/netdev/net/c/6673851be0fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



