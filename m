Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C084811FDA3
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 05:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfLPEm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 23:42:59 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45940 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfLPEm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 23:42:59 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so4876237pfg.12;
        Sun, 15 Dec 2019 20:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=nZLzgb/ySfUY3dMcXCRyVLhFRQTJDnW4ktEdbCq4fVY=;
        b=Goq/VUwPGnGUqJqKv5v0G5A9paa04MdAgdlkXO0OkEGMyFJAYszI9+JuC5XzTo5cOi
         Unjjj6cGxl7/1N9QPvf8CF5WWYfUaWUThG96XNKa3vAtgjTTdI8HIftYSWCJAnc3jq+o
         0G5E2CfrsZZ0cIUj+BJEk7H3VaKjfXJueL7x4nxNJLtVFR5mgWFnoQ8X8qMtaz68uOpw
         kiKnMzSxGzJ2DG7ZtvmNlqfizFI0ItmHLhazHKO1E+Rcxe51o/ViNcXDqugSr1mnUrp3
         AgeqQ94LTf5tU3MHfYHFTYjs4fq4TdAEVkJwyIBgqQraBjkbi655H0VhThVXLKeIs9ef
         9jng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=nZLzgb/ySfUY3dMcXCRyVLhFRQTJDnW4ktEdbCq4fVY=;
        b=GPPNMRtvZyvLrq+IBGWVeCjnWxobvUKEBxLslj+uxk5rpKV/yH3ccORblb49Jysyx5
         2IB/XVakPoKhkRwAC9tpNnnB4qSbzbRG+Vdu3p//4EHeDiDi7KsypN+Y9vKgNSyYlD9g
         RG1V/qQlPq5mqkFq+CvSSPjDYpqpuZWGPFjMSU6bm0O3xe0K6xduLxyU3cB/we8+Mu/D
         IRKoaTQp/wWGiBjkZM8j1nk6u6xE71KeBe0ya6VXjUScH7rHVKxCNQWaKkpRfo6wAD/S
         dz5uS0XL5Zp0gKMJhlObocMEn/ffzveyzTfKDNIfJlFFRscy1gaOk+X+Yag/xFXd4krl
         HJCQ==
X-Gm-Message-State: APjAAAX5rGsrJjJm/tJw3aZcPxRm+SZkFZZjH+THE5N3hsrkkRRJoaS6
        DFMxYY6ZTg0aXsadFG2vC5k=
X-Google-Smtp-Source: APXvYqyOdVSC6Fnb9QCuu5MbLw0R4cAzqyD5zMdpRufUFQxYphDNH/z/QcNzRQRYdDEwqQZJ0k/lzQ==
X-Received: by 2002:a63:1a22:: with SMTP id a34mr15036838pga.403.1576471377889;
        Sun, 15 Dec 2019 20:42:57 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::4748])
        by smtp.gmail.com with ESMTPSA id k19sm20764926pfg.132.2019.12.15.20.42.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Dec 2019 20:42:56 -0800 (PST)
Date:   Sun, 15 Dec 2019 20:42:55 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 0/4] Add libbpf-provided extern variables
 support
Message-ID: <20191216044253.6stsb7nsxf35cujl@ast-mbp.dhcp.thefacebook.com>
References: <20191214014710.3449601-1-andriin@fb.com>
 <20191216005209.jqb27p7tptauxn45@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZPGVPFugtDMWaAeaRfxA=+XCNMeUjdN39ZqF9cvpt30w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzZPGVPFugtDMWaAeaRfxA=+XCNMeUjdN39ZqF9cvpt30w@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 05:47:01PM -0800, Andrii Nakryiko wrote:
> On Sun, Dec 15, 2019 at 4:52 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Dec 13, 2019 at 05:47:06PM -0800, Andrii Nakryiko wrote:
> > > It's often important for BPF program to know kernel version or some specific
> > > config values (e.g., CONFIG_HZ to convert jiffies to seconds) and change or
> > > adjust program logic based on their values. As of today, any such need has to
> > > be resolved by recompiling BPF program for specific kernel and kernel
> > > configuration. In practice this is usually achieved by using BCC and its
> > > embedded LLVM/Clang. With such set up #ifdef CONFIG_XXX and similar
> > > compile-time constructs allow to deal with kernel varieties.
> > >
> > > With CO-RE (Compile Once – Run Everywhere) approach, this is not an option,
> > > unfortunately. All such logic variations have to be done as a normal
> > > C language constructs (i.e., if/else, variables, etc), not a preprocessor
> > > directives. This patch series add support for such advanced scenarios through
> > > C extern variables. These extern variables will be recognized by libbpf and
> > > supplied through extra .extern internal map, similarly to global data. This
> > > .extern map is read-only, which allows BPF verifier to track its content
> > > precisely as constants. That gives an opportunity to have pre-compiled BPF
> > > program, which can potentially use BPF functionality (e.g., BPF helpers) or
> > > kernel features (types, fields, etc), that are available only on a subset of
> > > targeted kernels, while effectively eleminating (through verifier's dead code
> > > detection) such unsupported functionality for other kernels (typically, older
> > > versions). Patch #3 explicitly tests a scenario of using unsupported BPF
> > > helper, to validate the approach.
> > >
> > > This patch set heavily relies on BTF type information emitted by compiler for
> > > each extern variable declaration. Based on specific types, libbpf does strict
> > > checks of config data values correctness. See patch #1 for details.
> > >
> > > Outline of the patch set:
> > > - patch #1 does a small clean up of internal map names contants;
> > > - patch #2 adds all of the libbpf internal machinery for externs support,
> > >   including setting up BTF information for .extern data section;
> > > - patch #3 adds support for .extern into BPF skeleton;
> > > - patch #4 adds externs selftests, as well as enhances test_skeleton.c test to
> > >   validate mmap()-ed .extern datasection functionality.
> >
> > Applied. Thanks.
> 
> Great, thanks!
> 
> >
> > Looking at the tests that do mkstemp()+write() just to pass a file path
> > as .kconfig_path option into bpf_object_open_opts() it feels that file only
> > support for externs is unnecessary limiting. I think it will simplify
> 
> yeah, it was a bit painful :)
> 
> > tests and will make the whole extern support more flexible if in addition to
> > kconfig_path bpf_object_open_opts() would support in-memory configuration.
> 
> I wanted to keep it simple for users, in case libbpf can't find config
> file, to just specify its location. But given your feedback here, and
> you mentioned previously that it would be nice to allow users to
> specify custom kconfig-like configuration to be exposed as externs as
> well, how about replacing .kconfig_path, which is a patch to config
> file, with just .kconfig, which is the **contents** of config file.
> That way we can support all of the above scenarios, if maybe sometime
> with a tiny bit of extra work for users:
> 
> 1. Override real kconfig with custom config (e.g., for testing
> purposes) - just specify alternative contents.
> 2. Extend kconfig with some extra configuration - user will have to
> read real kconfig, then append (or prepend, doesn't matter) custom
> contents.
> 
> What I want to avoid is having multiple ways to do this, having to
> decide whether to augment real Kconfig or completely override it, etc.
> So one string-based config override is preferable for simplicity.
> Agreed?

I think user experience would be better if users don't have to know that
/proc/config.gz exists and even more so if they don't need to read it. By
default libbpf should pick all CONFIG_* from known locations and in addition if
extra text is specified for bpf_object_open_opts() the libbpf can take the
values from there. So may be .kconfig_path can be replaced with
.additional_key_value_pairs ? I think override of /proc/config.gz is
unnecessary. Whereas additional predefined externs are useful for testing and
passing load-time configuration to bpf progs. Like IP addresses, etc.
