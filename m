Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4490A121A03
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 20:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfLPTei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 14:34:38 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40923 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfLPTeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 14:34:37 -0500
Received: by mail-qk1-f194.google.com with SMTP id c17so5411011qkg.7;
        Mon, 16 Dec 2019 11:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f4roXBwY5k0gq0+bC+q8pEp5Dfv7Y+Tv4SxW7pxGuIY=;
        b=ro8XYv5fyqJw2mfeWPMppV+I4HYL2quEC+YMtUOo/c1UiKm7mPRQh/+ti4rEKkeDd9
         oakmUEKHWtUvJFR8SWBVeABkHVMTVkyIQ/A8bVmUL1dDb9LkXZ7aj5DVp6jnyxTeJmgO
         y+XhEy0jnWlAECf/j5ibEUWmprxyyazoHads8QGyo9pk58tBfDcv8ju49JkzdMizYPpH
         Dxl3/DzhygLfchvAEDdk+l89zSg79R9zKmFRI+8SNCoEQL2J/k0v62I0jndsIAnNhKjk
         nOkh0MAmawRmjxCMPMGauu3J6iBhPbd8D6ZNhQwLoR/3/MQc4FSGMX/56N3BiCsfOswB
         BSrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f4roXBwY5k0gq0+bC+q8pEp5Dfv7Y+Tv4SxW7pxGuIY=;
        b=l6YsjRVKHRhC58dQ4gE7hs74jSRfhInx8BohQUw6DPezl9sOcN9QsGA54CGryUQcZe
         s7eZ5C90CoRn1VZ8QYHyzRA/Jn5VdbPT+eVj/PP8MsJ5hpxEvd3FVmHul1K4ATw9RGlC
         Bqkxe6KymZwhU9pGYfCesdIS4KdGn7bzG5gdQ79vvjco/nNirJxBQe1lXsvIF70qo4xo
         Hemn9+35BXCCNptp59Bam3mriX4YW0DPQLuNbCfx9pgCIpBdWomW+HkrUt717abX93W5
         BcJOchleCkdZiZt55d7otyc6WYO8beJkbqArAu2c4Qb75AIqahWFb0s+af6D/YpTJodN
         UHlA==
X-Gm-Message-State: APjAAAUhJCBVYEIlUuo2XTsuzpinGrtalGlgq7/AWcc0TtbTa1WtEnob
        FtvZl90EIHKCYM0h5ORjzxb3SG0hPcJxXys1KIw=
X-Google-Smtp-Source: APXvYqy964kynCmhQZjkRaNJQVUq5vCbejAs9U4gXIh/45+2bQLOHeH5yxrJBIMfqO8Kc8hLXyc8Z2bjhXwi6pJsUac=
X-Received: by 2002:ae9:e809:: with SMTP id a9mr1090208qkg.92.1576524876470;
 Mon, 16 Dec 2019 11:34:36 -0800 (PST)
MIME-Version: 1.0
References: <20191214014710.3449601-1-andriin@fb.com> <20191216005209.jqb27p7tptauxn45@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZPGVPFugtDMWaAeaRfxA=+XCNMeUjdN39ZqF9cvpt30w@mail.gmail.com> <20191216044253.6stsb7nsxf35cujl@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191216044253.6stsb7nsxf35cujl@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Dec 2019 11:34:25 -0800
Message-ID: <CAEf4BzbxkRLGENX9zPXKpmWo5Rc-QHkic=t0Cy4TCeBamCD7Qw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/4] Add libbpf-provided extern variables support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 8:42 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Dec 15, 2019 at 05:47:01PM -0800, Andrii Nakryiko wrote:
> > On Sun, Dec 15, 2019 at 4:52 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Dec 13, 2019 at 05:47:06PM -0800, Andrii Nakryiko wrote:
> > > > It's often important for BPF program to know kernel version or some=
 specific
