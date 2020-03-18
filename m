Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58D918A435
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgCRUrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:47:17 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58398 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgCRUrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 16:47:17 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jEfaG-00065g-VF; Wed, 18 Mar 2020 21:46:37 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 0CF59101161;
        Wed, 18 Mar 2020 21:46:35 +0100 (CET)
Message-Id: <20200318204302.693307984@linutronix.de>
User-Agent: quilt/0.65
Date:   Wed, 18 Mar 2020 21:43:02 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: [patch V2 00/15] Lock ordering documentation and annotation for lockdep
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second version of this work. The first one can be found here:

   https://lore.kernel.org/r/20200313174701.148376-1-bigeasy@linutronix.de

Changes since V1:

  - Split the PCI/switchtec patch (picked up the fix from Logan) and
    reworked the change log.

  - Addressed Linus feedback vs. completions.

    Most of the places which had open coded completion variants have been
    analysed and fixed up to use the regular interfaces.

    The PS3 one got converted by Peter Zijlstra to rcu_wait().

    Add explanation in the change log why swait actually fits the
    completion semantics.

  - Addressed Randys feedback on documentation

Thanks,

	tglx

