Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5B928EC9C
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 07:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgJOFXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 01:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgJOFXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 01:23:47 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84355C061755;
        Wed, 14 Oct 2020 22:23:47 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p9so2750691ilr.1;
        Wed, 14 Oct 2020 22:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Ncs+EAH2ueOioesEnjgFvMeFXMqAAQIuttjvHFPxfzM=;
        b=S0mD2F54RU9QL3KwFzXjscLr55UN3WllkODuuzZO9fO5TstH7I3ak7odZRM2kLR95D
         gBLR3GYTwxOwCpmjIOW/KIUy7dlXp1lHYJJC0NLz73oR1pfHDNsxX7QRSXZrZIKdwL0d
         DRnmIhj9Q8Bkyvlw88Xpu1xwzzO92h/UzrixAHB4XK+YTz2swUXB7Ur/H5rNAs2tu4In
         v9Evj4WGPSipCka6FblF4hXhJ3ujCD1asf295TzxBdFoodsKjeScEOE/0cOpqWYNkmJf
         0y5LI/mafga/u8yeAUsla9/We64hXNMK4uBywGRJbZILNnbthR2GlY94sOFN64kppWx9
         125w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Ncs+EAH2ueOioesEnjgFvMeFXMqAAQIuttjvHFPxfzM=;
        b=QZno9vNoJRlee5FpNG3YgNTSVx/h5o6trdGp0FiWeOU0w91Lgia1YtR/mcEIgsz+pW
         ucOzJwAZxOQKQou0qjpZQPSiUY065U8+FsATCjhKRFswnb+Lg71T487yyvfThNtC8n6H
         7xVaDwc2jMq2MUZW+ObySPKIk/QbXl61e6yAEqlgzvwO/2o21+F9HrAvLeAkbx1CoY/U
         SwG/q6orhNq0wcZc1eC0s7fY0AZXSvs5Avcm2akfd0dr/1yCX5OOtwF7WbSCcUxp7ggf
         zd9I2RuGR2vC8fjENyhe3ij3UDWSfdtBwl2pwHVB0mhxBrypxk4oHHrTPGEDy4O+7LHH
         b1og==
X-Gm-Message-State: AOAM533aX0qiS/a+I80IjQnKc9P3h1NW5hf3zOD2SlLuycKElsdbeKt8
        HU3HfciQMZ2SArRrtYof+Bg=
X-Google-Smtp-Source: ABdhPJz/tROP+hHqtLVbiuwtuvIrk9gBwL/XCBkAclDCF4NY0tmCqFeJghArmQwObLpV0EiTy6SXrw==
X-Received: by 2002:a92:da0e:: with SMTP id z14mr1903110ilm.151.1602739426871;
        Wed, 14 Oct 2020 22:23:46 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u3sm1812932ili.57.2020.10.14.22.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 22:23:46 -0700 (PDT)
Date:   Wed, 14 Oct 2020 22:23:39 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Message-ID: <5f87dcdb3dc75_feb9208b3@john-XPS-13-9370.notmuch>
In-Reply-To: <20201015043327.stqhrupw2adhd5hl@ast-mbp.dhcp.thefacebook.com>
References: <20201014175608.1416-1-alexei.starovoitov@gmail.com>
 <CAEf4BzaF2fDWoRg8h3dUKftvcastYqzEhGS2TG6MoV462fd_8Q@mail.gmail.com>
 <5f87ca47436f3_b7602088f@john-XPS-13-9370.notmuch>
 <20201015041952.n3crk6kvtbgev6rw@ast-mbp.dhcp.thefacebook.com>
 <5f87cfa5b1a77_b7602087e@john-XPS-13-9370.notmuch>
 <20201015043327.stqhrupw2adhd5hl@ast-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf-next] bpf: Fix register equivalence tracking.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Wed, Oct 14, 2020 at 09:27:17PM -0700, John Fastabend wrote:
> > Alexei Starovoitov wrote:
> > > On Wed, Oct 14, 2020 at 09:04:23PM -0700, John Fastabend wrote:
> > > > Andrii Nakryiko wrote:
> > > > > On Wed, Oct 14, 2020 at 10:59 AM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > > >
> > > > > > The 64-bit JEQ/JNE handling in reg_set_min_max() was clearing reg->id in either
> > > > > > true or false branch. In the case 'if (reg->id)' check was done on the other
> > > > > > branch the counter part register would have reg->id == 0 when called into
> > > > > > find_equal_scalars(). In such case the helper would incorrectly identify other
> > > > > > registers with id == 0 as equivalent and propagate the state incorrectly.
> > > > 
> > > > One thought. It seems we should never have reg->id=0 in find_equal_scalars()
> > > > would it be worthwhile to add an additional check here? Something like,
> > > > 
> > > >   if (known_reg->id == 0)
> > > > 	return
> > > >
> > > > Or even a WARN_ON_ONCE() there? Not sold either way, but maybe worth thinking
> > > > about.
> > > 
> > > That cannot happen anymore due to
> > > if (dst_reg->id && !WARN_ON_ONCE(dst_reg->id != other_branch_regs[insn->dst_reg].id))
> > > check in the caller.
> > > I prefer not to repeat the same check twice. Also I really don't like defensive programming.
> > > if (known_reg->id == 0)
> > >        return;
> > > is exactly that.
> > > If we had that already, as Andrii argued in the original thread, we would have
> > > never noticed this issue. <, >, <= ops would have worked, but == would be
> > > sort-of working. It would mark one branch instead of both, and sometimes
> > > neither of the branches. I'd rather have bugs like this one hurting and caught
> > > quickly instead of warm feeling of being safe and sailing into unknown.
> > 
> > Agree. Although a WARN_ON_ONCE would have also been caught.
> 
> Right. Such WARN_ON_ONCE would definitely have been nice either in the caller
> or in the callee. If I could have thought that id could be zero somehow here.
> In retrospect it makes sense that there is possibility that IDs of regs in
> this_branch and other_branch may diverge.
> Hence I'm adding the warn to check for this specific divergence.

LGTM thanks.
