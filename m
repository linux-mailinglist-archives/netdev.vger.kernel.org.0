Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831E74A836A
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 12:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349090AbiBCL7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 06:59:52 -0500
Received: from mail.toke.dk ([45.145.95.12]:47811 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243070AbiBCL7w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 06:59:52 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1643889587; bh=Nh8HdXGH1bcEwoOWsImA/Fw3sNpRhvEKArp2sI5z3Xc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=fY+oeMl8Mjhp9pNrxxm1FFqn/K98+cUDvG3oIX22hWudvokQEKIRHmuuBjGo5c7bC
         tRhKGwjSMMSRNz3VXzkcX6d/1s0MA8Pgrwjs2+e35y8uvS7NUz+dI2hhuZt0rjtY0R
         MxedNQvKBfneWGSURhNYoez6Pl9u+KKJj4j6Ys9G7pv61wzVNJGA27OkQL0wxmD1ZK
         FshlnfYf2KzdGbSyFA4R5WOU9qRxiEwj8N9Xp6ER3OYwFouAJ+62GLppILl1jPRIYk
         SHDDLSHe7mVJnoB6PI0p1x6qKyF9d4tHqhfXGbWCw42R5v3cWDVELPyJtGk4Xe1dod
         /yh2TI0mv/AgQ==
To:     Jakub Kicinski <kuba@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 0/4] net: dev: PREEMPT_RT fixups.
In-Reply-To: <20220202081447.29f4fe2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202081447.29f4fe2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 03 Feb 2022 12:59:46 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87wnicb1ot.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed,  2 Feb 2022 13:28:44 +0100 Sebastian Andrzej Siewior wrote:
>> Hi,
>> 
>> this series removes or replaces preempt_disable() and local_irq_save()
>> sections which are problematic on PREEMPT_RT.
>> Patch 3 makes netif_rx() work from any context after I found suggestions
>> for it in an old thread. Should that work, then the context-specific
>> variants could be removed.
>
> Let's CC Toke, lest it escapes his attention.

Thanks! I'll take a look :)

-Toke
