Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283BC44DFD2
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 02:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhKLBih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 20:38:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230308AbhKLBih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 20:38:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 036AF6124C;
        Fri, 12 Nov 2021 01:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636680947;
        bh=46YKcmYJNvjP/kmm5mE9S8EgRTVQBTxr4vq4JlN7ZSo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YrJLnf3veSI6FT+hjXzLLXEa5QtSq62K0BMDSyGf2EwX1gIgggTnRsB5guaQ33u4Q
         CectJWjwcVRjXyOiBH28tSXoWyZ729Je+aDSgPaqJoUkY7JSHrjIe/vB2jZGxFW4Ep
         2ISS/QzYbz08OgmDtPLR7H1YbyUQl5uoXmxBrKGpwGa9zxxKUNgFvHlm/c73NTK2wj
         b457TEADlcKfTvk8ls1b0tFlho40D7h3/GE0dOsIZykZ+uCjJx66tt2sPYKWg7JmNR
         XSRNwLtpQvb+DVq6HP9tTNoriqvt6EvZX8NUGJeA33PlPODdwArW/08noyFttLQ66j
         7I/eu4AN0oAqA==
Date:   Thu, 11 Nov 2021 17:35:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        luo penghao <cgel.zte@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        luo.penghao@zte.com.cn, zealci@zte.com.cn
Subject: Re: [PATCH linux-next] ipv6: Remove assignment to 'newinet'
Message-ID: <20211111173545.2278b479@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iL7bO-vspoqTvyWZ22vp7qgiC+jC7fPm8XTtoiF8k+2EQ@mail.gmail.com>
References: <20211111092346.159994-1-luo.penghao@zte.com.cn>
        <163667767064.21646.9365544142891525487.git-patchwork-notify@kernel.org>
        <CANn89iL7bO-vspoqTvyWZ22vp7qgiC+jC7fPm8XTtoiF8k+2EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 17:16:32 -0800 Eric Dumazet wrote:
> On Thu, Nov 11, 2021 at 4:41 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
> > Here is the summary with links:
> >   - [linux-next] ipv6: Remove assignment to 'newinet'
> >     https://git.kernel.org/netdev/net-next/c/70bf363d7adb
> 
> But why ?

It's just the bot getting confused because the patch is identical.

Sorry, I should have marked it as Rejected in pw before I did the pull.

Note that the commit hash from the bot's reply is identical to the
commit you quoted.

> All these bots, trying to send the same patches to multiple trees....
> 
> commit 70bf363d7adb3a428773bc905011d0ff923ba747
> Author: Nghia Le <nghialm78@gmail.com>
> Date:   Thu Nov 4 21:37:40 2021 +0700
> 
>     ipv6: remove useless assignment to newinet in tcp_v6_syn_recv_sock()
