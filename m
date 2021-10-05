Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1815F4232A2
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 23:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbhJEVHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 17:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231322AbhJEVHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 17:07:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB00E61139;
        Tue,  5 Oct 2021 21:05:19 +0000 (UTC)
Date:   Tue, 5 Oct 2021 17:05:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam <coreteam@netfilter.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
Message-ID: <20211005170518.07bd5c4c@gandalf.local.home>
In-Reply-To: <CAHk-=wj+P=YeuY=tpY72nDMQgxGTzEMqjfq5P536G=qYEkQr1w@mail.gmail.com>
References: <20211005094728.203ecef2@gandalf.local.home>
        <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
        <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
        <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr>
        <20211005144002.34008ea0@gandalf.local.home>
        <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr>
        <20211005154029.46f9c596@gandalf.local.home>
        <20211005163754.66552fb3@gandalf.local.home>
        <CAHk-=wj+P=YeuY=tpY72nDMQgxGTzEMqjfq5P536G=qYEkQr1w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 13:45:52 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> If there was some clean and simple solution to the compiler warning
> problem, that would be one thing. But when you think you need to
> change core RCU macros, or lie to the compiler about the type system,
> at that point it's not some clean and simple fix any more. At that
> point you're literally making things worse than just exposing the
> type.

Fine, I'll just create a separate header file with all that is needed and
add it to the include. At least that way, it doesn't muck up the rest of
the header file.

-- Steve
