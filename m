Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559261DA9DB
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 07:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgETF0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 01:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbgETF0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 01:26:08 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95871C061A0E;
        Tue, 19 May 2020 22:26:08 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ci23so727091pjb.5;
        Tue, 19 May 2020 22:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eRmslym24V6G/rjPE8TehOfLWQ3zK6gG071z6c2z4UU=;
        b=erUqusEcKRlIP3KYp3chtbL3NTp8aMyzzUU5VsGfE7lUwSaCnAkHLHve1yL3c+2ysw
         tzV8VcKNivFaTnUwNf6c39c50waU31eQaRd7qXjqQRQ/eDh9+Cv3jBWmurl059hFt+q1
         V5oSvIaX712w7elQvFTxwaO8IOmcDNBc+4Mgq89Trfv9U2wbq4LjA2t0TKtoCyVxubwp
         xsvsI/OtlgMIXE7HF5s6y4LKwB34+LPafXCgjk6X9kShKU3OOFvPXQfKn6yIs7beMVT9
         lIQaPdfIrSu7Rs8KDS7h3xIeNjla/7dr9VFcN+2SayNyRWJAUgAIlDyKIiveEVj+BoQf
         Ni4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eRmslym24V6G/rjPE8TehOfLWQ3zK6gG071z6c2z4UU=;
        b=M6QpjsC/fYt5FyVAhLJVkmhxCzynzSJSeAiTIY0k+GimCqmgyz99zZ1y2MjWwv8QrC
         lCk/H9/ub9YcZUlbAihHOkMS77hoa9WGetnPFdSWVYbhqGtIpCtmv6L4rYaEcihlrZQb
         /TwRnvBRenECrsj8FWip2SU8GY1DbkstwoTXu8xIy+Fuh9oF17TVPuo9F7ta1GIuIiMU
         riCEtwKm+WwaNJ6R0WiY6RCOIdw/794aqsqrJsOU8iPYmsKW3uYCk49IjZZjMjVFuJZt
         KOwLx6/enEuJlfek4N40DRl9OdKQ+2TAQbEGz3vv268V2AubB9E4nGoTrXx/DDazfx6T
         nehw==
X-Gm-Message-State: AOAM5315d9/nYhn5b/GxMPDTY8i/bxB4k5QCSo9gGQHNF+rnIultZL7c
        0e43TjFxCkwnV4tcvQH2ia0=
X-Google-Smtp-Source: ABdhPJxgU6JMsC870qBMQn3lqTKFkDnKKBt3MvzEuqd85kwCYzn4m4YWzUn1hbHotWgCzS7GTpNWQg==
X-Received: by 2002:a17:90a:8c85:: with SMTP id b5mr3143434pjo.187.1589952368001;
        Tue, 19 May 2020 22:26:08 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8135])
        by smtp.gmail.com with ESMTPSA id 131sm882738pgf.49.2020.05.19.22.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 22:26:06 -0700 (PDT)
Date:   Tue, 19 May 2020 22:26:04 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, bpf@vger.kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next] selftests/bpf: add general instructions for
 test execution
Message-ID: <20200520052604.o53ca2kyzd7sd3g3@ast-mbp.dhcp.thefacebook.com>
References: <1589800990-11209-1-git-send-email-alan.maguire@oracle.com>
 <20200519155021.6tag46i57z2hsivj@ast-mbp.dhcp.thefacebook.com>
 <alpine.LRH.2.21.2005192224560.31696@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2005192224560.31696@localhost>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 10:34:25PM +0100, Alan Maguire wrote:
