Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE6F2CBEF9
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 15:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgLBODZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 09:03:25 -0500
Received: from foss.arm.com ([217.140.110.172]:40756 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbgLBODY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 09:03:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 001D91063;
        Wed,  2 Dec 2020 06:02:39 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.23.201])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E27F83F718;
        Wed,  2 Dec 2020 06:02:35 -0800 (PST)
Date:   Wed, 2 Dec 2020 14:02:33 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alex Belits <abelits@marvell.com>
Cc:     "trix@redhat.com" <trix@redhat.com>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v5 0/9] "Task_isolation" mode
Message-ID: <20201202140233.GB66958@C02TD0UTHF1T.local>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
 <b0e7afd3-4c11-c8f3-834b-699c20dbdd90@redhat.com>
 <a31f81cfa62936ff5edc420be63a5ac0b318b594.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a31f81cfa62936ff5edc420be63a5ac0b318b594.camel@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 05:40:49PM +0000, Alex Belits wrote:
> 
> On Tue, 2020-11-24 at 08:36 -0800, Tom Rix wrote:
> > External Email
> > 
> > -------------------------------------------------------------------
> > ---
> > 
> > On 11/23/20 9:42 AM, Alex Belits wrote:
> > > This is an update of task isolation work that was originally done
> > > by
> > > Chris Metcalf <cmetcalf@mellanox.com> and maintained by him until
> > > November 2017. It is adapted to the current kernel and cleaned up
> > > to
> > > implement its functionality in a more complete and cleaner manner.
> > 
> > I am having problems applying the patchset to today's linux-next.
> > 
> > Which kernel should I be using ?
> 
> The patches are against Linus' tree, in particular, commit
> a349e4c659609fd20e4beea89e5c4a4038e33a95

Is there any reason to base on that commit in particular?

Generally it's preferred that a series is based on a tag (so either a
release or an -rc kernel), and that the cover letter explains what the
base is. If you can do that in future it'll make the series much easier
to work with.

Thanks,
Mark.
