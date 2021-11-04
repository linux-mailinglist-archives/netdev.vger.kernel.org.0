Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B06A445658
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 16:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhKDPcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 11:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229970AbhKDPcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 11:32:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C5AE7611C4;
        Thu,  4 Nov 2021 15:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636039807;
        bh=vjn1Lwm7oWdvDDcHq4GCLUqdhjQ7tGTX2vpcbSflNho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CvmVtSmqYzJN+zppDD76m9LfNJI7kh0ckolbJALV1Fyjk7DH3wkNz1OEDLffbw6wX
         e3W+bN6YHd1/33QuZMlY1SgLnB2yUCnbKGLAxmM7Q0E+Ue2dlNCUBIfekEVepeQA/D
         PzEFVwQwwQDhzULmZGGYqDKTaXd47ml5fhOqZheJFjWhBHYmB/cMnEUOSr/JB4bqR+
         zGVO6QAbBYeo91/QZXmbg4IUkjyjkVw84/lpFw7EpctceN7YJRCCsOXZl4llWQwoFo
         MOlNtC4sGAcdry6zmEzTXObg/Vi70KxyL+NZE0hXWKcdO+wJSEmoDqZU8+z4xHTDiz
         vB4u5Fzb54WHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA3AB609B8;
        Thu,  4 Nov 2021 15:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net: reuseport_bpf_numa: skip nodes not available
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163603980775.7046.17291736320593809022.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Nov 2021 15:30:07 +0000
References: <20211101145317.286118-1-kleber.souza@canonical.com>
In-Reply-To: <20211101145317.286118-1-kleber.souza@canonical.com>
To:     Kleber Sacilotto de Souza <kleber.souza@canonical.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        daniel@iogearbox.net, shuah@kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon,  1 Nov 2021 15:53:17 +0100 you wrote:
> In some platforms the numa node numbers are not necessarily consecutive,
> meaning that not all nodes from 0 to the value returned by
> numa_max_node() are available on the system. Using node numbers which
> are not available results on errors from libnuma such as:
> 
> ---- IPv4 UDP ----
> send node 0, receive socket 0
> libnuma: Warning: Cannot read node cpumask from sysfs
> ./reuseport_bpf_numa: failed to pin to node: No such file or directory
> 
> [...]

Here is the summary with links:
  - selftests: net: reuseport_bpf_numa: skip nodes not available
    https://git.kernel.org/bpf/bpf/c/a38bc45a08e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


