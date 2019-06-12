Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDAF4493D
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbfFMRPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:15:52 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41012 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728738AbfFLVr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 17:47:59 -0400
Received: by mail-pg1-f193.google.com with SMTP id 83so9640358pgg.8
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 14:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tHRkjY4Nu+1l3Rjs3Nvwl6SxOHkmP8KHiqBEv4eP/cY=;
        b=2J309gy55Lz6ReiN1PiptjxIABPfKCeXn4VWfwGbj3jnIQZrXFJMqRQjvTw+ITIN1Z
         +EF6k3EvwRrLzkvTKvwfh930rs+fbf9TyYAj1fXZwixcwy4SqGlO4SRV576qAoUU++sr
         2WtIuqrdOqaamGoYpO8FunLmPtfXx18EnbxJTDo7qWZYbIaoh4gucsp1sbbvNA8ylXJY
         mRWKZlITZ0LKpNacUSayxtZnznPLoE/DaMqeY5/CEBxgYj752e5m2L3FdkG2IIylrTyJ
         4i0b134clRIqWEU2VS2Ge8NafbFsN2pRgXLmumSeaTtEZxN8BE31kJpQrEc7coKAsBPC
         h8cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tHRkjY4Nu+1l3Rjs3Nvwl6SxOHkmP8KHiqBEv4eP/cY=;
        b=gIpLJt6vvDHlYWtzNFvlha+mwoB3p3fx/8bCeEGzKJnwjfCFX3RBmPeA7MRcEsgOfG
         9O94b4oresvlSQmeJpIq/+SM7yCec0OYCfkYiFHJOnzt+WeJJ0pcAX6odWYWScUpUx6J
         RVp8Q8JbSUIlf3xz6Gnbt2M+E6p7oh3pmEnt5YuI80yYmXBc8xR/gu/wn/1kpZzaq1X/
         EAm35A3RW/ve8OB9UhRykHPtn/VqKJGEoOPJXVhmTLvSCwCsX4NKFGu5BE6PmuVJO8s9
         gwsvfxcj84QRFsXriRclPBC0TvSL7fjL56IuqlyGFNJxsm+CBNT1J17m1tX2VtzC67F6
         0FdQ==
X-Gm-Message-State: APjAAAWbR7kbFQY/Uwczaknl5B2B8azVliDZ/97Btsf6Ar/Jrl7VtFtZ
        m6/KuFKZji6b3bcD5WOddjCAKA==
X-Google-Smtp-Source: APXvYqx8JhnLcG/AbC5KGm4JCW+hiB8dI9ieX/rv2as8530B7v313xvNTNqbzpOpnL9dbhZy3rEvNQ==
X-Received: by 2002:a63:490d:: with SMTP id w13mr17920404pga.355.1560376078286;
        Wed, 12 Jun 2019 14:47:58 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id j11sm515208pfa.2.2019.06.12.14.47.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 14:47:57 -0700 (PDT)
Date:   Wed, 12 Jun 2019 14:47:57 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: Add test for SO_REUSEPORT_DETACH_BPF
Message-ID: <20190612214757.GC9056@mini-arch>
References: <20190612190536.2340077-1-kafai@fb.com>
 <20190612190539.2340343-1-kafai@fb.com>
 <20190612195917.GB9056@mini-arch>
 <20190612213046.e7tkduk5nfuv5s6a@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612213046.e7tkduk5nfuv5s6a@kafai-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12, Martin Lau wrote:
> On Wed, Jun 12, 2019 at 12:59:17PM -0700, Stanislav Fomichev wrote:
> > On 06/12, Martin KaFai Lau wrote:
> > > This patch adds a test for the new sockopt SO_REUSEPORT_DETACH_BPF.
> > > 
> > > '-I../../../../usr/include/' is added to the Makefile to get
> > > the newly added SO_REUSEPORT_DETACH_BPF.
> > > 
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  tools/testing/selftests/bpf/Makefile          |  1 +
> > >  .../selftests/bpf/test_select_reuseport.c     | 50 +++++++++++++++++++
> > >  2 files changed, 51 insertions(+)
> > > 
> > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > > index 44fb61f4d502..c7370361fa81 100644
> > > --- a/tools/testing/selftests/bpf/Makefile
> > > +++ b/tools/testing/selftests/bpf/Makefile
> > > @@ -16,6 +16,7 @@ LLVM_OBJCOPY	?= llvm-objcopy
> > >  LLVM_READELF	?= llvm-readelf
> > >  BTF_PAHOLE	?= pahole
> > >  CFLAGS += -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(GENDIR) $(GENFLAGS) -I../../../include \
> > > +	  -I../../../../usr/include/ \
> > Why not copy inlude/uapi/asm-generic/socket.h into tools/include
> > instead? Will that work?
> Sure. I am ok with copy.  I don't think we need to sync very often.
> Do you know how to do that considering multiple arch's socket.h
> have been changed in Patch 1?
No, I don't know how to handle arch specific stuff. I suggest to copy
asm-generic and have ifdefs in the tests if someone complains :-)

