Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6DC15F02F
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388659AbgBNRxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:53:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55832 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388654AbgBNRxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 12:53:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E44AC15CE62F5;
        Fri, 14 Feb 2020 09:53:03 -0800 (PST)
Date:   Fri, 14 Feb 2020 09:53:03 -0800 (PST)
Message-Id: <20200214.095303.341559462549043464.davem@davemloft.net>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bigeasy@linutronix.de, peterz@infradead.org, williams@redhat.com,
        rostedt@goodmis.org, juri.lelli@redhat.com, mingo@kernel.org
Subject: Re: [RFC patch 00/19] bpf: Make BPF and PREEMPT_RT co-exist
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200214133917.304937432@linutronix.de>
References: <20200214133917.304937432@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Feb 2020 09:53:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 14 Feb 2020 14:39:17 +0100

> This is a follow up to the initial patch series which David posted a
> while ago:
> 
>  https://lore.kernel.org/bpf/20191207.160357.828344895192682546.davem@davemloft.net/
> 
> which was (while non-functional on RT) a good starting point for further
> investigations.

This looks really good after a cursory review, thanks for doing this week.

I was personally unaware of the pre-allocation rules for MAPs used by
tracing et al.  And that definitely shapes how this should be handled.
