Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BD337FBB6
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 18:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhEMQoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 12:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230491AbhEMQoX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 12:44:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01FDA61438;
        Thu, 13 May 2021 16:43:11 +0000 (UTC)
Date:   Thu, 13 May 2021 12:43:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, sassmann@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable-rt@vger.kernel.org
Subject: Re: [PATCH net-next] net: Treat __napi_schedule_irqoff() as
 __napi_schedule() on PREEMPT_RT
Message-ID: <20210513124310.1d8b33f0@gandalf.local.home>
In-Reply-To: <20210512205046.7eabe8fc@oasis.local.home>
References: <YJofplWBz8dT7xiw@localhost.localdomain>
        <20210512214324.hiaiw3e2tzmsygcz@linutronix.de>
        <87k0o360zx.ffs@nanos.tec.linutronix.de>
        <20210512205046.7eabe8fc@oasis.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 May 2021 20:50:46 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 13 May 2021 00:28:02 +0200
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > No matter which variant we end up with, this needs to go into all stable
> > RT kernels ASAP.  
> 
> Is this in rt-devel already?
> 
> I'll start pulling in whatever is in there.

I don't see this in the rt-devel tree. The stable-rt releases always pull
from there (following the stable vs mainline relationship).

Is there going to be a new rt-devel release?

-- Steve
