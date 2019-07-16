Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1BF6B0D9
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 23:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388885AbfGPVNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 17:13:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58084 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbfGPVNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 17:13:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1D861264F01F;
        Tue, 16 Jul 2019 14:12:59 -0700 (PDT)
Date:   Tue, 16 Jul 2019 14:12:59 -0700 (PDT)
Message-Id: <20190716.141259.1717459496779829137.davem@davemloft.net>
To:     paulmck@linux.ibm.com
Cc:     joel@joelfernandes.org, linux-kernel@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, bhelgaas@google.com, bp@alien8.de,
        c0d1n61at3@gmail.com, edumazet@google.com,
        gregkh@linuxfoundation.org, yoshfuji@linux-ipv6.org, hpa@zytor.com,
        mingo@redhat.com, corbet@lwn.net, josh@joshtriplett.org,
        keescook@chromium.org, kernel-hardening@lists.openwall.com,
        kernel-team@android.com, jiangshanlai@gmail.com, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        mathieu.desnoyers@efficios.com, neilb@suse.com,
        netdev@vger.kernel.org, oleg@redhat.com, pavel@ucw.cz,
        peterz@infradead.org, rjw@rjwysocki.net,
        rasmus.villemoes@prevas.dk, rcu@vger.kernel.org,
        rostedt@goodmis.org, tj@kernel.org, tglx@linutronix.de,
        will@kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/9] ipv4: add lockdep condition to fix for_each_entry
 (v1)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190716183955.GF14271@linux.ibm.com>
References: <20190715143705.117908-1-joel@joelfernandes.org>
        <20190715143705.117908-5-joel@joelfernandes.org>
        <20190716183955.GF14271@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jul 2019 14:13:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Date: Tue, 16 Jul 2019 11:39:55 -0700

> On Mon, Jul 15, 2019 at 10:37:00AM -0400, Joel Fernandes (Google) wrote:
>> Using the previous support added, use it for adding lockdep conditions
>> to list usage here.
>> 
>> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> We need an ack or better from the subsystem maintainer for this one.

Acked-by: David S. Miller <davem@davemloft.net>
