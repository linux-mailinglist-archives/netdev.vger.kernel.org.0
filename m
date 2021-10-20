Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF5A4344D0
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 07:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhJTFs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 01:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhJTFsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 01:48:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E5B8611F2;
        Wed, 20 Oct 2021 05:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634708771;
        bh=JPd61XPiLtPfzjEJFZKlH8gf++uxeVph6XmUzklYpCE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d+qoXgYExOqgMQ8B3xm6/WO5VIhsFzLOy8WQmRDcsyLAWoW7+LMKZILM8qXCCYCUQ
         aDJr/T6fy2TBDXCy56AT4EdNFFDg0NC2wtAUHHSTE4s4XW2j1WYg2hIbtlHqrWuh1Y
         hP4hLB9VYqNJc06UmZn2m6M3JpULH8jrHir87QAjy2W9ZjfNxGNnJ47cUJ2IOhoWv3
         LTtvH5czjntxn2Iq61BE2Y5rP0dF0p/CuiZZ/eSuC3BrmDYUfoVXy6EXDnlCGQX0aG
         nVgttK2yk9/RgGJkZ3XA67qjEWYsqXwEec9R8oT1JJ/RyXC5eZPRzK3DEj9RUDexX1
         K+ZjZXPWw2VBw==
Date:   Wed, 20 Oct 2021 06:46:01 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Roman Gushchin <guro@fb.com>, Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 14/23] bpftool: update bpftool-cgroup.rst reference
Message-ID: <20211020064531.3bbd1127@sal.lan>
In-Reply-To: <CAADnVQ+9+fXGXyEU+fWYGiM7HqzaJwPoSKBuXKd=qz3x25XfSw@mail.gmail.com>
References: <cover.1634630485.git.mchehab+huawei@kernel.org>
        <11f3dc3cfc192e2ee271467d7a6c7c1920006766.1634630486.git.mchehab+huawei@kernel.org>
        <e11c38fa-22fa-a0ae-4dd1-cac5a208e021@isovalent.com>
        <CAADnVQ+9+fXGXyEU+fWYGiM7HqzaJwPoSKBuXKd=qz3x25XfSw@mail.gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 19 Oct 2021 15:31:38 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> escreveu:

> On Tue, Oct 19, 2021 at 2:35 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > 2021-10-19 09:04 UTC+0100 ~ Mauro Carvalho Chehab
> > <mchehab+huawei@kernel.org>  
> > > The file name: Documentation/bpftool-cgroup.rst
> > > should be, instead: tools/bpf/bpftool/Documentation/bpftool-cgroup.rst.
> > >
> > > Update its cross-reference accordingly.
> > >
> > > Fixes: a2b5944fb4e0 ("selftests/bpf: Check consistency between bpftool source, doc, completion")
> > > Fixes: 5ccda64d38cc ("bpftool: implement cgroup bpf operations")
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > > ---
> > >
> > > To mailbombing on a large number of people, only mailing lists were C/C on the cover.
> > > See [PATCH v3 00/23] at: https://lore.kernel.org/all/cover.1634630485.git.mchehab+huawei@kernel.org/
> > >
> > >  tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> > > index be54b7335a76..617b8084c440 100755
> > > --- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> > > +++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> > > @@ -392,7 +392,7 @@ class ManCgroupExtractor(ManPageExtractor):
> > >      """
> > >      An extractor for bpftool-cgroup.rst.
> > >      """
> > > -    filename = os.path.join(BPFTOOL_DIR, 'Documentation/bpftool-cgroup.rst')
> > > +    filename = os.path.join(BPFTOOL_DIR, 'tools/bpf/bpftool/Documentation/bpftool-cgroup.rst')
> > >
> > >      def get_attach_types(self):
> > >          return self.get_rst_list('ATTACH_TYPE')
> > >  
> >
> > No, this change is incorrect. We have discussed it several times before
> > [0][1]. Please drop this patch.  
> 
> +1

Sorry, left-over. I dropped two other patches, but forgot to also drop
this one.

Regards,
Mauro
