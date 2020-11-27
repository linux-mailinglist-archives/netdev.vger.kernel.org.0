Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0A62C74D4
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbgK1Vth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729196AbgK0TqZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 14:46:25 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606504836;
        bh=Jm4brXMOK7LSIFr2siUZYNbXEbi3OHuiY0i7T/HD+AM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K9WfKxe5DO9JLgonSt3gykVH2D7BejAG2W18IvYzT6mLWDgTjTHp8Gt+iYfa3qWmU
         ipvH6s1jmIgeM+HNr+CPjjVRwQ09hqDVuwkvSAlZ2vuHvJLwguiST0d9eGFphsUfCA
         F4MBDtI0XMbvyur6EUeV9xWP6/yznioXZwUJX5LY=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: openvswitch: fix TTL decrement action netlink
 message format
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160650483679.8048.11913131798879852264.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Nov 2020 19:20:36 +0000
References: <160622121495.27296.888010441924340582.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
In-Reply-To: <160622121495.27296.888010441924340582.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        kuba@kernel.org, pshelar@ovn.org, bindiyakurle@gmail.com,
        i.maximets@ovn.org, mcroce@linux.microsoft.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 24 Nov 2020 07:34:44 -0500 you wrote:
> Currently, the openvswitch module is not accepting the correctly formated
> netlink message for the TTL decrement action. For both setting and getting
> the dec_ttl action, the actions should be nested in the
> OVS_DEC_TTL_ATTR_ACTION attribute as mentioned in the openvswitch.h uapi.
> 
> When the original patch was sent, it was tested with a private OVS userspace
> implementation. This implementation was unfortunately not upstreamed and
> reviewed, hence an erroneous version of this patch was sent out.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: openvswitch: fix TTL decrement action netlink message format
    https://git.kernel.org/netdev/net/c/69929d4c49e1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


