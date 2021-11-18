Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74174455C9B
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhKRN0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:26:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhKRN0E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:26:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4D5A61B51;
        Thu, 18 Nov 2021 13:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637241783;
        bh=V6XUF7UdDZ0rC974g9Pc5Lryb/qxKRnvtskjdWaPUt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UAXcc6UWQQBeeOtPga8ebQTS8vFnTNt0mKBs8w7jDWwdRq7+tY9pKl8m3sgEewVVv
         LpEGS+2/3/buOlh3dTASbdEfso/aC+TKM2HOECvJWTJsA9dejw2d/gdJ65rDRMW1mz
         2BSx+9BXpbXz5ogud86d2bH3RRwbIXUDZtS8BC5jeasTo1pg1FRGc5t83QUi/P96Km
         khChKt2qr0WSStoEYXzPrgDkE8SnDnLUHVtRaEHGO8ocBgIEnGE6yHxf8H+py4ppMi
         KkwT7/xh7HhdT+8x7W6X+X6uFWgrG31cOAtg2XlmLlI9PB5CVNB2XGXi2+WiafmUrg
         YtiPJU6SD3HNg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 10E0A4088E; Thu, 18 Nov 2021 10:23:02 -0300 (-03)
Date:   Thu, 18 Nov 2021 10:23:02 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Documentation: Add minimum pahole version
Message-ID: <YZZTtvuwP6bK8/ut@kernel.org>
References: <YZPQ6+u2wTHRfR+W@kernel.org>
 <CAEf4BzbOnpL-=2Xi1DOheUtzc-JG5FmHqdvs4B_+0OeaCTgY=w@mail.gmail.com>
 <df39b24d-7813-c6fb-a9eb-a5c199e002d0@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df39b24d-7813-c6fb-a9eb-a5c199e002d0@iogearbox.net>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Nov 17, 2021 at 11:33:24PM +0100, Daniel Borkmann escreveu:
> On 11/16/21 7:21 PM, Andrii Nakryiko wrote:
> > On Tue, Nov 16, 2021 at 7:40 AM Arnaldo Carvalho de Melo
> > <acme@kernel.org> wrote:
> > > 
> > > A report was made in https://github.com/acmel/dwarves/issues/26 about
> > > pahole not being listed in the process/changes.rst file as being needed
> > > for building the kernel, address that.
> > > 
> > > Link: https://github.com/acmel/dwarves/issues/26
> > > Cc: Alexei Starovoitov <ast@kernel.org>
> > > Cc: Andrii Nakryiko <andrii@kernel.org>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jiri Olsa <jolsa@redhat.com>
> > > Cc: Jonathan Corbet <corbet@lwn.net>
> > > Cc: bpf@vger.kernel.org
> > > Cc: netdev@vger.kernel.org
> > > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > ---
> > >   Documentation/process/changes.rst | 9 +++++++++
> > >   1 file changed, 9 insertions(+)
> > > 
> > > diff --git a/Documentation/process/changes.rst b/Documentation/process/changes.rst
> > > index e35ab74a0f804b04..c45f167a1b6c02a4 100644
> > > --- a/Documentation/process/changes.rst
> > > +++ b/Documentation/process/changes.rst
> > > @@ -35,6 +35,7 @@ GNU make               3.81             make --version
> > >   binutils               2.23             ld -v
> > >   flex                   2.5.35           flex --version
> > >   bison                  2.0              bison --version
> > > +pahole                 1.16             pahole --version
> > >   util-linux             2.10o            fdformat --version
> > >   kmod                   13               depmod -V
> > >   e2fsprogs              1.41.4           e2fsck -V
> > > @@ -108,6 +109,14 @@ Bison
> > >   Since Linux 4.16, the build system generates parsers
> > >   during build.  This requires bison 2.0 or later.
> > > 
> > > +pahole:
> > > +-------
> > > +
> > > +Since Linux 5.2 the build system generates BTF (BPF Type Format) from DWARF in
> > > +vmlinux, a bit later from kernel modules as well, if CONFIG_DEBUG_INFO_BTF is
> > 
> > I'd probably emphasize a bit more that pahole is required only if
> > CONFIG_DEBUG_INFO_BTF is selected by moving "If CONFIG_DEBUG_INFO_BTF
> > is selected, " to the front. But either way looks good.
> 
> +1, I presume Jonathan will later pick up the v2?

I'll resubmit later.

- Arnaldo
 
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > 
> > > +selected.  This requires pahole v1.16 or later. It is found in the 'dwarves' or
> > > +'pahole' distro packages or from https://fedorapeople.org/~acme/dwarves/.
> > > +
> > >   Perl
> > >   ----
> > > 
> > > --
> > > 2.31.1
> > > 

-- 

- Arnaldo
