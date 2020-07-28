Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908EA230081
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 06:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgG1EOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 00:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgG1EOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 00:14:22 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8247DC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 21:14:22 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i92so2424292pje.0
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 21:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=FsbzyHuLlFDeS6fQBkytWIroOBu0uC4CeVcTAyX6GOk=;
        b=uX1G0BnG6iQJ454mtFM+Vr0VB7V417z6ebG7d0HiewWc9IsWVjgKLZ3Sf3jscb4KhC
         oebFzp1imie3zxmWR1gSxK2CPhxIDoWY/1B6JZopOO8QXS9UgXQz3eg5viTEEQSf3wF2
         /y4KXb+VseEgpOLfI5d3rInqek49Dek5rnS/T9pSqnXvxztTkP/4Hes37BUdzRIrBDNp
         DFZIswzWZaPMSibzJc3jShs98hfeD+LpCim6fckWt4BgUczUbWKiw2i4f+/gSMhAsDGe
         bosWAcbJEPKC0BitIvN4ImjF4TMIdEfX+woSHFY0Nvtf2NsJQhSx4TUWX2WHdRb0auE0
         dJLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=FsbzyHuLlFDeS6fQBkytWIroOBu0uC4CeVcTAyX6GOk=;
        b=SP9Bm2xJWVmhDjfRFS20NFQ8eC8kOsFRFHlLZOL9PjEF/TWfEDnDEl7turDPcXJ1+1
         E8KL2APZTn5KqLgUvSyifMn/zYWjVO27RCWu6HuTUhnEw4ILgjios0FY/pNoBCct7m0E
         eCnzXJPKlqfouwbcqLw06bH5RSoHPcmy8VvgR8MQZiCjoNwd7n4EV9fs7zf5QHfkIgaS
         jHDqENeMPMOI17NU4D1uXc+rTjLhpyO3T/jumHI0ICLpKkE1p6q7f6Cx4bjLU4GLhmQ8
         W8boFW8Ut2/AbSkW+vnqYMXeTUA4wVXK5eVashfD/er2NPKtTkdLXelmim1kmwjmTXBr
         yQeA==
X-Gm-Message-State: AOAM531i9lCTElAuFpBSuqSFFfl2FF4MQ8oG+9mCSu13Bs37EJK4kfWU
        T08h6WYPsUVn6VcEDvTSG4c=
X-Google-Smtp-Source: ABdhPJzFA5NlNm7dHTWVfxzTmcsgvnDl/rmNTwyHCwvzVx2fnqTkyxa9doSa1s6MAN/frFo8OK73tQ==
X-Received: by 2002:a17:90a:9f84:: with SMTP id o4mr2359492pjp.200.1595909662029;
        Mon, 27 Jul 2020 21:14:22 -0700 (PDT)
Received: from nebula (035-132-134-040.res.spectrum.com. [35.132.134.40])
        by smtp.gmail.com with ESMTPSA id ml8sm1115505pjb.47.2020.07.27.21.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 21:14:21 -0700 (PDT)
Message-ID: <8c65e650bf9a8a77a8ea967cb52e2f2407dcbc24.camel@gmail.com>
Subject: Re: Question Print Formatting iproute2
From:   Briana Oursler <briana.oursler@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Petr Machata <petrm@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>
Date:   Mon, 27 Jul 2020 21:14:07 -0700
In-Reply-To: <20200727164714.6ee94a11@hermes.lan>
References: <20200727044616.735-1-briana.oursler@gmail.com>
         <20200727164714.6ee94a11@hermes.lan>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-07-27 at 16:47 -0700, Stephen Hemminger wrote:
