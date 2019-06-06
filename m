Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADDA36B28
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 06:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfFFEvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 00:51:24 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56208 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbfFFEvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 00:51:23 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYkMu-0005R1-RB; Thu, 06 Jun 2019 12:51:16 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYkMn-0003bD-SH; Thu, 06 Jun 2019 12:51:09 +0800
Date:   Thu, 6 Jun 2019 12:51:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: Re: rcu_read_lock lost its compiler barrier
Message-ID: <20190606045109.zjfxxbkzq4wb64bj@gondor.apana.org.au>
References: <20190603200301.GM28207@linux.ibm.com>
 <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 10:44:18AM -0400, Alan Stern wrote:
>
> Currently the LKMM says the test is allowed and there is a data race, 
> but this answer clearly is wrong since it would violate the RCU 
> guarantee.

Thank you! This is what I tried to say all along in this thread
but you expressed it in a much better way :)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
