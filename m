Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86ADC287CB1
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgJHUAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728538AbgJHUAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 16:00:05 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602187205;
        bh=eW+ux2kVSU5Ov+rZtAh3UH1jEbtBx6Q0zFlh8Wy3fnA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SaJS6/UNt7Ylfke678Pfw4SyNO3CD9CxKh6MLYvNMq9RE5st7TDrfvv2qvMLbs/vl
         G/LIoW146DhR7bFR+yPhyPB/3rtUR18rJ0M2/ud9+PFFzx49wOxq0umjtQHXdaP+h3
         cYVZJ3n36oDI5E2PQHkFx23egVlERPi4mYECPzR0=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] openvswitch: handle DNAT tuple collision
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160218720504.8125.8792796612481255724.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Oct 2020 20:00:05 +0000
References: <1602085683-29043-1-git-send-email-dceara@redhat.com>
In-Reply-To: <1602085683-29043-1-git-send-email-dceara@redhat.com>
To:     Dumitru Ceara <dceara@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        aconole@redhat.com, fw@strlen.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  7 Oct 2020 17:48:03 +0200 you wrote:
> With multiple DNAT rules it's possible that after destination
> translation the resulting tuples collide.
> 
> For example, two openvswitch flows:
> nw_dst=10.0.0.10,tp_dst=10, actions=ct(commit,table=2,nat(dst=20.0.0.1:20))
> nw_dst=10.0.0.20,tp_dst=10, actions=ct(commit,table=2,nat(dst=20.0.0.1:20))
> 
> [...]

Here is the summary with links:
  - [net] openvswitch: handle DNAT tuple collision
    https://git.kernel.org/netdev/net/c/8aa7b526dc0b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


