Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11183B0BDB
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhFVRwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232349AbhFVRwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:52:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 294C161369;
        Tue, 22 Jun 2021 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624384206;
        bh=UQ0iP6siAN5nJzEoKXZ0VzOgmXwsvyb0MTNoUvwfVrA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NdYsbPVQ9uVawNDzBXxmNNrmMPP12TOXWC0P+AdaNAofZ/RP1f8WdQSEdDABxbpa4
         yhIKN6oG8mT440qiepxBadcOxiJP5uJDl0cjRnx0CCaLGTOv9CxAXGA45ZWQM9fheW
         LY7z9dRTz0L2IEo0dmw/ulOj5a4NRpbJx/lRIztAVMDWjMEeQXE5O2BMjyR1eC79Zm
         W3qh+3DyroYBn3HHG5fUmp3s9Pdjktv+mNw87VevAkULSM3g9WrzDHo6WX2wANWc0K
         KcDGgTwqgXvmyqwtyItjFKJUhkw/+uZcvbtkJMJlsGOLTkpm6KkEt7ROQYaz3JxqE3
         3un0J8rFotDwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1C38C60CAA;
        Tue, 22 Jun 2021 17:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] openvswitch: add trace points
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438420611.559.7924381110703522378.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:50:06 +0000
References: <20210622140233.282345-1-aconole@redhat.com>
In-Reply-To: <20210622140233.282345-1-aconole@redhat.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        echaudro@redhat.com, dceara@redhat.com, i.maximets@ovn.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 22 Jun 2021 10:02:33 -0400 you wrote:
> This makes openvswitch module use the event tracing framework
> to log the upcall interface and action execution pipeline.  When
> using openvswitch as the packet forwarding engine, some types of
> debugging are made possible simply by using the ovs-vswitchd's
> ofproto/trace command.  However, such a command has some
> limitations:
> 
> [...]

Here is the summary with links:
  - [net-next] openvswitch: add trace points
    https://git.kernel.org/netdev/net-next/c/c4ab7b56be0f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


