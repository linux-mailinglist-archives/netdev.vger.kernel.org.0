Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3972F36B00
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 06:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbfFFEiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 00:38:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55342 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfFFEiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 00:38:11 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYkA7-0005Ha-Ee; Thu, 06 Jun 2019 12:38:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYk9z-0003Zv-Oe; Thu, 06 Jun 2019 12:37:55 +0800
Date:   Thu, 6 Jun 2019 12:37:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: rcu_read_lock lost its compiler barrier
Message-ID: <20190606043755.f6bkexrycojlj6pu@gondor.apana.org.au>
References: <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <20190603000617.GD28207@linux.ibm.com>
 <20190603030324.kl3bckqmebzis2vw@gondor.apana.org.au>
 <CAHk-=wj2t+GK+DGQ7Xy6U7zMf72e7Jkxn4_-kGyfH3WFEoH+YQ@mail.gmail.com>
 <CAHk-=wgZcrb_vQi5rwpv+=wwG+68SRDY16HcqcMtgPFL_kdfyQ@mail.gmail.com>
 <20190603195304.GK28207@linux.ibm.com>
 <CAHk-=whXb-QGZqOZ7S9YdjvQf7FNymzceinzJegvRALqXm3=FQ@mail.gmail.com>
 <20190604211449.GU28207@linux.ibm.com>
 <20190605022117.kw6tldcwhdkyqd6u@gondor.apana.org.au>
 <20190605033039.GY28207@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605033039.GY28207@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 08:30:39PM -0700, Paul E. McKenney wrote:
>
> Understood.  Does the patch I sent out a few hours ago cover it?  Or is
> something else needed?

It looks good to me.

> Other than updates to the RCU requirements documentation, which is
> forthcoming.

Thanks Paul.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
