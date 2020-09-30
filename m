Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D32C27DEC1
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 05:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgI3DSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 23:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgI3DSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 23:18:13 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08701C061755;
        Tue, 29 Sep 2020 20:18:13 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z19so179793pfn.8;
        Tue, 29 Sep 2020 20:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3O6tylxVVqIM6ry5U4hu4RAHJk9JYfiTYQ+xk4dycX8=;
        b=otjCrOL8/SpywpOuRhM3PIj4bZSJJxcRO+gmBTVxcuFnfW5JxKLYGF53kx+fpl6uVw
         Fi0DARE9WYc4yoFsA9ea3PDgUscR6UA+zsKxVM+EvHXrg8ZefPKbSHYBE+CFGxnDYCXo
         OccsCHWEGU4R1cZMIr4mdKrDVhj6JiG1QVM0mm0dltGpDTWgoXAKpdsuRhnjwD41msg4
         b2yz6q+0ZP49S5F3S2uNnMU09ArKechV6XsFsfndlQfpC9kUV9+fqgDd55YGeMNKwEhY
         A7ruLcG9UelbkgcNDkrWQvvuPBfYIk5Jp+vWm/OfmXNzqmweTw34pnsDYvIiQjQFj50b
         aQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3O6tylxVVqIM6ry5U4hu4RAHJk9JYfiTYQ+xk4dycX8=;
        b=ESQiJR2B0HM7bC1aK1pecGuVqp3xrcyTlABkhRgpBLZTebtPujxYYM9yFJ65EENIhm
         9N5RS5cr8L9hro/fIaCtNy7pF9s0s7DoN9wA07njxA1mFPj5beMVtqEPgAmuTxR3Sj6B
         D8v+Y15AF1lqtU1SyyXgDSlddqS/DqLx65WtVTacvnMqOtWLwBYF7wuKI0DSTPDnKhI1
         K7EGdv6hIB6SHn8vqEL3FsVZLi6fDCh7gRVBiFnotNqb//tc4eayv/FeBmB6XcD8ON7A
         MrxjhFqBeVeESwd1uxX+JQSTyrLVzI0mUhM/T9sZr0/p1LJ6Nj8kUJ+cFHrsZdfA3BrB
         xRNg==
X-Gm-Message-State: AOAM533fkF/xk0FjSBLYSW2fYfY3616XvdVwy6Gzk62M6CNvjSenxlZa
        PWIpd+7eJdwjhmhrLiZteS7SJ8LVPbk=
X-Google-Smtp-Source: ABdhPJwq3eOJJDOgGbBCODQOi9+1p7GEZn7QuwgUUojYJLlrE3lzQh+q0SiJpLpTrRt+h7laSNg0ZQ==
X-Received: by 2002:a62:52d3:0:b029:142:2501:35ee with SMTP id g202-20020a6252d30000b0290142250135eemr731124pfb.78.1601435892415;
        Tue, 29 Sep 2020 20:18:12 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2bde])
        by smtp.gmail.com with ESMTPSA id j10sm168182pfc.168.2020.09.29.20.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 20:18:11 -0700 (PDT)
Date:   Tue, 29 Sep 2020 20:18:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/4] libbpf: add raw BTF type dumping
Message-ID: <20200930031809.lto7v7e7vtyivjon@ast-mbp.dhcp.thefacebook.com>
References: <20200929232843.1249318-1-andriin@fb.com>
 <20200930000329.bfcrg6qqvmbmlawk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYByimHd+FogxVHdq2-L_GLjdGEa_ku7p_c1V-hpyJrWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYByimHd+FogxVHdq2-L_GLjdGEa_ku7p_c1V-hpyJrWA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 05:44:48PM -0700, Andrii Nakryiko wrote:
> On Tue, Sep 29, 2020 at 5:03 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Sep 29, 2020 at 04:28:39PM -0700, Andrii Nakryiko wrote:
> > > Add btf_dump__dump_type_raw() API that emits human-readable low-level BTF type
> > > information, same as bpftool output. bpftool is not switched to this API
> > > because bpftool still needs to perform all the same BTF type processing logic
> > > to do JSON output, so benefits are pretty much zero.
> >
> > If the only existing user cannot actually use such api it speaks heavily
> > against adding such api to libbpf. Comparing strings in tests is nice, but
> > could be done with C output just as well.
> 
> It certainly can, it just won't save much code, because bpftool would
> still need to have a big switch over BTF type kinds to do JSON output.

So you're saying that most of the dump_btf_type() in bpftool/btf.c will stay as-is.
Only 'if (json_output)' will become unconditional? Hmm.
I know you don't want json in libbpf, but I think it's the point of
making a call on such things. Either libbpf gets to dump both
json and text dump_btf_type()-like output or it stays with C only.
Doing C and this text and not doing json is inconsistent.
Either libbpf can print btf in many different ways or it stays with C.
2nd format is not special in any way.
I don't think that text and json formats bring much value comparing to C,
so I would be fine with C only. But if we allow 2nd format we should
do json at the same time too to save bpftool the hassle.
And in the future we should allow 4th and 5th formats.
