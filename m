Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A412386CF2
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343772AbhEQWbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:31:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236574AbhEQWb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 18:31:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9A11B6113C;
        Mon, 17 May 2021 22:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621290609;
        bh=fca+cOlQmii2QzXiWpLf/iIgR1ePqnQQfukVgcxZtwY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B5rIY9tpDv0WO4INvef64QlUReZxEQ0zxyTCHfErlcx4O7Qr52E0eVVjBiqbkHdQ6
         R2VFSWOGM61KT1GBb2Po4xcoEgQ0I4U8AfY30oZN8pwWL5lc7la9/DQ6tGJeLNHfgE
         7h6DAFoe8JzImu3LBbtCvSmzDyuYVbGKpYW0+77016Vzoo49lXhGRyfaFf4uUwMGpl
         eudR7QX9uHIPDo/Ltn6MOhhtoV9UqpuY5ZRHt5hXPPGM2L8250tNrfllYbum6iYgTt
         qSJ23BHILj9NXF1EGakC99zfC/6qM3EYvrg1+gi8xxrHKQYLGFZbNF7Ie0z+84qjPo
         1brnxIrzwvHwQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8CC2D60963;
        Mon, 17 May 2021 22:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bonding: init notify_work earlier to avoid uninitialized use
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162129060957.6973.14308323521678022271.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 22:30:09 +0000
References: <20210517161335.e40fea7f895a.I8b8487a9c0b8f54716cf44fdae02185381b1f64e@changeid>
In-Reply-To: <20210517161335.e40fea7f895a.I8b8487a9c0b8f54716cf44fdae02185381b1f64e@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, johannes.berg@intel.com,
        syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 17 May 2021 16:13:35 +0200 you wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If bond_kobj_init() or later kzalloc() in bond_alloc_slave() fail,
> then we call kobject_put() on the slave->kobj. This in turn calls
> the release function slave_kobj_release() which will always try to
> cancel_delayed_work_sync(&slave->notify_work), which shouldn't be
> done on an uninitialized work struct.
> 
> [...]

Here is the summary with links:
  - bonding: init notify_work earlier to avoid uninitialized use
    https://git.kernel.org/netdev/net/c/35d96e631860

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


