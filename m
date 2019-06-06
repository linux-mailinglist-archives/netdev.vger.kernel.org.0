Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D97336FE8
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfFFJcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:32:35 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46826 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727934AbfFFJce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 05:32:34 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYol1-00023m-WA; Thu, 06 Jun 2019 17:32:28 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYol1-00074j-5b; Thu, 06 Jun 2019 17:32:27 +0800
Date:   Thu, 6 Jun 2019 17:32:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andrea Parri <andrea.parri@amarulasolutions.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: rcu_read_lock lost its compiler barrier
Message-ID: <20190606093227.kwtjkhjvbqzcym4s@gondor.apana.org.au>
References: <20150910005708.GA23369@wfg-t540p.sh.intel.com>
 <20150910102513.GA1677@fixme-laptop.cn.ibm.com>
 <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
 <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au>
 <20190606083856.GA5337@andrea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606083856.GA5337@andrea>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 10:38:56AM +0200, Andrea Parri wrote:
> On Mon, Jun 03, 2019 at 10:46:40AM +0800, Herbert Xu wrote:
> 
> > The case we were discussing is from net/ipv4/inet_fragment.c from
> > the net-next tree:
> 
> BTW, thank you for keeping me and other people who intervened in that
> discussion in Cc:...

FWIW I didn't drop you from the Cc list.  The email discussion was
taken off-list by someone else and I simply kept that Cc list when
I brought it back onto lkml.  On a second look I did end up dropping
Eric but I think he's had enough of this discussion :)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
