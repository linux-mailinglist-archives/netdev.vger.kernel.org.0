Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 567F83763A
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbfFFOTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:19:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51806 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727168AbfFFOTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 10:19:44 -0400
Received: (qmail 3016 invoked by uid 2102); 6 Jun 2019 10:19:43 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 6 Jun 2019 10:19:43 -0400
Date:   Thu, 6 Jun 2019 10:19:43 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Andrea Parri <andrea.parri@amarulasolutions.com>
cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: Re: rcu_read_lock lost its compiler barrier
In-Reply-To: <20190606081657.GA4249@andrea>
Message-ID: <Pine.LNX.4.44L0.1906061017200.1641-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019, Andrea Parri wrote:

> This seems a sensible change to me: looking forward to seeing a patch,
> on top of -rcu/dev, for further review and testing!
> 
> We could also add (to LKMM) the barrier() for rcu_read_{lock,unlock}()
> discussed in this thread (maybe once the RCU code and the informal doc
> will have settled in such direction).

Yes.  Also for SRCU.  That point had not escaped me.

Alan