> > > > config values (e.g., CONFIG_HZ to convert jiffies to seconds) and c=
hange or
> > > > adjust program logic based on their values. As of today, any such n=
eed has to
> > > > be resolved by recompiling BPF program for specific kernel and kern=
el
> > > > configuration. In practice this is usually achieved by using BCC an=
d its
> > > > embedded LLVM/Clang. With such set up #ifdef CONFIG_XXX and similar
> > > > compile-time constructs allow to deal with kernel varieties.
> > > >
> > > > With CO-RE (Compile Once =E2=80=93 Run Everywhere) approach, this i=
s not an option,
> > > > unfortunately. All such logic variations have to be done as a norma=
l
> > > > C language constructs (i.e., if/else, variables, etc), not a prepro=
cessor
> > > > directives. This patch series add support for such advanced scenari=
os through
> > > > C extern variables. These extern variables will be recognized by li=
bbpf and
> > > > supplied through extra .extern internal map, similarly to global da=
ta. This
> > > > .extern map is read-only, which allows BPF verifier to track its co=
ntent
> > > > precisely as constants. That gives an opportunity to have pre-compi=
led BPF
> > > > program, which can potentially use BPF functionality (e.g., BPF hel=
pers) or
> > > > kernel features (types, fields, etc), that are available only on a =
subset of
> > > > targeted kernels, while effectively eleminating (through verifier's=
 dead code
> > > > detection) such unsupported functionality for other kernels (typica=
lly, older
> > > > versions). Patch #3 explicitly tests a scenario of using unsupporte=
d BPF
> > > > helper, to validate the approach.
> > > >
> > > > This patch set heavily relies on BTF type information emitted by co=
mpiler for
> > > > each extern variable declaration. Based on specific types, libbpf d=
oes strict
> > > > checks of config data values correctness. See patch #1 for details.
> > > >
> > > > Outline of the patch set:
> > > > - patch #1 does a small clean up of internal map names contants;
> > > > - patch #2 adds all of the libbpf internal machinery for externs su=
pport,
> > > >   including setting up BTF information for .extern data section;
> > > > - patch #3 adds support for .extern into BPF skeleton;
> > > > - patch #4 adds externs selftests, as well as enhances test_skeleto=
n.c test to
> > > >   validate mmap()-ed .extern datasection functionality.
> > >
> > > Applied. Thanks.
> >
> > Great, thanks!
> >
> > >
> > > Looking at the tests that do mkstemp()+write() just to pass a file pa=
th
> > > as .kconfig_path option into bpf_object_open_opts() it feels that fil=
e only
> > > support for externs is unnecessary limiting. I think it will simplify
> >
> > yeah, it was a bit painful :)
> >
> > > tests and will make the whole extern support more flexible if in addi=
tion to
> > > kconfig_path bpf_object_open_opts() would support in-memory configura=
tion.
> >
> > I wanted to keep it simple for users, in case libbpf can't find config
> > file, to just specify its location. But given your feedback here, and
> > you mentioned previously that it would be nice to allow users to
> > specify custom kconfig-like configuration to be exposed as externs as
> > well, how about replacing .kconfig_path, which is a patch to config
> > file, with just .kconfig, which is the **contents** of config file.
> > That way we can support all of the above scenarios, if maybe sometime
> > with a tiny bit of extra work for users:
> >
> > 1. Override real kconfig with custom config (e.g., for testing
> > purposes) - just specify alternative contents.
> > 2. Extend kconfig with some extra configuration - user will have to
> > read real kconfig, then append (or prepend, doesn't matter) custom
> > contents.
> >
> > What I want to avoid is having multiple ways to do this, having to
> > decide whether to augment real Kconfig or completely override it, etc.
> > So one string-based config override is preferable for simplicity.
> > Agreed?
>
> I think user experience would be better if users don't have to know that
> /proc/config.gz exists and even more so if they don't need to read it. By
> default libbpf should pick all CONFIG_* from known locations and in addit=
ion if
> extra text is specified for bpf_object_open_opts() the libbpf can take th=
e
> values from there. So may be .kconfig_path can be replaced with
> .additional_key_value_pairs ? I think override of /proc/config.gz is
> unnecessary. Whereas additional predefined externs are useful for testing=
 and
> passing load-time configuration to bpf progs. Like IP addresses, etc.

Yes, agree about usability issues w/ user having to read and unzip
/proc/config.gz. I will add kconfig (const char*) to mean
additions/overrides to Kconfig, which applications could use to
override and augment Kconfig options for their needs. I'd still like
to keep the convention of CONFIG_ and reserve everything else for
static/dynamic linking use case (and kernel-provided externs, as a
special case of dynamic linking). Makes sense?

Daniel expressed concern about opting out of Kconfig parsing
altogether, so as a way to do this, I can keep kconfig_path option
anyways, and define that empty string means "no Kconfig parsing". But
let's see if Daniel still thinks it a problem.
