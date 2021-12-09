Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC0C46ECD1
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbhLIQNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbhLIQNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:13:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CF4C0617A1;
        Thu,  9 Dec 2021 08:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BB7E1CE2688;
        Thu,  9 Dec 2021 16:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7B6DC341C7;
        Thu,  9 Dec 2021 16:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639066209;
        bh=+gz0yPKO9apkhY4KkNlBejJirpLXV4e0VeiQkgG1ZXo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UJjMXhvcV9OTDF0+KpLwzte13L+yDIWfh0lM7gbHaFTdQATOhs2n3k8aY/dVVQ/KY
         iaeCDBp/oiYlPT4PQnepkCE296aD4/0EQq2YcbNXv/8mHRDvBF8NqxtxVGUdXUPb9Z
         3FaBIlHYUG9wSnUTD+XP3pLUtCNExYAfDjvWqiYDMuf83M13VTTg2WgON1jHE+9Mqt
         04ofC21kbzBVOEE2VUnsuQaDoHoNFd3GpBx858tIlOws+/UdX/jJ2Zrc99IGht4BbJ
         bP2oTeNlUlQTRM91rXpy6N8UE0vMOKpqAjGrnxv9VS2j+aB3/6vU/gwu+pwRXZhhgt
         hJ/pYE4e/KxVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B8EF160A54;
        Thu,  9 Dec 2021 16:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] seg6: fix the iif in the IPv6 socket control block
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163906620975.18129.7634025043652451728.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 16:10:09 +0000
References: <20211208195409.12169-1-andrea.mayer@uniroma2.it>
In-Reply-To: <20211208195409.12169-1-andrea.mayer@uniroma2.it>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, yohei.kanemaru@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stefano.salsano@uniroma2.it, paolo.lungaroni@uniroma2.it,
        ahabdels.dev@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Dec 2021 20:54:09 +0100 you wrote:
> When an IPv4 packet is received, the ip_rcv_core(...) sets the receiving
> interface index into the IPv4 socket control block (v5.16-rc4,
> net/ipv4/ip_input.c line 510):
> 
>     IPCB(skb)->iif = skb->skb_iif;
> 
> If that IPv4 packet is meant to be encapsulated in an outer IPv6+SRH
> header, the seg6_do_srh_encap(...) performs the required encapsulation.
> In this case, the seg6_do_srh_encap function clears the IPv6 socket control
> block (v5.16-rc4 net/ipv6/seg6_iptunnel.c line 163):
> 
> [...]

Here is the summary with links:
  - [net] seg6: fix the iif in the IPv6 socket control block
    https://git.kernel.org/netdev/net/c/ae68d93354e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


