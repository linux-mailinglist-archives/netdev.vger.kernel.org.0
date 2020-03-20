Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2318B18C9A8
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgCTJN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:13:57 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34846 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgCTJN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 05:13:57 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jFDin-00007J-F3; Fri, 20 Mar 2020 10:13:41 +0100
Date:   Fri, 20 Mar 2020 10:13:41 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     tglx@linutronix.de, arnd@arndb.de, balbi@kernel.org,
        bhelgaas@google.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, joel@joelfernandes.org,
        kurt.schwemmer@microsemi.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, logang@deltatee.com,
        mingo@kernel.org, mpe@ellerman.id.au, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 17/15] rcuwait: Inform rcuwait_wake_up() users if a
 wakeup was attempted
Message-ID: <20200320091341.fglhscnr3sixyzjs@linutronix.de>
References: <20200318204302.693307984@linutronix.de>
 <20200320085527.23861-1-dave@stgolabs.net>
 <20200320085527.23861-2-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200320085527.23861-2-dave@stgolabs.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-20 01:55:25 [-0700], Davidlohr Bueso wrote:
> Let the caller know if wake_up_process() was actually called or not;
> some users can use this information for ad-hoc. Of course returning
> true does not guarantee that wake_up_process() actually woke anything
> up.

Wouldn't it make sense to return wake_up_process() return value to know
if a change of state occurred or not?

Sebastian
