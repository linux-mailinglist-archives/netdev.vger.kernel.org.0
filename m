Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF5F4930D0
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350006AbiARWd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349995AbiARWdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:33:25 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37360C06161C;
        Tue, 18 Jan 2022 14:33:25 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id r11so514493pgr.6;
        Tue, 18 Jan 2022 14:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pQm7tI+BDw0i+hvexd46cMO7zhTpMqKt4y3N3SOm06M=;
        b=CT/Z8gGlECkmnVwk9UXeh3Bq+y1+sDRR7P92BQ2IzrzjFOwGMqOnTQ1265G5UbHhvw
         u7ncbe27R/h8uowF4WwyeVoBuAqgf8AsBwpIgiVCvTdXGOVskZ65XrDEL/6kMocsQbay
         Fh0mJQ2F9W6wdPPN0nFzpK2MkdScHWUeuql5R2RKDi91yL8KK/hpPzbTfpdJ6h3TqtB4
         5j2kKZmoArdLybbVMqxU3YB9+XIV5i1fTmf+VDg3jjHtS0wAf8xr0qtoDv0hX76PRzI8
         SiSl9xD0BN3rPqZVTm3vAvpgfmblCqbYpMkHa537VE/Uw+DrrEiZYEAC7+KtNt1nRy3h
         knBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pQm7tI+BDw0i+hvexd46cMO7zhTpMqKt4y3N3SOm06M=;
        b=xbTUNRpauP+6ggw9OkII709lg2wRMIrMinguo59kxkj7xNkPThGSZZUip6PpM1BCg/
         yUkQh1agpvgFD+RBJrChR7onqZF5zziEdN5+6aHypG+7MqZ3SKhX4ePvEQKLTR3f0bUm
         KpC2ctDqu9/y5837AaIEx82xKsJUm8wtE5PF+lhsZBI+OhwSHh7qERIhvdR1sAv4jJxi
         LrmohFHl8Te6Ni1+yo2OcUISGdF0OHZA8iIHyYJrG/Z98TIZFmPeom5UysGnaoB7yopR
         9fwTA9yxbe3sLsy6qYVjSZwM2+qf9fLMxIEMQhp9ocmDsJ7rGDtTnRU6CyOgrROIES4e
         PTzw==
X-Gm-Message-State: AOAM532+MbCsVCLEZkEUS5WsGnfiAB8zcYwz5C3zoQwseYa+TRR0VLKN
        DuSdELlff5hDQ+rVOHulSZ3kQSYVPCje/ClYXvM=
X-Google-Smtp-Source: ABdhPJzNgpkSaSkRctkC9F5Xn1FKsqXhRjEYOQAlPLuwryEy5mwRj1v7uyKx8vEM5vZkMcCp/AUzel/iD36rFSZ07qc=
X-Received: by 2002:a63:1ca:: with SMTP id 193mr24337693pgb.497.1642545204714;
 Tue, 18 Jan 2022 14:33:24 -0800 (PST)
MIME-Version: 1.0
References: <cover.1642439548.git.lorenzo@kernel.org> <c2bdc436abe8e27a46aa8ba13f75d24f119e18a4.1642439548.git.lorenzo@kernel.org>
 <20220118201449.sjqzif5qkpbu5tqx@ast-mbp.dhcp.thefacebook.com> <Yec/qu7idEImzqxc@lore-desk>
In-Reply-To: <Yec/qu7idEImzqxc@lore-desk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Jan 2022 14:33:13 -0800
Message-ID: <CAADnVQJgKVQ8vNfiazTcNbZVFTb2x=7G1WUda7O+LHM8Hs=KCw@mail.gmail.com>
Subject: Re: [PATCH v22 bpf-next 18/23] libbpf: Add SEC name for xdp
 multi-frags programs
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 2:31 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > On Mon, Jan 17, 2022 at 06:28:30PM +0100, Lorenzo Bianconi wrote:
> > > Introduce support for the following SEC entries for XDP multi-frags
> > > property:
> > > - SEC("xdp.frags")
> > > - SEC("xdp.frags/devmap")
> > > - SEC("xdp.frags/cpumap")
> > >
> > > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index fdb3536afa7d..611e81357fb6 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -6562,6 +6562,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
> > >     if (def & SEC_SLEEPABLE)
> > >             opts->prog_flags |= BPF_F_SLEEPABLE;
> > >
> > > +   if (prog->type == BPF_PROG_TYPE_XDP && strstr(prog->sec_name, ".frags"))
> > > +           opts->prog_flags |= BPF_F_XDP_HAS_FRAGS;
> >
> > That's a bit sloppy.
> > Could you handle it similar to SEC_SLEEPABLE?
> >
> > > +
> > >     if ((prog->type == BPF_PROG_TYPE_TRACING ||
> > >          prog->type == BPF_PROG_TYPE_LSM ||
> > >          prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
> > > @@ -8600,8 +8603,11 @@ static const struct bpf_sec_def section_defs[] = {
> > >     SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
> > >     SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
> > >     SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> > > +   SEC_DEF("xdp.frags/devmap",     XDP, BPF_XDP_DEVMAP, SEC_NONE),
> > >     SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
> > > +   SEC_DEF("xdp.frags/cpumap",     XDP, BPF_XDP_CPUMAP, SEC_NONE),
> > >     SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
> > > +   SEC_DEF("xdp.frags",            XDP, BPF_XDP, SEC_NONE),
> >
> > It would be SEC_FRAGS here instead of SEC_NONE.
>
> ack, I dropped SEC_FRAGS (SEC_XDP_MB before) from sec_def_flags because Andrii asked to remove
> it but I am fine to add it back. Agree?

Andrii,
what was the motivation?
imo that's cleaner than strstr.
