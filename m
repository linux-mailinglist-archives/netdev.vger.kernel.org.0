Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAE92DD90F
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 20:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgLQTEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 14:04:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgLQTEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 14:04:49 -0500
Date:   Thu, 17 Dec 2020 11:04:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608231848;
        bh=IWh9rfBfOUS1KgAttcRDjgUAsO5g+Nk+2U6E9a5FxRE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=nsCosS/3CsRxZGCnWjZymXdnMdg+h/bHz9XIq8bDpXoXn9wUQchijgtEAKEOOqWyk
         4GKdrEQjFgMkQYmOMPXHak41kC2TrNlOYLdB6yCmk+0Pn4gpXg695x4R6D7+1+Py0K
         Jar6mpn117X/Pl1RHqvTOGJ6MSTkbL9M/nCKjdW8t5CjOyvvoYEmvnUPAZ6Yb7KOvr
         G4R14CxbnRKLBx6/2DgeONguyyyM5p3maHdFk76xW6DzDvrZp03IMPG9zRsMp6FZiC
         R76HvW7QXvlQEuIuGRgMW5u7ve82RWFXTOLR50uLrh5r0eTSa3Uo/3kltoUj0A1wWq
         HGfHc1b8P+g+g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: sch_taprio: reset child qdiscs before
 freeing them
Message-ID: <20201217110407.31a38d16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87o8itzial.fsf@vcostago-mobl2.amr.corp.intel.com>
References: <63b6d79b0e830ebb0283e020db4df3cdfdfb2b94.1608142843.git.dcaratti@redhat.com>
        <87o8itzial.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 11:01:54 -0800 Vinicius Costa Gomes wrote:
> Davide Caratti <dcaratti@redhat.com> writes:
> 
> > syzkaller shows that packets can still be dequeued while taprio_destroy()
> > is running. Let sch_taprio use the reset() function to cancel the advance
> > timer and drop all skbs from the child qdiscs.
> >
> > Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
> > Link: https://syzkaller.appspot.com/bug?id=f362872379bf8f0017fb667c1ab158f2d1e764ae
> > Reported-by: syzbot+8971da381fb5a31f542d@syzkaller.appspotmail.com
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
>
> Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Applied thanks.
