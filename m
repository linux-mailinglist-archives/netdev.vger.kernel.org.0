Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8B5717A53F
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgCEM26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:28:58 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51276 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726007AbgCEM26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:28:58 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j9pcV-0007kU-M6; Thu, 05 Mar 2020 13:28:55 +0100
Date:   Thu, 5 Mar 2020 13:28:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: free flowtable hooks on hook
 register error
Message-ID: <20200305122855.GJ979@breakpoint.cc>
References: <20200302205850.29365-1-fw@strlen.de>
 <20200305120931.poeox6r3rapcbujb@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305120931.poeox6r3rapcbujb@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Mar 02, 2020 at 09:58:50PM +0100, Florian Westphal wrote:
> > If hook registration fails, the hooks allocated via nft_netdev_hook_alloc
> > need to be freed.
> > 
> > We can't change the goto label to 'goto 5' -- while it does fix the memleak
> > it does cause a warning splat from the netfilter core (the hooks were not
> > registered).
> 
> It seems test/shell crashes after this, looking. It works after
> reverting.

Sorry about that.  Let me know if you want me to look into this.
