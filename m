Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3440951CA9
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 22:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732162AbfFXU6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 16:58:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbfFXU6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 16:58:16 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 729B030917AC;
        Mon, 24 Jun 2019 20:58:16 +0000 (UTC)
Received: from redhat.com (ovpn-118-11.phx2.redhat.com [10.3.118.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E61465D717;
        Mon, 24 Jun 2019 20:58:15 +0000 (UTC)
Received: from fche by redhat.com with local (Exim 4.92)
        (envelope-from <fche@redhat.com>)
        id 1hfW2U-0003ow-Ba; Mon, 24 Jun 2019 16:58:10 -0400
Date:   Mon, 24 Jun 2019 16:58:10 -0400
From:   "Frank Ch. Eigler" <fche@redhat.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, jikos@kernel.org,
        mbenes@suse.cz, Petr Mladek <pmladek@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Richter <rric@kernel.org>,
        rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        paulmck <paulmck@linux.ibm.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        oprofile-list@lists.sf.net, netdev <netdev@vger.kernel.org>,
        bpf@vger.kernel.org
Subject: Re: [PATCH 2/3] module: Fix up module_notifier return values.
Message-ID: <20190624205810.GD26422@redhat.com>
References: <20190624091843.859714294@infradead.org>
 <20190624092109.805742823@infradead.org>
 <320564860.243.1561384864186.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <320564860.243.1561384864186.JavaMail.zimbra@efficios.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 24 Jun 2019 20:58:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi -

> > While auditing all module notifiers I noticed a whole bunch of fail
> > wrt the return value. Notifiers have a 'special' return semantics.

From peterz's comments, the patches, it's not obvious to me how one is
to choose between 0 (NOTIFY_DONE) and 1 (NOTIFY_OK) in the case of a
routine success.

> [...]
> I have a similar erroneous module notifier return value pattern
> in lttng-modules as well. I'll go fix it right away. CCing
> Frank Eigler from SystemTAP which AFAIK use a copy of
> lttng-tracepoint.c in their project, which should be fixed
> as well. I'm pasting the lttng-modules fix below.

Sure, following suit.  Thanks.

- FChE
