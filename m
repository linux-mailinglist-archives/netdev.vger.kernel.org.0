Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AA728C3BF
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 23:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732085AbgJLVDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 17:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730845AbgJLVDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 17:03:10 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F67C0613D0;
        Mon, 12 Oct 2020 14:03:10 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id o3so5594153pgr.11;
        Mon, 12 Oct 2020 14:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mL58EEBYBfzBm/sWpTxkhiJ2mB3L4QfDQl4WPIpN03g=;
        b=jpFoBmShBddFvBl6seKqLzZ3/KIAU5dtm+ieEuCzZ14y48VVy6owKrJiERjBvTIO05
         jypkmsZwoVjESPo6kzHlBf9ZZvdn2tbDygmc7dCRBRXLqErr84WSssHaq0kJ2zm5u5v1
         d5i/XfxbyHyCwqFvMbQrlqzUAwZ/Nku4l/OIBhja5z++pkuivbCeICz9ETT4XVi6gq7E
         Wkj7DfWVRlFpraDlNrvTB55XZI45Q0RanjElD3/3ZsdvpoAfDNB0hUN41V2yqQnv6wCu
         B5JRxxZS5CVuDWfWDA2eRfhElgreok99lJjzAp8eWPPK3EGGUoAaiB3V+vwipdfbob2G
         RWYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mL58EEBYBfzBm/sWpTxkhiJ2mB3L4QfDQl4WPIpN03g=;
        b=UzMGZTpcBqpCaUphuYBMRQMWjoDSifGjlVc71MY5VgHfbMh0aWAkWirF6dLRMCBoRq
         DPH3kVK9qLfqSD/wEDs7UkTKn5zgTQfFxd+bibgwxHeI5Kv1jOJMHuVJAuhpA19veyjd
         RvzB5xqqf1wprYVNttrkfq7gsSYe23NrWUhSLUojx55paTi6zrrm9SGduXHy2g9IGjuH
         2DhLLsQLr0AEcoAGqDOORdlyimOX6INTyN7Mu/QPvDlS44LVlMxOT/tr6prEzUvC+pwd
         H/huAsjfdaikh0LzosbzWGGxcANi7Teu7BDQDGhrpHOkHZt3REsY2RYSQsebph9VxXet
         pKrA==
X-Gm-Message-State: AOAM533NrotHrmsnYLERY7lVVycPdkFEeInQSTaYS7Cn5TVBRz3bvhUv
        OjbZ4KPRtHwzAegytqZ8hsg=
X-Google-Smtp-Source: ABdhPJxOFyn4ESDYHTTBV2FZ5Hw5w8NUOWgRRrCG7GkZ4Nr3hKAstsJlMv0rMHcodm4+BKf3AXgNOQ==
X-Received: by 2002:a62:e81a:0:b029:152:97f9:9775 with SMTP id c26-20020a62e81a0000b029015297f99775mr24025149pfi.29.1602536590054;
        Mon, 12 Oct 2020 14:03:10 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:41ef])
        by smtp.gmail.com with ESMTPSA id s11sm21410763pgm.36.2020.10.12.14.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 14:03:09 -0700 (PDT)
Date:   Mon, 12 Oct 2020 14:03:07 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: merge window is open. bpf-next is still open.
Message-ID: <20201012210307.byn6jx7dxmsxq7dt@ast-mbp>
References: <CAADnVQ+ycd8T4nBcnAwr5FHX75_JhWmqdHzXEXwx5udBv8uwiQ@mail.gmail.com>
 <20201012110046.3b2c3c27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQKn=CxcOpjSWLsD+VC5rviC6sMfrhw5jrPCU60Bcx5Ssw@mail.gmail.com>
 <20201013075016.61028eee@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013075016.61028eee@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 07:50:16AM +1100, Stephen Rothwell wrote:
> Hi Alexei,
> 
> On Mon, 12 Oct 2020 13:15:16 -0700 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > You mean keep pushing into bpf-next/master ?
> > The only reason is linux-next.
> > But coming to think about it again, let's fix linux-next process instead.
> > 
> > Stephen,
> > could you switch linux-next to take from bpf.git during the merge window
> > and then go back to bpf-next.git after the merge window?
> > That will help everyone. CIs wouldn't need to flip flop.
> > People will keep basing their features on bpf-next/master all the time, etc.
> > The only inconvenience is for linux-next. I think that's a reasonable trade-off.
> > In other words bpf-next/master will always be open for new features.
> > After the merge window bpf-next/master will get rebased to rc1.
> 
> I already fetch bpf.git#master all the time (that is supposed to be
> fixes for the current release and gets merged into the net tree, right?)

Correct. That part doesn't change.

> How about this: you create a for-next branch in the bpf-next tree and I
> fetch that instead of your master branch.  What you do is always work
> in your master branch and whenever it is "ready", you just merge master
> into for-next and that is what linux-next works with (net-next still
> merges your master branch as now).  So the for-next branch consists
> only of consecutive merges of your master branch.
> 
> During the merge window you do *not* merge master into for-next (and,
> in fact, everything in for-next should have been merged into the
> net-next tree anyway, right?) and then when -rc1 is released, you reset
> for-next to -rc1 and start merging master into it again.
> 
> This way the commit SHA1s are stable and I don't have to remember to
> switch branches/trees every merge window (which I would forget
> sometimes for sure :-)).

That is a great idea! I think that should work well for everyone.
Let's do exactly that.
Just pushed bpf-next/for-next branch.

I'll send a patch to update Documentation/bpf/bpf_devel_QA.rst
with all these details later today.
