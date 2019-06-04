Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E1334E27
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbfFDRAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:00:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49734 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727757AbfFDRAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:00:04 -0400
Received: (qmail 6565 invoked by uid 2102); 4 Jun 2019 13:00:03 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 4 Jun 2019 13:00:03 -0400
Date:   Tue, 4 Jun 2019 13:00:03 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: Re: rcu_read_lock lost its compiler barrier
In-Reply-To: <CAHk-=wgGnCw==uY8radrB+Tg_CEmzOtwzyjfMkuh7JmqFh+jzQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1906041251210.1731-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019, Linus Torvalds wrote:

> So I don't technically disagree with anything you say,

That's good to know!

>  I just wanted
> to point out that as far as the kernel is concerned, we do have higher
> quality expectations from the compiler than just "technically valid
> according to the C standard".

Which suggests asking whether these higher expectations should be
reflected in the Linux Kernel Memory Model.  So far we have largely
avoided doing that sort of thing, although there are a few exceptions.

(For example, we assume the compiler does not destroy address
dependencies from volatile reads -- but we also warn that this
assumption may fail if the programmer does not follow some rules
described in one of Paul's documentation files.)

Alan