> On Tue, 19 May 2020, Alexei Starovoitov wrote:
> 
> > On Mon, May 18, 2020 at 12:23:10PM +0100, Alan Maguire wrote:
> > > Getting a clean BPF selftests run involves ensuring latest trunk LLVM/clang
> > > are used, pahole is recent (>=1.16) and config matches the specified
> > > config file as closely as possible.  Document all of this in the general
> > > README.rst file.  Also note how to work around timeout failures.
> > > 
> > > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > > ---
> > >  tools/testing/selftests/bpf/README.rst | 46 ++++++++++++++++++++++++++++++++++
> > >  1 file changed, 46 insertions(+)
> > > 
> > > diff --git a/tools/testing/selftests/bpf/README.rst b/tools/testing/selftests/bpf/README.rst
> > > index 0f67f1b..b00eebb 100644
> > > --- a/tools/testing/selftests/bpf/README.rst
> > > +++ b/tools/testing/selftests/bpf/README.rst
> > > @@ -1,6 +1,52 @@
> > >  ==================
> > >  BPF Selftest Notes
> > >  ==================
> > > +First verify the built kernel config options match the config options
> > > +specified in the config file in this directory.  Test failures for
> > > +unknown helpers, inability to find BTF etc will be observed otherwise.
> > > +
> > > +To ensure the maximum number of tests pass, it is best to use the latest
> > > +trunk LLVM/clang, i.e.
> > > +
> > > +git clone https://github.com/llvm/llvm-project
> > > +
> > > +Build/install trunk LLVM:
> > > +
> > > +.. code-block:: bash
> > > +  git clone https://github.com/llvm/llvm-project
> > > +  cd llvm-project
> > > +  mkdir build/llvm
> > > +  cd build/llvm
> > > +  cmake ../../llvm/
> > > +  make
> > > +  sudo make install
> > > +  cd ../../
> > > +
> > > +Build/install trunk clang:
> > > +
> > > +.. code-block:: bash
> > > +  mkdir -p build/clang
> > > +  cd build/clang
> > > +  cmake ../../clang
> > > +  make
> > > +  sudo make install
> > > +
> > 
> > these instructions are obsolete and partially incorrect.
> > May be refer to Documentation/bpf/bpf_devel_QA.rst instead?
> >
> 
> Sure; looks like there are up-to-date sections there on
> running BPF selftests and building LLVM manually.  Perhaps
> I should add the notes about pahole etc there too?

yes. please.
Could you mention distros that have fresh pahole?
Otherwise users will have an impression that pahole needs
to be build from scratch as well. Which is not the case.

> I should also have noted that without an up-to-date iproute2
> failures will be observed also.

Would be good to highlight which tests will fail with old iproute2.
I'm not sure which version is necessary.
What is 'up-to-date' ?
The tests I run before applying work for me and I rebuild iproute2
every year or so :)

> > > +When building the kernel with CONFIG_DEBUG_INFO_BTF, pahole
> > > +version 16 or later is also required for BTF function
> > > +support. pahole can be built from the source at
> > > +
> > > +https://github.com/acmel/dwarves
> > > +
> > > +It is often available in "dwarves/libdwarves" packages also,
> > > +but be aware that versions prior to 1.16 will fail with
> > > +errors that functions cannot be found in BTF.
> > > +
> > > +When running selftests, the default timeout of 45 seconds
> > > +can be exceeded by some tests.  We can override the default
> > > +timeout via a "settings" file; for example:
> > > +
> > > +.. code-block:: bash
> > > +  echo "timeout=120" > tools/testing/selftests/bpf/settings
> > 
> > Is it really the case?
> > I've never seen anything like this.
> > 
> 
> When running via "make run_tests" on baremetal systems I
> see test timeouts pretty consistently; e.g. from a bpf tree test
> run yesterday:
> 
> not ok 6 selftests: bpf: test_progs # TIMEOUT
> not ok 31 selftests: bpf: test_tunnel.sh # TIMEOUT
> not ok 38 selftests: bpf: test_lwt_ip_encap.sh # TIMEOUT
> not ok 40 selftests: bpf: test_tc_tunnel.sh # TIMEOUT
> not ok 42 selftests: bpf: test_xdping.sh # TIMEOUT
> not ok 43 selftests: bpf: test_bpftool_build.sh # TIMEOUT
> 
> These will only occur if running via "make run_tests",
> so running tests individually would not trigger these
> failures.

If timeout is necessary it's better to fix it in the git
instead of requiring users to tweak their environment.
