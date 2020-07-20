Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F3F226C5D
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgGTQtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgGTQtO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 12:49:14 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0EB42070A;
        Mon, 20 Jul 2020 16:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595263754;
        bh=0nBG1atNvE3vi7Y0Z23NlgGjJPkg0sBnlTGH1rK6fOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QS+RZIaZA0iWBYYEvuBrQzUDmQWwpuDMDgRo+Kj6rjDX28s2fDXKv01dfYPipFdZ4
         y55orooO1pC6LqHgHBv0eKZygXfOqGwbJ4CH/7tsFJ7miHyr3Uwk3Vdl2IEh8FBL7D
         38e1CENAA/W7fiujItZgIVvQuTSUoh3PKsm3IcJc=
Date:   Mon, 20 Jul 2020 09:49:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4 00/24] seqlock: Extend seqcount API with associated
 locks
Message-ID: <20200720164912.GC1292162@gmail.com>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
 <20200720155530.1173732-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720155530.1173732-1-a.darwish@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 05:55:06PM +0200, Ahmed S. Darwish wrote:
> Hi,
> 
> This is v4 of the seqlock patch series:
> 
>    [PATCH v1 00/25]
>    https://lore.kernel.org/lkml/20200519214547.352050-1-a.darwish@linutronix.de
> 
>    [PATCH v2 00/06] (bugfixes-only, merged)
>    https://lore.kernel.org/lkml/20200603144949.1122421-1-a.darwish@linutronix.de
> 
>    [PATCH v2 00/18]
>    https://lore.kernel.org/lkml/20200608005729.1874024-1-a.darwish@linutronix.de
> 
>    [PATCH v3 00/20]
>    https://lore.kernel.org/lkml/20200630054452.3675847-1-a.darwish@linutronix.de
> 
> It is based over:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git :: locking/core
> 

Please include an explanation of the patch series in the cover letter.  It looks
like you sent it in v1 and then stopped including it.  That doesn't work;
reviewers shouldn't have to read all previous versions too and try to guess
which parts are still up-to-date.

- Eric
