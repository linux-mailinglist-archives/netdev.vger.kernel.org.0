Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF58040594D
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbhIIOmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239687AbhIIOmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:42:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8C9C0363C7;
        Thu,  9 Sep 2021 07:05:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mOKgF-0003zm-Hr; Thu, 09 Sep 2021 16:05:31 +0200
Date:   Thu, 9 Sep 2021 16:05:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzbot <syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        stable@vger.kernel.org, elbrus@debian.org
Subject: Re: [syzbot] general protection fault in nft_set_elem_expr_alloc
Message-ID: <20210909140531.GJ23554@breakpoint.cc>
References: <000000000000ef07b205c3cb1234@google.com>
 <20210602170317.GA18869@salvia>
 <YTkj4xH2Ol075+Ge@eldamar.lan>
 <YTmnpquHt3+02t9k@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTmnpquHt3+02t9k@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Sep 08, 2021 at 10:58:11PM +0200, Salvatore Bonaccorso wrote:
> > So if I see it correctly the fix landed in ad9f151e560b ("netfilter:
> > nf_tables: initialize set before expression setup") in 5.13-rc7 and
> > landed as well in 5.12.13. The issue is though still present in the
> > 5.10.y series.
> > 
> > Would it be possible to backport the fix as well to 5.10.y? It is
> > needed there as well.
> 
> I would need a working backport, as it does not apply cleanly to 5.10.y
> :(

Done, sent to stable@.
