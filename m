Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7DE3C7350
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 17:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbhGMPeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 11:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237131AbhGMPeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 11:34:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F20C0613E9;
        Tue, 13 Jul 2021 08:31:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1m3KNP-00017B-LO; Tue, 13 Jul 2021 17:31:15 +0200
Date:   Tue, 13 Jul 2021 17:31:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        syzbot <syzkaller@googlegroups.com>,
        kernel test robot <lkp@intel.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] audit: fix memory leak in nf_tables_commit
Message-ID: <20210713153115.GC11179@breakpoint.cc>
References: <20210713130344.473646-1-mudongliangabcd@gmail.com>
 <20210713132059.GB11179@breakpoint.cc>
 <CAD-N9QV7pt3PCzUK2r03aB_URU5Auu+quC+DJpc=46hjkceBNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD-N9QV7pt3PCzUK2r03aB_URU5Auu+quC+DJpc=46hjkceBNg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > +static void nf_tables_commit_free(struct list_head *adl)
> >
> > nf_tables_commit_audit_free?
> 
> What do you mean? Modify the name of newly added function to
> nf_tables_commit_audit_free?

Yes, this function is audit related, and it does the inverse
of existing '...audit_alloc'.
