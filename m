Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87F1255EF8
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 18:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgH1QqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 12:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbgH1QqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 12:46:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E587C061264;
        Fri, 28 Aug 2020 09:46:18 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kBhVf-0002Bi-5F; Fri, 28 Aug 2020 18:45:51 +0200
Date:   Fri, 28 Aug 2020 18:45:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Will McVicker <willmcvicker@google.com>, stable@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 1/1] netfilter: nat: add a range check for l3/l4
 protonum
Message-ID: <20200828164551.GG7319@breakpoint.cc>
References: <20200804113711.GA20988@salvia>
 <20200824193832.853621-1-willmcvicker@google.com>
 <20200824193832.853621-2-willmcvicker@google.com>
 <20200828164234.GA30990@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200828164234.GA30990@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Will,
> 
> Given this is for -stable maintainers only, I'd suggest:
> 
> 1) Specify what -stable kernel versions this patch applies to.
>    Explain that this problem is gone since what kernel version.
> 
> 2) Maybe clarify that this is only for stable in the patch subject,
>    e.g. [PATCH -stable v3] netfilter: nat: add a range check for l3/l4

Hmm, we silently accept a tuple that we can't really deal with, no?

> > +	if (l3num != NFPROTO_IPV4 && l3num != NFPROTO_IPV6)
> > +		return -EOPNOTSUPP;

I vote to apply this to nf.git

