Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2255F66617
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 07:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfGLFTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 01:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbfGLFTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 01:19:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC9E020863;
        Fri, 12 Jul 2019 05:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562908780;
        bh=yE7S5fzJoVQNuX0LT96I6+TD22L2qYACRj+IFS/83eU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kNq5Dy+my5tAbdckuPkkqqy713gpH02voNBbWAc0YMm+F2x/aSJj+DmEypI2Tl56C
         5N+Lrf92INs2kOIY1DJsNeTGh9AYPWqkDAm+/AjWkoIHhCmmq0tGj/bw9QuQlpr+MG
         JTIHGaL/pzpQCDvHKHjaVVofZsfkYdXSV8e3jimc=
Date:   Fri, 12 Jul 2019 07:19:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org, oleg@redhat.com,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v1 3/6] driver/core: Convert to use built-in RCU list
 checking
Message-ID: <20190712051937.GA4682@kroah.com>
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-4-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711234401.220336-4-joel@joelfernandes.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 07:43:58PM -0400, Joel Fernandes (Google) wrote:
> list_for_each_entry_rcu has built-in RCU and lock checking. Make use of
> it in driver core.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  drivers/base/base.h          |  1 +
>  drivers/base/core.c          | 10 ++++++++++
>  drivers/base/power/runtime.c | 15 ++++++++++-----
>  3 files changed, 21 insertions(+), 5 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