> On Sun, 26 Jul 2020 21:46:16 -0700
> Briana Oursler <briana.oursler@gmail.com> wrote:
> 
> > I have a patch I've written to address a format specifier change
> > that
> > breaks some tests in tc-testing, but I wanted to ask about the
> > change
> > and for some guidance with respect to how formatters are approached
> > in
> > iproute2. 
> > 
> > On a recent run of tdc tests I ran ./tdc.py -c qdisc and found:
> > 
> > 1..91
> > not ok 1 8b6e - Create RED with no flags
> >         Could not match regex pattern. Verify command output:
> > qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kb
> > 
> > not ok 2 342e - Create RED with adaptive flag
> >         Could not match regex pattern. Verify command output:
> > qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbadaptive
> > 
> > not ok 3 2d4b - Create RED with ECN flag
> >         Could not match regex pattern. Verify command output:
> > qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn
> > 
> > not ok 4 650f - Create RED with flags ECN, adaptive
> >         Could not match regex pattern. Verify command output:
> > qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn
> > adaptive
> > 
> > not ok 5 5f15 - Create RED with flags ECN, harddrop
> >         Could not match regex pattern. Verify command output:
> > qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn
> > harddrop
> > 
> > not ok 6 53e8 - Create RED with flags ECN, nodrop
> >         Could not match regex pattern. Verify command output:
> > qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn nodrop
> > 
> > ok 7 d091 - Fail to create RED with only nodrop flag
> > not ok 8 af8e - Create RED with flags ECN, nodrop, harddrop
> >         Could not match regex pattern. Verify command output:
> > qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn
> > harddrop
> > nodrop
> > 
> > I git bisected and found d0e450438571("tc: q_red: Add support for
> > qevents "mark" and "early_drop"), the commit that introduced the
> > formatting change causing the break. 
> > 
> > -       print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt-
> > >qth_max, b3));
> > +       print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt-
> > >qth_max, b3));
> > 
> > I made a patch that adds a space after the format specifier in the
> > iproute2 tc/q_red.c and tested it using: tdc.py -c qdisc. After the
> > change, all the broken tdc qdisc red tests return ok. I'm including
> > the
> > patch under the scissors line.
> > 
> > I wanted to ask the ML if adding the space after the specifier is
> > preferred usage.
> > The commit also had: 
> >  -               print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt-
> > >Wlog);
> >  +               print_uint(PRINT_ANY, "ewma", " ewma %u ", qopt-
> > >Wlog);
> > 
> > so I wanted to check with everyone.
> > 
> > Thanks 
> > > 8--------------------------------------------------------------
> > > ----------8<  
> > From 1e7bee22a799a320bd230ad959d459b386bec26d Mon Sep 17 00:00:00
> > 2001
> > Subject: [RFC iproute2-next] tc: Add space after format specifier
> > 
> > Add space after format specifier in print_string call. Fixes broken
> > qdisc tests within tdc testing suite.
> > 
> > Fixes: d0e450438571("tc: q_red: Add support for
> > qevents "mark" and "early_drop")
> > 
> > Signed-off-by: Briana Oursler <briana.oursler@gmail.com>
> > ---
> >  tc/q_red.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tc/q_red.c b/tc/q_red.c
> > index dfef1bf8..7106645a 100644
> > --- a/tc/q_red.c
> > +++ b/tc/q_red.c
> > @@ -222,7 +222,7 @@ static int red_print_opt(struct qdisc_util *qu,
> > FILE *f, struct rtattr *opt)
> >  	print_uint(PRINT_JSON, "min", NULL, qopt->qth_min);
> >  	print_string(PRINT_FP, NULL, "min %s ", sprint_size(qopt-
> > >qth_min, b2));
> >  	print_uint(PRINT_JSON, "max", NULL, qopt->qth_max);
> > -	print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt-
> > >qth_max, b3));
> > +	print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt-
> > >qth_max, b3));
> >  
> >  	tc_red_print_flags(qopt->flags);
> >  
> > 
> > base-commit: 1ca65af1c5e131861a3989cca3c7ca8b067e0833
> 
> Looks fine, please resend a normal patch targeted at current iproute2
> not next.
> 
Will do, thank you.

