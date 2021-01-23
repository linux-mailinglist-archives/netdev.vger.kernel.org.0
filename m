Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770EA301858
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbhAWUWn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 23 Jan 2021 15:22:43 -0500
Received: from wildebeest.demon.nl ([212.238.236.112]:36172 "EHLO
        gnu.wildebeest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbhAWUWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:22:42 -0500
Received: from tarox.wildebeest.org (tarox.wildebeest.org [172.31.17.39])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by gnu.wildebeest.org (Postfix) with ESMTPSA id D029330015C3;
        Sat, 23 Jan 2021 21:21:57 +0100 (CET)
Received: by tarox.wildebeest.org (Postfix, from userid 1000)
        id B6ACD400029C; Sat, 23 Jan 2021 21:21:57 +0100 (CET)
Message-ID: <51de59d9a4ef0ee544772ea59aae80d50a4930b5.camel@klomp.org>
Subject: Re: [PATCH 2/3] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
From:   Mark Wielaard <mark@klomp.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Date:   Sat, 23 Jan 2021 21:21:57 +0100
In-Reply-To: <CAEf4BzaviAOnNc31vUjWcCK7JvEwc8_nPQTiEpxMFcoTcvNw8w@mail.gmail.com>
References: <20210121202203.9346-1-jolsa@kernel.org>
         <20210121202203.9346-3-jolsa@kernel.org>
         <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com>
         <20210122204654.GB70760@krava>
         <CAEf4BzaRrMp1+2dgv_1WrkBt+=KF1BJnN_KGwZKx5gDg7t++Yg@mail.gmail.com>
         <20210123185143.GA117714@krava>
         <CAEf4BzaviAOnNc31vUjWcCK7JvEwc8_nPQTiEpxMFcoTcvNw8w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
X-Spam-Flag: NO
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.0
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on gnu.wildebeest.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, 2021-01-23 at 12:07 -0800, Andrii Nakryiko wrote:
> > the latest upstream code seems to set it always,
> > but I agree we should be careful
> 
> oh, then maybe it's not necessary. I honestly don't even know where
> the authoritative source code of libelf is, so I just found some
> random source code with Google.

The elfutils.org libelf implementation can be found here:
https://sourceware.org/git/?p=elfutils.git;a=tree;f=libelf;hb=HEAD

There are some other implementations, but some aren't maintained and
others aren't packaged for any distro (anymore). libelf is a semi-
standard "SVR4 Unix" library, so you might also find it for some none
GNU/Linux OSes like Solaris. The ELF specification itself is contained
in the System V Application Binary Interface (gABI). The libelf library
itself isn't actually officially part of the specification. But we
still do try to keep the implementations (source) compatible through
the generic-abi mailinglist.

Cheers,

Mark
