Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E421CE3D0
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 21:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731339AbgEKTVp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 11 May 2020 15:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728613AbgEKTVp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 15:21:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C72F5206E6;
        Mon, 11 May 2020 19:21:42 +0000 (UTC)
Date:   Mon, 11 May 2020 15:21:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, mingo@redhat.com,
        aquini@redhat.com, cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, tiwai@suse.de, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] net: taint when the device driver firmware
 crashes
Message-ID: <20200511152141.2305e916@gandalf.local.home>
In-Reply-To: <1e097eb0-6132-f549-8069-d13b678183f5@pensando.io>
References: <20200509043552.8745-1-mcgrof@kernel.org>
        <1e097eb0-6132-f549-8069-d13b678183f5@pensando.io>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 May 2020 18:01:51 -0700
Shannon Nelson <snelson@pensando.io> wrote:

> If the driver is able to detect that the device firmware has come back 
> alive, through user intervention or whatever, should there be a way to 
> "untaint" the kernel?  Or would you expect it to remain tainted?

The only way to untaint a kernel is a reboot. A taint just means "something
happened to this kernel since it was booted". It's used as a hint, and
that's all.

I agree with the other comments in this thread. Use devlink health or
whatever tool to look further into causes. But from what I see here, this
code is "good enough" for a taint.

-- Steve
