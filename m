Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE22180BD0
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgCJWpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:45:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39200 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgCJWpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:45:01 -0400
Received: by mail-wr1-f67.google.com with SMTP id r15so120378wrx.6
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 15:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hp63GFBquLZvxHinfdQn0l+7Q9Gi6MS0Yk5ATc9wmTk=;
        b=C4EysRvPHbtOghHN8n2LpmsLBWVcEB7oBzXggk1+lxPerOAXNtBT1uCFYoGUkhMZmk
         EydzZX2HkG57tRIsgwzPj1rixEju0OA5UaxLhAaUvsz1VFcS5Kzwi24++Bs1sbNT/vAV
         KLmKL9YysvSClpoXNX0p/6TQ8JDbD5BvKhgpfwPPqFrrTPkKm4PwNVC1tmgeZhPMYuhQ
         PxS+AjOe9sboObW/SNYjnWJzmxJDBgLx31nZVn4FUKFSAzELKscBn6BnyZ53JocK5/BN
         JI9R0tLMXq7oRqbIr81lBA4g/eJz3SUy/iOe6HWrtcQP6p3sjHNS7Qd/DzrR0TmTbpNK
         J5wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hp63GFBquLZvxHinfdQn0l+7Q9Gi6MS0Yk5ATc9wmTk=;
        b=iDhlV3ICJTuxdQdroYTpmoPN0pxw9sIyKNT8vdNZyS/8ckQ/rD7V9+tyJnQCYVx/FY
         kafUcvMjok9DxbrdxNKKKPWMyvOBvBVpbshYmMNnaDRrh6EsRwBOjsatGgTNHNnN0qsy
         MSn7qTEVBh4jDE0dhH/v0LBxjCziivtuIlzngMnSGbp74MQ6rR/4ltq3ATVEg4iyVuIi
         locVXU8V3P6EQ3HCsu+O7hpuVKbnTBnYLpV5uQ8xTCW/AKmerXQGtn5T8oEvdhQ7b/pL
         u+5sLS9NtnCqSacyedSbOhq4ch8N6o5trjEn6WBk97yvMa6CQvmd64uWsHO6dtAGOq4j
         UvlQ==
X-Gm-Message-State: ANhLgQ3bVcQ2TfQ/g6BFlxLFhoeREY8c0+Uj+cIob5SPy0doDrXad50s
        Gr1yFaSeHvC0MIMEnmZRO/UeKw==
X-Google-Smtp-Source: ADFU+vvhzFsisVgEP5fGQJxIakoTN01caL8b7nPNYF0nZWNiDGs1+9599Udssmc75j4hCjP8y8YbcQ==
X-Received: by 2002:a05:6000:118c:: with SMTP id g12mr85323wrx.341.1583880299150;
        Tue, 10 Mar 2020 15:44:59 -0700 (PDT)
Received: from [192.168.1.10] ([194.35.118.214])
        by smtp.gmail.com with ESMTPSA id 9sm6066445wmx.32.2020.03.10.15.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 15:44:58 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/2] bpftool: only build bpftool-prog-profile
 with clang >= v11
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, daniel@iogearbox.net,
        arnaldo.melo@gmail.com, jolsa@kernel.org
References: <20200310183624.441788-1-songliubraving@fb.com>
 <20200310183624.441788-2-songliubraving@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <65be9b45-059a-fc41-fd47-a6b9d7cda418@isovalent.com>
Date:   Tue, 10 Mar 2020 22:44:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200310183624.441788-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-03-10 11:36 UTC-0700 ~ Song Liu <songliubraving@fb.com>
> bpftool-prog-profile requires clang of version 11.0.0 or newer. If
> bpftool is built with older clang, show a hint of to the user.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  tools/bpf/bpftool/Makefile | 13 +++++++++++--
>  tools/bpf/bpftool/prog.c   |  2 ++
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index 20a90d8450f8..05a37f0f76a9 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -60,6 +60,15 @@ LIBS = $(LIBBPF) -lelf -lz
>  INSTALL ?= install
>  RM ?= rm -f
>  CLANG ?= clang
> +CLANG_VERS = $(shell $(CLANG) --version | head -n 1 | awk '{print $$3}')
> +CLANG_MAJ = $(shell echo $(CLANG_VERS) | cut -d '.' -f 1)

This will produce error messages on stderr if clang is not installed on
the system.

> +WITHOUT_SKELETONS = -DBPFTOOL_WITHOUT_SKELETONS
> +
> +ifeq ($(shell test $(CLANG_MAJ) -ge 11; echo $$?),0)

Not exactly what I had in mind. I thought about the feature detection
facility we have under tools/build/feature/, as is used for e.g.
detecting libbfd. It would allow to check the feature is available,
instead of tying the build to a numeric version number. But that's more
work to do, so I suppose this version can work, too...

> +	PROG_FLAGS =
> +else
> +	PROG_FLAGS = $(WITHOUT_SKELETONS)
> +endif
>  
>  FEATURE_USER = .bpftool
>  FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
> @@ -114,7 +123,7 @@ OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
>  _OBJS = $(filter-out $(OUTPUT)prog.o,$(OBJS)) $(OUTPUT)_prog.o
>  
>  $(OUTPUT)_prog.o: prog.c
> -	$(QUIET_CC)$(COMPILE.c) -MMD -DBPFTOOL_WITHOUT_SKELETONS -o $@ $<
> +	$(QUIET_CC)$(COMPILE.c) -MMD $(WITHOUT_SKELETONS) -o $@ $<
>  
>  $(OUTPUT)_bpftool: $(_OBJS) $(LIBBPF)
>  	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(_OBJS) $(LIBS)
> @@ -126,7 +135,7 @@ profiler.skel.h: $(OUTPUT)_bpftool skeleton/profiler.bpf.o
>  	$(QUIET_GEN)$(OUTPUT)./_bpftool gen skeleton skeleton/profiler.bpf.o > $@
>  
>  $(OUTPUT)prog.o: prog.c profiler.skel.h
> -	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
> +	$(QUIET_CC)$(COMPILE.c) -MMD $(PROG_FLAGS) -o $@ $<

Would be nice to find a way to skip the second build if it is not needed?

>  
>  $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
>  	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 576ddd82bc96..5db378d5d970 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -1545,6 +1545,8 @@ static int do_loadall(int argc, char **argv)
>  
>  static int do_profile(int argc, char **argv)
>  {
> +	fprintf(stdout, "bpftool prog profile command is not supported.\n"
> +		"Please recompile bpftool with clang >= 11.0.0\n");

p_err()?

>  	return 0;
>  }
>  
> 

Thanks a lot for the follow-up!
Quentin
