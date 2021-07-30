Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EBB3DC0D0
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 00:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhG3WLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 18:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhG3WLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 18:11:10 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7E8C06175F;
        Fri, 30 Jul 2021 15:11:03 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id p145so3701274ybg.6;
        Fri, 30 Jul 2021 15:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gy6aaEgXbSu9KGGga75zDYxnS5YDlkSnlw9hzsWsunM=;
        b=mV6KsIc0y6NaIKGphIW9qdN2V4jvWlcl5lcxuZO0uXn56bX5F39P3uhlgPeXlJUnnF
         HJ5tnVvy/nThjWkk+/kkANrCoPNw1uc+MSChjtlsEFCSH2PAARcKqYPiSq9C6aWMTyaJ
         dSaDbnq9rSxiEaie65bHWXutObY0ggL+Qi9EtI1yKDzSr7/QPEqWcQGyVMN86wLlYJfP
         ji5S3fTdeb0xrfiVgMZ7xpnMo7FbxGWP74mDAyiXoJm2yb2y80+SYBr3Avb+w7tLVEFH
         X4a4qF7Y9KllYQFAGAI+CF97o5W2rF5S6/4NeQGcfKwib5q0DSzHlP+PqhplODEof/0N
         xN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gy6aaEgXbSu9KGGga75zDYxnS5YDlkSnlw9hzsWsunM=;
        b=sp/ZGAW5zc0yKUuK4SqhLIwW9Qeoqw+Z579ONvucLlB8oqGPPNWTZ/h+SZ3ImMYW2U
         qWwAWhGD7bHGQqlDA/f5dN7WNS1beBG0qOKTqRjeaWop5p/zzE4dGoFWkik8pcKR/faG
         SVqPrlaC5mHKNvmbN0ULgPWE0WqiZrTN9MKfQccVb0WIBEdbdBTbXpn+DUl3MbBBDfX1
         CsobSsM0gb/6xK5dWsb/b/Sq2sw0g9awP1UX8+8g/Durm1ach/CWQ4QfBWCK6nhOFPXe
         ubEwhtvu7963JSkwIQtx8+haoin3xstj/GbBin2rpNPfVZ0pG/w9l/k0sYesb0xIkr4e
         zL7A==
X-Gm-Message-State: AOAM531U2gN9rYteOAezkhUWXw9gJ1MI4i0sCftbaPDOx00paGb9z7z0
        dpeD4bABuOKHwKeQmdFirMEe0F8hw1Ux8jjq9jw=
X-Google-Smtp-Source: ABdhPJzG9vVMPdcRjdMwNUw8pRO125bi5T58FNBkgMcoAxhCIM/15lkQP1EveBjxSMnIQdvcggxlXG9ASc1iKiXG7Zg=
X-Received: by 2002:a5b:648:: with SMTP id o8mr6203976ybq.260.1627683062981;
 Fri, 30 Jul 2021 15:11:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210729162932.30365-1-quentin@isovalent.com> <20210729162932.30365-7-quentin@isovalent.com>
 <CAEf4Bzb+s0f6ybq+qARTpe1wa2dOD_gweBd0kQAYh3cyx=N5mQ@mail.gmail.com> <4ad2073f-d528-788e-3222-85cd2c0fe5f9@isovalent.com>
