Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36E34532E7
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 14:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhKPNfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 08:35:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54852 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbhKPNfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 08:35:24 -0500
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id AF65C503A7F8B;
        Tue, 16 Nov 2021 05:32:24 -0800 (PST)
Date:   Tue, 16 Nov 2021 13:32:19 +0000 (GMT)
Message-Id: <20211116.133219.63511987274053306.davem@davemloft.net>
To:     edumazet@google.com
Cc:     pabeni@redhat.com, soheil@google.com, eric.dumazet@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, ncardwell@google.com,
        arjunroy@google.com
Subject: Re: [PATCH net-next 00/20] tcp: optimizations for linux-5.17
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CANn89iJ2vjOrH_asxiPtPbJmPiyWXf1gpE5EKYTf+3zMrVt_Bw@mail.gmail.com>
References: <dacd415c06bc854136ba93ef258e92292b782037.camel@redhat.com>
        <CANn89iJFFQxo9qA-cLXRjbw9ob5g+dzRp7H0016JJdtALHKikg@mail.gmail.com>
        <CANn89iJ2vjOrH_asxiPtPbJmPiyWXf1gpE5EKYTf+3zMrVt_Bw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 16 Nov 2021 05:32:26 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 15 Nov 2021 18:06:29 -0800

> On Mon, Nov 15, 2021 at 1:47 PM Eric Dumazet <edumazet@google.com> wrote:
> 
> Apparently the series is now complete on patchwork
> https://patchwork.kernel.org/project/netdevbpf/list/?series=580363
> 
> Let me know if I need to resend (with few typos fixed)

No need to resend, all applied, thanks Eric!
