Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72C337F0AB
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 02:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240463AbhEMAwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 20:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240410AbhEMAv5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 20:51:57 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4B58613EB;
        Thu, 13 May 2021 00:50:47 +0000 (UTC)
Date:   Wed, 12 May 2021 20:50:46 -0400
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
Message-ID: <20210512205046.7eabe8fc@oasis.local.home>
In-Reply-To: <87k0o360zx.ffs@nanos.tec.linutronix.de>
References: <YJofplWBz8dT7xiw@localhost.localdomain>
        <20210512214324.hiaiw3e2tzmsygcz@linutronix.de>
        <87k0o360zx.ffs@nanos.tec.linutronix.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 May 2021 00:28:02 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> No matter which variant we end up with, this needs to go into all stable
> RT kernels ASAP.

Is this in rt-devel already?

I'll start pulling in whatever is in there.

-- Steve