In-Reply-To: <4ad2073f-d528-788e-3222-85cd2c0fe5f9@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Jul 2021 15:10:51 -0700
Message-ID: <CAEf4BzZn5w-nR9kvD-zU-BMLMRK3-KFVRJbGEarXmvs0WBK6uw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/7] tools: bpftool: document and add bash
 completion for -L, -B options
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 2:48 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-07-30 11:59 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Thu, Jul 29, 2021 at 9:29 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> The -L|--use-loader option for using loader programs when loading, or
> >> when generating a skeleton, did not have any documentation or bash
> >> completion. Same thing goes for -B|--base-btf, used to pass a path to a
> >> base BTF object for split BTF such as BTF for kernel modules.
> >>
> >> This patch documents and adds bash completion for those options.
> >>
> >> Fixes: 75fa1777694c ("tools/bpftool: Add bpftool support for split BTF")
> >> Fixes: d510296d331a ("bpftool: Use syscall/loader program in "prog load" and "gen skeleton" command.")
> >> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> >> ---
> >> Note: The second example with base BTF in the BTF man page assumes that
> >> dumping split BTF when objects are passed by id is supported. Support is
> >> currently pending review in another PR.
> >> ---
> >
> > Not anymore :)
> >
> > [...]
> >
> >> @@ -73,6 +74,20 @@ OPTIONS
> >>  =======
> >>         .. include:: common_options.rst
> >>
> >> +       -B, --base-btf *FILE*
> >> +                 Pass a base BTF object. Base BTF objects are typically used
> >> +                 with BTF objects for kernel modules. To avoid duplicating
> >> +                 all kernel symbols required by modules, BTF objects for
> >> +                 modules are "split", they are built incrementally on top of
> >> +                 the kernel (vmlinux) BTF object. So the base BTF reference
> >> +                 should usually point to the kernel BTF.
> >> +
> >> +                 When the main BTF object to process (for example, the
> >> +                 module BTF to dump) is passed as a *FILE*, bpftool attempts
> >> +                 to autodetect the path for the base object, and passing
> >> +                 this option is optional. When the main BTF object is passed
> >> +                 through other handles, this option becomes necessary.
> >> +
> >>  EXAMPLES
> >>  ========
> >>  **# bpftool btf dump id 1226**
> >> @@ -217,3 +232,34 @@ All the standard ways to specify map or program are supported:
> >>  **# bpftool btf dump prog tag b88e0a09b1d9759d**
> >>
> >>  **# bpftool btf dump prog pinned /sys/fs/bpf/prog_name**
> >> +
> >> +|
> >> +| **# bpftool btf dump file /sys/kernel/btf/i2c_smbus**
> >> +| (or)
> >> +| **# I2C_SMBUS_ID=$(bpftool btf show -p | jq '.[] | select(.name=="i2c_smbus").id')**
> >> +| **# bpftool btf dump id ${I2C_SMBUS_ID} -B /sys/kernel/btf/vmlinux**
> >> +
> >> +::
> >> +
> >> +  [104848] STRUCT 'i2c_smbus_alert' size=40 vlen=2
> >> +          'alert' type_id=393 bits_offset=0
> >> +          'ara' type_id=56050 bits_offset=256
> >> +  [104849] STRUCT 'alert_data' size=12 vlen=3
> >> +          'addr' type_id=16 bits_offset=0
> >> +          'type' type_id=56053 bits_offset=32
> >> +          'data' type_id=7 bits_offset=64
> >> +  [104850] PTR '(anon)' type_id=104848
> >> +  [104851] PTR '(anon)' type_id=104849
> >> +  [104852] FUNC 'i2c_register_spd' type_id=84745 linkage=static
> >> +  [104853] FUNC 'smbalert_driver_init' type_id=1213 linkage=static
> >> +  [104854] FUNC_PROTO '(anon)' ret_type_id=18 vlen=1
> >> +          'ara' type_id=56050
> >> +  [104855] FUNC 'i2c_handle_smbus_alert' type_id=104854 linkage=static
> >> +  [104856] FUNC 'smbalert_remove' type_id=104854 linkage=static
> >> +  [104857] FUNC_PROTO '(anon)' ret_type_id=18 vlen=2
> >> +          'ara' type_id=56050
> >> +          'id' type_id=56056
> >> +  [104858] FUNC 'smbalert_probe' type_id=104857 linkage=static
> >> +  [104859] FUNC 'smbalert_work' type_id=9695 linkage=static
> >> +  [104860] FUNC 'smbus_alert' type_id=71367 linkage=static
> >> +  [104861] FUNC 'smbus_do_alert' type_id=84827 linkage=static
> >
> > This reminded be that it would be awesome to support "format c"
> > use-case for dumping split BTF in a more sane way. I.e., instead of
> > dumping all types from base and split BTF, only dump necessary (used)
> > forward declarations from base BTF, and then full C dump of only new
> > types from the split (module) BTF. This will become more important as
> > people will start using module BTF more. It's an interesting add-on to
> > libbpf's btf_dumper functionality. Not sure how hard that would be,
> > but I'd imagine it shouldn't require much changes.
> >
> > Just in case anyone wanted to challenge themselves with some more
> > algorithmic patch for libbpf (*wink wink*)...
>
> If you're addressing this to me, I'm not particularly looking for such
> challenge at the moment :). In fact I already noted a few things that I

Just brain dumping a bit, too many small things to keep in mind (or to
keep track in various small TODO lists). Just thought maybe someone
following along would be interested. Alan would come closest to
knowing the internals of btf_dumper, so I'll CC him to try my luck ;)
No pressure.

> would like to fix or improve for bpftool, I will append this one to the
> list. I should maybe start thinking of a tracker of some sort to list
> and share this.
