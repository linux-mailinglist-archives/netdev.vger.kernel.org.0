Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F98A38D7B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 16:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbfFGOjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 10:39:02 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34394 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728699AbfFGOjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 10:39:02 -0400
Received: by mail-qt1-f196.google.com with SMTP id m29so2532308qtu.1
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 07:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I6Vo/0BQbeVOQIU2II6ANL7fw8IZQXHZ3ofS+Wbw2iM=;
        b=t7ciDZMWEN4uFEwkBu3XhfxO00cpYxCwEvm3eSDwsKGCEMOmhBaOG5ZLTaKQpmI3fv
         DMS4vvDVv7Bj1nejX3DXVrEo0MU736ABNq165Hp5XOx4gO/hGxK0TcSWTBsBJ7A0mbf7
         4rTvF2JIjkcZD+YzcBJ/4sfbFj1ElP2OQPUbNp1bOiA0SkVw7Te6WxerYSvsxmw0UYOl
         ajh/c7YlFwW2juSIdwU9pF7Y0tkVO4z7NTkEez5sEXcfrEowgoC/aJi1UEdd5NvE55+p
         TPUYylhz0NCyGOylFKP2gKmGAyMRW5wHx3CBWwaVgFeDYZtdxdyZnScyD42qZh7L1v4k
         Z9Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=I6Vo/0BQbeVOQIU2II6ANL7fw8IZQXHZ3ofS+Wbw2iM=;
        b=MQMK7ABHIBDpGd+sBR/9ghv0wqRavAaixs7duNZecIwIm77fYC+8ZHceYBGF2womfE
         c99tq6zWZo/mMG8k3Tz29KBICFvvuz4u9pqD41f7RcOKbRUxWwZEY1E3aA7vgAgIIOIB
         p1zbePKRblhrJ6hfCtpWAa9SccokOuth2Cvh/KcEcFrjQ62eXs0Uw3KjPGB7yH9LZgNl
         kRqp2Cegj8r4Vbr8bwvurW7ilDuYHWjyehQXsA1Laz26Qt/RclJuG08mvOd3rLWjsm4o
         Uf8cBAXAYcGTWQWToeCOLKoPyDX2vGq2c53tWL4pznDWRv2VF7XO1g4d67U2uE+8iAK/
         i15Q==
X-Gm-Message-State: APjAAAVEyBeSEDxf8hsLQOqLRu3KyUwN9JZemVRSc12057ayA51GZgmC
        3GNs7kM/VtFdd6GrfUn6uEEHNw==
X-Google-Smtp-Source: APXvYqzwMI+9SOSqjmaaTm/028fJXoeCC6JvnHEJGe3K0nGoj7mPi0aT119mPcB+bjuwt62hBqe0FA==
X-Received: by 2002:a0c:9acb:: with SMTP id k11mr44200846qvf.85.1559918341516;
        Fri, 07 Jun 2019 07:39:01 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li1322-146.members.linode.com. [45.79.223.146])
        by smtp.gmail.com with ESMTPSA id s23sm387152qtk.31.2019.06.07.07.38.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Jun 2019 07:39:00 -0700 (PDT)
Date:   Fri, 7 Jun 2019 22:38:49 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2 4/4] perf augmented_raw_syscalls: Document clang
 configuration
Message-ID: <20190607143849.GI5970@leoy-ThinkPad-X240s>
References: <20190606094845.4800-1-leo.yan@linaro.org>
 <20190606094845.4800-5-leo.yan@linaro.org>
 <20190606140800.GF30166@kernel.org>
 <20190606143532.GD5970@leoy-ThinkPad-X240s>
 <20190606182941.GE21245@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606182941.GE21245@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnaldo,

On Thu, Jun 06, 2019 at 03:29:41PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jun 06, 2019 at 10:35:32PM +0800, Leo Yan escreveu:
> > On Thu, Jun 06, 2019 at 11:08:00AM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Thu, Jun 06, 2019 at 05:48:45PM +0800, Leo Yan escreveu:
> > > > To build this program successfully with clang, there have three
> > > > compiler options need to be specified:
> > > > 
> > > >   - Header file path: tools/perf/include/bpf;
> > > >   - Specify architecture;
> > > >   - Define macro __NR_CPUS__.
> > > 
> > > So, this shouldn't be needed, all of this is supposed to be done
> > > automagically, have you done a 'make -C tools/perf install'?
> > 
> > I missed the up operation.  But after git pulled the lastest code base
> > from perf/core branch and used the command 'make -C tools/perf
> > install', I still saw the eBPF build failure.
> > 
> > Just now this issue is fixed after I removed the config
> > 'clang-bpf-cmd-template' from ~/.perfconfig;  the reason is I followed
> > up the Documentation/perf-config.txt to set the config as below:
> > 
> >   clang-bpf-cmd-template = "$CLANG_EXEC -D__KERNEL__ $CLANG_OPTIONS \
> >                           $KERNEL_INC_OPTIONS -Wno-unused-value \
> >                           -Wno-pointer-sign -working-directory \
> >                           $WORKING_DIR -c $CLANG_SOURCE -target bpf \
> >                           -O2 -o -"
> > 
> > In fact, util/llvm-utils.c has updated the default configuration as
> > below:
> > 
> >   #define CLANG_BPF_CMD_DEFAULT_TEMPLATE                          \
> >                 "$CLANG_EXEC -D__KERNEL__ -D__NR_CPUS__=$NR_CPUS "\
> >                 "-DLINUX_VERSION_CODE=$LINUX_VERSION_CODE "     \
> >                 "$CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OPTIONS " \
> >                 "-Wno-unused-value -Wno-pointer-sign "          \
> >                 "-working-directory $WORKING_DIR "              \
> >                 "-c \"$CLANG_SOURCE\" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE"
> > 
> > Maybe should update Documentation/perf-config.txt to tell users the
> > real default value of clang-bpf-cmd-template?
> 
> Sure, if you fell like doing this, please update and also please figure
> out when the this changed and add a Fixes: that cset,

Thanks for guidance.  Have sent patch for this [1].

> Its great that you're going thru the docs and making sure the
> differences are noted so that we update the docs, thanks a lot!

You are welcome!

Thanks,
Leo Yan

[1] https://lkml.org/lkml/2019/6/7/477
