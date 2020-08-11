Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464A7241B50
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 15:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgHKNAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 09:00:05 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35482 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbgHKNAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 09:00:03 -0400
Received: from madeliefje.horms.nl (unknown [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 3DE1225B73C;
        Tue, 11 Aug 2020 23:00:01 +1000 (AEST)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 1E5F7A93; Tue, 11 Aug 2020 14:59:59 +0200 (CEST)
Date:   Tue, 11 Aug 2020 14:59:59 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net-next v2] ipvs: Fix
 uninit-value in do_ip_vs_set_ctl()
Message-ID: <20200811125956.GA31293@vergenet.net>
References: <20200810220703.796718-1-yepeilin.cs@gmail.com>
 <20200811074640.841693-1-yepeilin.cs@gmail.com>
 <alpine.LFD.2.23.451.2008111324570.7428@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.23.451.2008111324570.7428@ja.home.ssi.bg>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 01:29:04PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Tue, 11 Aug 2020, Peilin Ye wrote:
> 
> > do_ip_vs_set_ctl() is referencing uninitialized stack value when `len` is
> > zero. Fix it.
> > 
> > Reported-by: syzbot+23b5f9e7caf61d9a3898@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?id=46ebfb92a8a812621a001ef04d90dfa459520fe2
> > Suggested-by: Julian Anastasov <ja@ssi.bg>
> > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> 
> 	Looks good to me, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Pablo, could you consider this for nf-next or should we repost when
net-next re-opens?

Reviewed-by: Simon Horman <horms@verge.net.au>

