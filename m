Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 517FE18E0FC
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 13:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbgCUMI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 08:08:58 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38570 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgCUMI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 08:08:57 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFcvN-00035h-He; Sat, 21 Mar 2020 13:08:21 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id E1F47FFC8D; Sat, 21 Mar 2020 13:08:20 +0100 (CET)
To:     Guo Ren <guoren@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Arnd Bergmann <arnd@arndb.de>, balbi@kernel.org,
        bhelgaas@google.com, dave@stgolabs.net,
        David Miller <davem@davemloft.net>, gregkh@linuxfoundation.org,
        joel@joelfernandes.org, kurt.schwemmer@microsemi.com,
        kvalo@codeaurora.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        logang@deltatee.com, mingo@kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        torvalds@linux-foundation.org, Will Deacon <will@kernel.org>,
        linux-csky@vger.kernel.org, kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 2/5] csky: Remove mm.h from asm/uaccess.h
In-Reply-To: <CAJF2gTQDvmSdJB3R0By0Q6d9ganVBV1FBm3urL8Jf1fyiEi+1A@mail.gmail.com>
References: <20200318204408.010461877@linutronix.de> <20200320094856.3453859-1-bigeasy@linutronix.de> <20200320094856.3453859-3-bigeasy@linutronix.de> <CAJF2gTQDvmSdJB3R0By0Q6d9ganVBV1FBm3urL8Jf1fyiEi+1A@mail.gmail.com>
 From: Thomas Gleixner <tglx@linutronix.de>
From:   Thomas Gleixner <tglx@linutronix.de>
Date:   Sat, 21 Mar 2020 13:08:20 +0100
Message-ID: <87zhc9rjuz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guo Ren <guoren@kernel.org> writes:

> Tested and Acked by me.
>
> Queued for next pull request, thx

Can we please route that with the rcuwait changes to avoid breakage
unless you ship it to Linus right away?

Thanks,

        tglx
