Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974383CFAAE
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239137AbhGTMyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:54:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239092AbhGTMtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 08:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6DBD9610FB;
        Tue, 20 Jul 2021 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626787810;
        bh=da5/7mu0jpr4XWnRL2cnq+Aw0+srLlOZtZDnWqCmv54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kxkM8P9ESMb+ksNJGC47G5swO/xI6kkdtO3207PWDEWZxP8OlIXgVf2J5SRog+1TR
         OPYvGRkNkd0405Duthba3FGT+Ic1EXEz2Ac7nIqBpxv5hfByDXigOgxVI0IFVkWsdh
         uzoBYSyLEMkoOtcOhHSqEEpFNadTMjRUBPQBSoHnj5izGv4H2VXlXGSKm1qoOhk8B7
         eHWCQIuEV809WhGvoL309oFneNIxhVo95n45XIiVvX69TF/bAR1reOdonqHxWEqlmA
         qWBcsD0DwjRFa3qAd/NnBWfDgkE06m8hvBC6X2mUN6RfzWISOmUbiTrP6PpbJZzqdX
         L19/2HBehHunw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6381760CD3;
        Tue, 20 Jul 2021 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] veth: more flexible channels number
 configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162678781040.19709.7119682364052971115.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 13:30:10 +0000
References: <cover.1626768072.git.pabeni@redhat.com>
In-Reply-To: <cover.1626768072.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        shuah@kernel.org, toke@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 10:41:47 +0200 you wrote:
> XDP setups can benefit from multiple veth RX/TX queues. Currently
> veth allow setting such number only at creation time via the
> 'numrxqueues' and 'numtxqueues' parameters.
> 
> This series introduces support for the ethtool set_channel operation
> and allows configuring the queue number via a new module parameter.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] veth: always report zero combined channels
    https://git.kernel.org/netdev/net-next/c/f7918b79019f
  - [net-next,2/5] veth: factor out initialization helper
    https://git.kernel.org/netdev/net-next/c/dedd53c5e075
  - [net-next,3/5] veth: implement support for set_channel ethtool op
    https://git.kernel.org/netdev/net-next/c/4752eeb3d891
  - [net-next,4/5] veth: create by default nr_possible_cpus queues
    https://git.kernel.org/netdev/net-next/c/9d3684c24a52
  - [net-next,5/5] selftests: net: veth: add tests for set_channel
    https://git.kernel.org/netdev/net-next/c/1ec2230fc721

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


