Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8628F43416D
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 00:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhJSWeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 18:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhJSWeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 18:34:03 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F29C06161C;
        Tue, 19 Oct 2021 15:31:50 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id t184so1266871pfd.0;
        Tue, 19 Oct 2021 15:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QQt79f2ztwEytrG3Wcrb+UJxVauF4hf/a/9L7b7paIc=;
        b=ej0Kea7BiqGuAt4aKtPjKo+cLvhiFuWuFwxu4v6BlAwQe4zOpN4sD71RrNJAd1uYAn
         UbYC0A7LrpxXLQWgmagvghe5QDBcC423gzvcmIzSGWIWI8Kh9k+0nMgaqQ1uFT3WIY+i
         y+ec3MLN4Ki3YJZ6DQsPZsfy474aXkQC4iTpSSybg+HjoHzv0bZBWZ4y+QYfNNAScrvw
         imRoNfL+7RTIaKw638hOOkT+ahnlXSZZIjLOxZf2k7NKBKXJTi0M91eX91UXDXnmFamK
         JBvcA8+/qKpvUfnxvPWR/PVd9Bnl+K6+14QxPAmZ8ZhdNb6z/K4upmWoGA4dP8dx2PgW
         S94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QQt79f2ztwEytrG3Wcrb+UJxVauF4hf/a/9L7b7paIc=;
        b=VcJ56z+jtnaAXJOjUuJ8LKq2/yo3cIHTXev68Rs+Ta4O7sX32H0QeGFKHTYiWJNWlz
         WsQZszw0j9IuQV9x9PoqoZ+8cc2B3T4VvD1BgLySfRSCCsYlvNxQiKJsZyrO/Io5hm/l
         mzbjaQmlsHVD+s/WiG5WWaKbyRpyBdJSxkiL5xap2YGILuxYFsD8K97bks0an9LRPaId
         fq3VW7nTKSXgrx+rPAifYQVeV8hkXEcCZc3EIyEmjiWLhtbyz11rXFQ3ttBgkSJGZYsM
         74Tn/T3Uv9T9WeP3Rvv+5GROUQrhJ9YEiK4Bss5JTnk1JEHBYONUxAsJJgOg4BRQAFik
         yqxw==
X-Gm-Message-State: AOAM532O7LYSHtbD0xIU0LaeCdNpeI0/sWdcE6KeRiwGDH9YF2npGBRU
        UIOM7ZFQO0RcwjvdobHoVnf7tul5hYiKZqDiIuM=
X-Google-Smtp-Source: ABdhPJx1ZTfV1KbHy9KP6Y6JzrwYhVPoMKjxO+PGza3THp14gnPZ50Ulxz3A7SO+g7ja72X+W5MdPQAyTH/vBTMQksE=
X-Received: by 2002:a63:374c:: with SMTP id g12mr30702710pgn.35.1634682709570;
 Tue, 19 Oct 2021 15:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634630485.git.mchehab+huawei@kernel.org>
 <11f3dc3cfc192e2ee271467d7a6c7c1920006766.1634630486.git.mchehab+huawei@kernel.org>
 <e11c38fa-22fa-a0ae-4dd1-cac5a208e021@isovalent.com>
In-Reply-To: <e11c38fa-22fa-a0ae-4dd1-cac5a208e021@isovalent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 19 Oct 2021 15:31:38 -0700
Message-ID: <CAADnVQ+9+fXGXyEU+fWYGiM7HqzaJwPoSKBuXKd=qz3x25XfSw@mail.gmail.com>
Subject: Re: [PATCH v3 14/23] bpftool: update bpftool-cgroup.rst reference
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 2:35 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-10-19 09:04 UTC+0100 ~ Mauro Carvalho Chehab
> <mchehab+huawei@kernel.org>
> > The file name: Documentation/bpftool-cgroup.rst
> > should be, instead: tools/bpf/bpftool/Documentation/bpftool-cgroup.rst.
> >
> > Update its cross-reference accordingly.
> >
> > Fixes: a2b5944fb4e0 ("selftests/bpf: Check consistency between bpftool source, doc, completion")
> > Fixes: 5ccda64d38cc ("bpftool: implement cgroup bpf operations")
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > ---
> >
> > To mailbombing on a large number of people, only mailing lists were C/C on the cover.
> > See [PATCH v3 00/23] at: https://lore.kernel.org/all/cover.1634630485.git.mchehab+huawei@kernel.org/
> >
> >  tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> > index be54b7335a76..617b8084c440 100755
> > --- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> > +++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> > @@ -392,7 +392,7 @@ class ManCgroupExtractor(ManPageExtractor):
> >      """
> >      An extractor for bpftool-cgroup.rst.
> >      """
> > -    filename = os.path.join(BPFTOOL_DIR, 'Documentation/bpftool-cgroup.rst')
> > +    filename = os.path.join(BPFTOOL_DIR, 'tools/bpf/bpftool/Documentation/bpftool-cgroup.rst')
> >
> >      def get_attach_types(self):
> >          return self.get_rst_list('ATTACH_TYPE')
> >
>
> No, this change is incorrect. We have discussed it several times before
> [0][1]. Please drop this patch.

+1
