Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F62C315695
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhBITOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:14:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233628AbhBITIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 14:08:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612897583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y13n9ltDuIqN/elDFZtGeflsvqYft3gs4cjirXXX6wE=;
        b=JGMy/meQ9k9yke+RGbFBQkfj0mHpScL2mMn1RBJoKY6NlgU+uDQ9olNWhVpdsdMoVdiW08
        m24khH4D/9ynrAfc7SWwsJ60ca6w2ykY99HGXxRNsMByP5kcl9RGvYp72Vy+jWhdziGn3B
        I5j0RgRtXtEIGctXOk1D5zNbsSPKnBQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-x7-UMDNoN9uQpT5J-jn-3A-1; Tue, 09 Feb 2021 14:06:19 -0500
X-MC-Unique: x7-UMDNoN9uQpT5J-jn-3A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFD60107ACE3;
        Tue,  9 Feb 2021 19:06:16 +0000 (UTC)
Received: from krava (unknown [10.40.192.77])
        by smtp.corp.redhat.com (Postfix) with SMTP id 762865D749;
        Tue,  9 Feb 2021 19:06:13 +0000 (UTC)
Date:   Tue, 9 Feb 2021 20:06:12 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Message-ID: <YCLdJPPC+6QjUsR4@krava>
References: <20210209034416.GA1669105@ubuntu-m3-large-x86>
 <CAEf4BzYnT-eoKRL9_Pu_DEuqXVa+edN5F-s+k2RxBSzcsSTJ1g@mail.gmail.com>
 <20210209052311.GA125918@ubuntu-m3-large-x86>
 <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86>
 <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava>
 <YCKwxNDkS9rdr43W@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCKwxNDkS9rdr43W@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 05:13:42PM +0100, Jiri Olsa wrote:
> On Tue, Feb 09, 2021 at 04:09:36PM +0100, Jiri Olsa wrote:
> 
> SNIP
> 
> > > > > >                 DW_AT_prototyped        (true)
> > > > > >                 DW_AT_type      (0x01cfdfe4 "long int")
> > > > > >                 DW_AT_external  (true)
> > > > > >
> > > > > 
> > > > > Ok, the problem appears to be not in DWARF, but in mcount_loc data.
> > > > > vfs_truncate's address is not recorded as ftrace-attachable, and thus
> > > > > pahole ignores it. I don't know why this happens and it's quite
> > > > > strange, given vfs_truncate is just a normal global function.
> > > 
> > > right, I can't see it in mcount adresses.. but it begins with instructions
> > > that appears to be nops, which would suggest it's traceable
> > > 
> > > 	ffff80001031f430 <vfs_truncate>:
> > > 	ffff80001031f430: 5f 24 03 d5   hint    #34
> > > 	ffff80001031f434: 1f 20 03 d5   nop
> > > 	ffff80001031f438: 1f 20 03 d5   nop
> > > 	ffff80001031f43c: 3f 23 03 d5   hint    #25
> > > 
> > > > > 
> > > > > I'd like to understand this issue before we try to fix it, but there
> > > > > is at least one improvement we can make: pahole should check ftrace
> > > > > addresses only for static functions, not the global ones (global ones
> > > > > should be always attachable, unless they are special, e.g., notrace
> > > > > and stuff). We can easily check that by looking at the corresponding
> > > > > symbol. But I'd like to verify that vfs_truncate is ftrace-attachable
> > 
> > I'm still trying to build the kernel.. however ;-)
> 
> I finally reproduced.. however arm's not using mcount_loc
> but some other special section.. so it's new mess for me

so ftrace data actualy has vfs_truncate address but with extra 4 bytes:

	ffff80001031f434

real vfs_truncate address:

	ffff80001031f430 g     F .text  0000000000000168 vfs_truncate

vfs_truncate disasm:

	ffff80001031f430 <vfs_truncate>:
	ffff80001031f430: 5f 24 03 d5   hint    #34
	ffff80001031f434: 1f 20 03 d5   nop
	ffff80001031f438: 1f 20 03 d5   nop
	ffff80001031f43c: 3f 23 03 d5   hint    #25

thats why we don't match it in pahole.. I checked few other functions
and some have the same problem and some match the function boundary

those that match don't have that first hint instrucion, like:

	ffff800010321e40 <do_faccessat>:
	ffff800010321e40: 1f 20 03 d5   nop
	ffff800010321e44: 1f 20 03 d5   nop
	ffff800010321e48: 3f 23 03 d5   hint    #25

any hints about hint instructions? ;-)

jirka

