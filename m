Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C9E40D1CD
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 04:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbhIPC5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 22:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbhIPC5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 22:57:54 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0431FC061574;
        Wed, 15 Sep 2021 19:56:35 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id bb10so2907474plb.2;
        Wed, 15 Sep 2021 19:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fDbty3X6PjXQk9kZXNvjU2um8uADDEM/hj8s/kO/1fY=;
        b=m/VsWonWDOc9UQ8WvnsZYdTM2022NM8Z9WqHKdHNmD2ChWCbZcmL1ranNcdp1tm/NI
         pFgOdwa7sfkz0vfsr9hBnLbHRsQGI+EQNa1cBPKMvj2gni/IPEBkbytjQzi48RlFwZQg
         +/tiF7ISk9F2cC2S7wzrsqTf2nZTn4B5l1AmNMO4HWydyX+j3gmhtm+jgF13/8gEmS99
         qW9mHDqiyuE4CBevdkc+DUnfUEqzLWmJtCy2cvTVuhkdLQIqGSf9m2L7QWDpuyGtlqOw
         htQhZHcNvDEe4SShZPR0LUtCoyBml/fHNLuY9CK8aOAuM2WgwM1SL73yBGl67SIJGudV
         pEbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fDbty3X6PjXQk9kZXNvjU2um8uADDEM/hj8s/kO/1fY=;
        b=HU36v4od01pnIlXiGaVCR18/z8IaU/Uu2rnlsADQkFoMsGh0w8AKU9gHqea1eny/Lg
         i3n3dwNHj0/IjneI4LI6lqYvAIk56AmkrC8ECakm9/UiFHmRCqbonRQDqb3mMWBVTBor
         z5fXSWq1DMn7c9zm2AvHesbrR/RHuXHOPkDH4gS/+dO4o3v60VHxiTkCB75GkFsILw9s
         Avq2RZH/rhu77YWpXWNgCioGmqyd6XVOsmGQaNwIitgXoyPCqIOiMZFe3WiLLoIbKRyT
         heHOP8jo3c29q8z9m/OT2fvvH3+K0oQdfRReCC2OyIzqqik3ZyVbin7hSPxEk1vBYjyj
         D4OQ==
X-Gm-Message-State: AOAM533IXo/T2bSxmgC7g6XDY4AgInHvKfFQVbCcVcWhKvVVvAUDvcrC
        6I8LMUwxv7zkQGB5MCPJvGcicufZXi0DR0uT22U=
X-Google-Smtp-Source: ABdhPJzx8MlTPW34SH7s5vqScracHGE3DklBK7iem/dniyMbLroalYAQtfAjjSEw3uWj/wn+0DeAgOmNWw4yymxyQ2s=
X-Received: by 2002:a17:90a:1944:: with SMTP id 4mr1912756pjh.62.1631760994407;
 Wed, 15 Sep 2021 19:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210915050943.679062-1-memxor@gmail.com> <20210915050943.679062-7-memxor@gmail.com>
 <20210915163353.ysltf6edghj75koq@ast-mbp.dhcp.thefacebook.com> <20210915175722.viwvzg4ilpumqxid@apollo.localdomain>
In-Reply-To: <20210915175722.viwvzg4ilpumqxid@apollo.localdomain>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 15 Sep 2021 19:56:23 -0700
Message-ID: <CAADnVQKq7DkttVGY9r6vgyhrTDUufytuvTQUaD3iaduDZxmXWQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 06/10] bpf: Bump MAX_BPF_STACK size to 768 bytes
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 10:57 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, Sep 15, 2021 at 10:03:53PM IST, Alexei Starovoitov wrote:
> > On Wed, Sep 15, 2021 at 10:39:39AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > Increase the maximum stack size accessible to BPF program to 768 bytes.
> > > This is done so that gen_loader can use 94 additional fds for kfunc BTFs
> > > that it passes in to fd_array from the remaining space available for the
> > > loader_stack struct to expand.
> > >
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> > >  include/linux/filter.h | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > > index 4a93c12543ee..b214189ece62 100644
> > > --- a/include/linux/filter.h
> > > +++ b/include/linux/filter.h
> > > @@ -82,8 +82,8 @@ struct ctl_table_header;
> > >   */
> > >  #define BPF_SYM_ELF_TYPE   't'
> > >
> > > -/* BPF program can access up to 512 bytes of stack space. */
> > > -#define MAX_BPF_STACK      512
> > > +/* BPF program can access up to 768 bytes of stack space. */
> > > +#define MAX_BPF_STACK      768
> >
> > Yikes.
> > I guess you meant as RFC, right? You didn't really propose
> > to increase prog stack size just for that, right?
> >
>
> Yes, and right, it's ugly :/.
>
> > In the later patch:
> > +/* MAX_BPF_STACK is 768 bytes, so (64 + 32 + 94 (MAX_KFUNC_DESCS) + 2) * 4 */
> >  #define MAX_USED_MAPS 64
> >  #define MAX_USED_PROGS 32
> >
> > @@ -31,6 +33,8 @@ struct loader_stack {
> >         __u32 btf_fd;
> >         __u32 map_fd[MAX_USED_MAPS];
> >         __u32 prog_fd[MAX_USED_PROGS];
> > +       /* Update insn->off store when reordering kfunc_btf_fd */
> > +       __u32 kfunc_btf_fd[MAX_KFUNC_DESCS];
> >         __u32 inner_map_fd;
> > };
> >
> > There are few other ways to do that.
> > For example:
> > A: rename map_fd[] into fds[] and store both map and btf FDs in there.
> > B: move map and btf FDs into data instead of stack.
>
> Both are great suggestions, I thought about A but not B, but it will be better
> (even though it requires more changes, we can do full 256 BTF fds using B).
> Thanks!

btw fd_array doesn't have to have valid FDs in all slots
when passed into the prog_load command.
If bpf prog doesn't index into them they can have garbage.
Just mentioning in case that simplifies the implementation.
I suspect packing btf_fds right after map_fds with no gaps will not be
hard to do, but in case it's somehow too painful there could be a gap.
