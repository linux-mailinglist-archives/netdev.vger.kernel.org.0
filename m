Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A4E11FCA6
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 02:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfLPBrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 20:47:14 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46424 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfLPBrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 20:47:13 -0500
Received: by mail-qt1-f195.google.com with SMTP id 38so4501763qtb.13;
        Sun, 15 Dec 2019 17:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G2/nXCx6QCR0iS63Z/GLLdpfGGylQ4dPIRND40TTSKg=;
        b=RQ/7PYBk+jdhnssLj0f2TSinBUnDyICuXHlc5sEDTd5Ftc0D2OywTrTERGWP2irNMi
         GnB0Kgw/wvrtqTwQFqCyzfDeK6KfVzu3364YJH+V9WkWndj4jMkXSU7VM63MZFkt3Ptw
         1Hy8LMGyr0p7PU80PGt1zqWvSU2hBWM8qS1/3ZJoyCLhIxsGgDDVoAJs2WLilxZiYD1t
         gAvr+jQBQzg/aMtI1QvzWlZbnOA/NcIv3BZ3mo+ZGL00zendf6yTTgEu8RoTdiebQOcL
         vDoNeVvp/+izMvwBcoRnMBme7zLLfDPnzvtJ80eyQNlfyb73oGJXLZEdcYNb7k04LNzr
         uR8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G2/nXCx6QCR0iS63Z/GLLdpfGGylQ4dPIRND40TTSKg=;
        b=MbOL/dBMYyfJ9swFqlF90O4rBCRyYWVEA3jC7tzd6f9mgOHY50M1WnSGB1g4+LuLvE
         /p733IyWLePCP3BlRs+lo9E5Y5qSPuB26TxY+Tj+vNgo7xx45DvJ6zlRsPap7p+sE48O
         /A+srNBLXe0XDcefIWiKXOs9X0DHVbhlpdqMPw47mrP2jrBtw721KzswUJPgIiFS4+xo
         0IlL7zRduAO78XUPJMvT5Xf+I7gemsjRIBMpJbYuLXcJNZPuaIUk6CB819O+AZdyAtbK
         xKbyhvC+q74SqNyQTsRNjZEL8wPfifIZXkcxdZxeBUlg/Vq2fce9fSav+v7H+2coyZPj
         m6FQ==
X-Gm-Message-State: APjAAAXXEbFIu+tuqXxCfJ87iQ6bPP0FpFa/WaH5UO0EklB5yiv8gjK3
        ZGeRVmQflgvxi/fQOJyOchQosdA+4zMF8q94MCEp+Q==
X-Google-Smtp-Source: APXvYqy5Jpu62nG7jOTEQ6DUjRlfnNWfws/qFKUzsujvt8ReUCVlKwr0iAY+F51cD7C2PJ5f13QXjYgkz5U2hEXxvis=
X-Received: by 2002:ac8:7b29:: with SMTP id l9mr22165447qtu.141.1576460832225;
 Sun, 15 Dec 2019 17:47:12 -0800 (PST)
MIME-Version: 1.0
References: <20191214014710.3449601-1-andriin@fb.com> <20191216005209.jqb27p7tptauxn45@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191216005209.jqb27p7tptauxn45@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 15 Dec 2019 17:47:01 -0800
Message-ID: <CAEf4BzZPGVPFugtDMWaAeaRfxA=+XCNMeUjdN39ZqF9cvpt30w@mail.gmail.com>
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

On Sun, Dec 15, 2019 at 4:52 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Dec 13, 2019 at 05:47:06PM -0800, Andrii Nakryiko wrote:
> > It's often important for BPF program to know kernel version or some spe=
cific
> > config values (e.g., CONFIG_HZ to convert jiffies to seconds) and chang=
e or
> > adjust program logic based on their values. As of today, any such need =
has to
> > be resolved by recompiling BPF program for specific kernel and kernel
> > configuration. In practice this is usually achieved by using BCC and it=
s
> > embedded LLVM/Clang. With such set up #ifdef CONFIG_XXX and similar
> > compile-time constructs allow to deal with kernel varieties.
> >
> > With CO-RE (Compile Once =E2=80=93 Run Everywhere) approach, this is no=
t an option,
> > unfortunately. All such logic variations have to be done as a normal
> > C language constructs (i.e., if/else, variables, etc), not a preprocess=
or
> > directives. This patch series add support for such advanced scenarios t=
hrough
> > C extern variables. These extern variables will be recognized by libbpf=
 and
> > supplied through extra .extern internal map, similarly to global data. =
This
> > .extern map is read-only, which allows BPF verifier to track its conten=
t
> > precisely as constants. That gives an opportunity to have pre-compiled =
BPF
> > program, which can potentially use BPF functionality (e.g., BPF helpers=
) or
> > kernel features (types, fields, etc), that are available only on a subs=
et of
> > targeted kernels, while effectively eleminating (through verifier's dea=
d code
> > detection) such unsupported functionality for other kernels (typically,=
 older
> > versions). Patch #3 explicitly tests a scenario of using unsupported BP=
F
> > helper, to validate the approach.
> >
> > This patch set heavily relies on BTF type information emitted by compil=
er for
> > each extern variable declaration. Based on specific types, libbpf does =
strict
> > checks of config data values correctness. See patch #1 for details.
> >
> > Outline of the patch set:
> > - patch #1 does a small clean up of internal map names contants;
> > - patch #2 adds all of the libbpf internal machinery for externs suppor=
t,
> >   including setting up BTF information for .extern data section;
> > - patch #3 adds support for .extern into BPF skeleton;
> > - patch #4 adds externs selftests, as well as enhances test_skeleton.c =
test to
> >   validate mmap()-ed .extern datasection functionality.
>
> Applied. Thanks.

Great, thanks!

>
> Looking at the tests that do mkstemp()+write() just to pass a file path
> as .kconfig_path option into bpf_object_open_opts() it feels that file on=
ly
> support for externs is unnecessary limiting. I think it will simplify

yeah, it was a bit painful :)

> tests and will make the whole extern support more flexible if in addition=
 to
> kconfig_path bpf_object_open_opts() would support in-memory configuration=
.

I wanted to keep it simple for users, in case libbpf can't find config
file, to just specify its location. But given your feedback here, and
you mentioned previously that it would be nice to allow users to
specify custom kconfig-like configuration to be exposed as externs as
well, how about replacing .kconfig_path, which is a patch to config
file, with just .kconfig, which is the **contents** of config file.
That way we can support all of the above scenarios, if maybe sometime
with a tiny bit of extra work for users:

1. Override real kconfig with custom config (e.g., for testing
purposes) - just specify alternative contents.
2. Extend kconfig with some extra configuration - user will have to
read real kconfig, then append (or prepend, doesn't matter) custom
contents.

What I want to avoid is having multiple ways to do this, having to
decide whether to augment real Kconfig or completely override it, etc.
So one string-based config override is preferable for simplicity.
Agreed?
