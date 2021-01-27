Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149B23050E2
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbhA0E3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:29:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317768AbhA0BUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 20:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EE35C64D78;
        Wed, 27 Jan 2021 01:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611710410;
        bh=xX2T/4T/waB96xRgspRRdYnC3N7J08j9V4cPbB/1w+Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kMefngtjJwMMKk/ji33+8eqqYIeJR4NcORbtZH1x+6QrI9ZaUnxL5fSnfZ5WGyfa3
         7RJ2wzpHp0ObjOPYJWPEKAfwI+MP2yFWcNvcoUdDd0Nr1/0uPvzi7kI9wXiklUsGLk
         ChHX0m5ZT049WxPueTebz5tnP4lVhM30Ywu916KfCnQaIk9ylUXYuwa/mQkmLMDjZR
         qIw0l3c5a4gp1VUtcJWoOIwsF5WoFDRKo7N0sBa02+Gy1IAnkqQpDEBeqVF8OO7VgH
         RSFsOlDJiSOtOZ3U1hxht4OaBaO9YpLqdzVfNxucqZAux8dJXpnz7B3SGDXIuPwOD9
         Gc8R42R9WUd+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DCFF7652E0;
        Wed, 27 Jan 2021 01:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] team: protect features update by RCU to avoid deadlock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161171040989.4264.1461001075581140692.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jan 2021 01:20:09 +0000
References: <20210125074416.4056484-1-ivecera@redhat.com>
In-Reply-To: <20210125074416.4056484-1-ivecera@redhat.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, davem@davemloft.net,
        xiyou.wangcong@gmail.com, kuba@kernel.org, saeed@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 25 Jan 2021 08:44:16 +0100 you wrote:
> Function __team_compute_features() is protected by team->lock
> mutex when it is called from team_compute_features() used when
> features of an underlying device is changed. This causes
> a deadlock when NETDEV_FEAT_CHANGE notifier for underlying device
> is fired due to change propagated from team driver (e.g. MTU
> change). It's because callbacks like team_change_mtu() or
> team_vlan_rx_{add,del}_vid() protect their port list traversal
> by team->lock mutex.
> 
> [...]

Here is the summary with links:
  - [net] team: protect features update by RCU to avoid deadlock
    https://git.kernel.org/netdev/net/c/f0947d0d21b2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