> Is copy better?
Doesn't ../../../../usr/include provide the same headers we have in
tools/include/uapi? If you add -I../../../../usr/include, then is there
a point of having copies under tools/include/uapi? I don't really
know why we keep the copies under tools/include/uapi rather than including
../../../usr/include directly.

> > >  	  -Dbpf_prog_load=bpf_prog_test_load \
> > >  	  -Dbpf_load_program=bpf_test_load_program
> > >  LDLIBS += -lcap -lelf -lrt -lpthread
> > > diff --git a/tools/testing/selftests/bpf/test_select_reuseport.c b/tools/testing/selftests/bpf/test_select_reuseport.c
> > > index 75646d9b34aa..5aa00b4a4702 100644
> > > --- a/tools/testing/selftests/bpf/test_select_reuseport.c
> > > +++ b/tools/testing/selftests/bpf/test_select_reuseport.c
> > > @@ -523,6 +523,54 @@ static void test_pass_on_err(int type, sa_family_t family)
> > >  	printf("OK\n");
> > >  }
> > >  
> > > +static void test_detach_bpf(int type, sa_family_t family)
> > > +{
> > > +	__u32 nr_run_before = 0, nr_run_after = 0, tmp, i;
> > > +	struct epoll_event ev;
> > > +	int cli_fd, err, nev;
> > > +	struct cmd cmd = {};
> > > +	int optvalue = 0;
> > > +
> > > +	printf("%s: ", __func__);
> > > +	err = setsockopt(sk_fds[0], SOL_SOCKET, SO_DETACH_REUSEPORT_BPF,
> > > +			 &optvalue, sizeof(optvalue));
> > > +	CHECK(err == -1, "setsockopt(SO_DETACH_REUSEPORT_BPF)",
> > > +	      "err:%d errno:%d\n", err, errno);
> > > +
> > > +	err = setsockopt(sk_fds[1], SOL_SOCKET, SO_DETACH_REUSEPORT_BPF,
> > > +			 &optvalue, sizeof(optvalue));
> > > +	CHECK(err == 0 || errno != ENOENT, "setsockopt(SO_DETACH_REUSEPORT_BPF)",
> > > +	      "err:%d errno:%d\n", err, errno);
> > > +
> > > +	for (i = 0; i < NR_RESULTS; i++) {
> > > +		err = bpf_map_lookup_elem(result_map, &i, &tmp);
> > > +		CHECK(err == -1, "lookup_elem(result_map)",
> > > +		      "i:%u err:%d errno:%d\n", i, err, errno);
> > > +		nr_run_before += tmp;
> > > +	}
> > > +
> > > +	cli_fd = send_data(type, family, &cmd, sizeof(cmd), PASS);
> > > +	nev = epoll_wait(epfd, &ev, 1, 5);
> > > +	CHECK(nev <= 0, "nev <= 0",
> > > +	      "nev:%d expected:1 type:%d family:%d data:(0, 0)\n",
> > > +	      nev,  type, family);
> > > +
> > > +	for (i = 0; i < NR_RESULTS; i++) {
> > > +		err = bpf_map_lookup_elem(result_map, &i, &tmp);
> > > +		CHECK(err == -1, "lookup_elem(result_map)",
> > > +		      "i:%u err:%d errno:%d\n", i, err, errno);
> > > +		nr_run_after += tmp;
> > > +	}
> > > +
> > > +	CHECK(nr_run_before != nr_run_after,
> > > +	      "nr_run_before != nr_run_after",
> > > +	      "nr_run_before:%u nr_run_after:%u\n",
> > > +	      nr_run_before, nr_run_after);
> > > +
> > > +	printf("OK\n");
> > > +	close(cli_fd);
> > > +}
> > > +
> > >  static void prepare_sk_fds(int type, sa_family_t family, bool inany)
> > >  {
> > >  	const int first = REUSEPORT_ARRAY_SIZE - 1;
> > > @@ -664,6 +712,8 @@ static void test_all(void)
> > >  			test_pass(type, family);
> > >  			test_syncookie(type, family);
> > >  			test_pass_on_err(type, family);
> > > +			/* Must be the last test */
> > > +			test_detach_bpf(type, family);
> > >  
> > >  			cleanup_per_test();
> > >  			printf("\n");
> > > -- 
> > > 2.17.1
> > > 
