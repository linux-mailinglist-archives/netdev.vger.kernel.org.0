Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170E736993B
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243538AbhDWSUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231728AbhDWSUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 14:20:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABE5161261;
        Fri, 23 Apr 2021 18:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619202017;
        bh=Arrt3Oq+jC3yqTEvvMU/AOmrJBBTknvHFVkqL1cxPrM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GA/CVmunIyH90LDcH9GUb1tSWNLJUbaLxJg2G3GG1oXX1MVh+ilAyvkER/aZYHt62
         NaP/2y4BBIC4mlAmZ12iiSq928Bk5fG7vigAn9USw6D+aecWC1LNlwEg5AjqS6NBU1
         VVFECpd2LTJUDGhITHvAueR8xbXK9TfE47+F5/BWRAulwSwH2KeaG+HqPgu0xWATBw
         ocnJDT+LYUWR9EMdUaGdxZtGXq1FSfyWA0GT/AU5UQZNKEVdTKu6YOGXfOL04bvg0a
         55Wo24E8K9a/CpRvcg2MGci1kKsGsYUgCxCK8qHGHpLHiA9rmFZDabcA02qp/uhdzG
         rNYp6/mUZEFww==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 052B440647; Fri, 23 Apr 2021 15:20:13 -0300 (-03)
Date:   Fri, 23 Apr 2021 15:20:13 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
Subject: Re: [PATCH bpf-next] bpf: Document the pahole release info related
 to libbpf in bpf_devel_QA.rst
Message-ID: <YIMP3flCE6uwYp69@kernel.org>
References: <1619141010-12521-1-git-send-email-yangtiezhu@loongson.cn>
 <221ef66a-a7e4-14b7-e085-6062e8547b11@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <221ef66a-a7e4-14b7-e085-6062e8547b11@fb.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Apr 22, 2021 at 09:12:19PM -0700, Yonghong Song escreveu:
> 
> 
> On 4/22/21 6:23 PM, Tiezhu Yang wrote:
> > pahole starts to use libbpf definitions and APIs since v1.13 after the
> > commit 21507cd3e97b ("pahole: add libbpf as submodule under lib/bpf").
> > It works well with the git repository because the libbpf submodule will
> > use "git submodule update --init --recursive" to update.
> > 
> > Unfortunately, the default github release source code does not contain
> > libbpf submodule source code and this will cause build issues, the tarball
> > from https://git.kernel.org/pub/scm/devel/pahole/pahole.git/ is same with
> > github, you can get the source tarball with corresponding libbpf submodule
> > codes from
> > 
> > https://fedorapeople.org/~acme/dwarves
> > 
> > This change documents the above issues to give more information so that
> > we can get the tarball from the right place, early discussion is here:
> > 
> > https://lore.kernel.org/bpf/2de4aad5-fa9e-1c39-3c92-9bb9229d0966@loongson.cn/
> > 
> > Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> > ---
> >   Documentation/bpf/bpf_devel_QA.rst | 13 +++++++++++++
> >   1 file changed, 13 insertions(+)
> > 
> > diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
> > index d05e67e..253496a 100644
> > --- a/Documentation/bpf/bpf_devel_QA.rst
> > +++ b/Documentation/bpf/bpf_devel_QA.rst
> > @@ -449,6 +449,19 @@ from source at
> >   https://github.com/acmel/dwarves
> > +pahole starts to use libbpf definitions and APIs since v1.13 after the
> > +commit 21507cd3e97b ("pahole: add libbpf as submodule under lib/bpf").
> > +It works well with the git repository because the libbpf submodule will
> > +use "git submodule update --init --recursive" to update.
> > +
> > +Unfortunately, the default github release source code does not contain
> > +libbpf submodule source code and this will cause build issues, the tarball
> > +from https://git.kernel.org/pub/scm/devel/pahole/pahole.git/ is same with
> > +github, you can get the source tarball with corresponding libbpf submodule
> > +codes from
> > +
> > +https://fedorapeople.org/~acme/dwarves
> > +
> 
> Arnaldo, could you take a look at this patch? Thanks!

Sure, he documented it as I expected from a previous interaction about
this. Would be good to add a paragraph stating how to grab libbpf and
graft it even on a tarball not containing it tho.

Bonus points if the cmake files gets changed in a way that this gets
notified to the user in the error message.

But these suggestions can come in another patch, for this I can give my:

Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
 
> >   Some distros have pahole version 1.16 packaged already, e.g.
> >   Fedora, Gentoo.
