Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C256D433
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 20:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbfGRSvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 14:51:16 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46964 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRSvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 14:51:16 -0400
Received: by mail-qk1-f193.google.com with SMTP id r4so21259625qkm.13
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 11:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=xrQ/bbDMj21bUeVcFnWSmUXf/O7cNdfCHighrHvHoI0=;
        b=jBFZZbToJvZv1Voeboc179pCovvsFcPAM6FN6PpRwbvOGPcdxvLYhdT36uPQ3+ab2s
         uAxTg9RbtRABfM19pSg+ccyFdQoRMMWGfd7M7sNUJPYFNgdgSZvldavCrdUVHvRiPZFU
         bfGgzMklPbaYw9WWsYomlKwspDBeJVv5fNhjf+S8BeiKht1WOSA0OWILuNw3iSV+7IL/
         NtgHaF2O/Vb8pMgkWpTdxIGw9C1zDVUdc0KfpYzLmR+d2vt2oeVeKDs1ZdgNVqAIMkxH
         qpNkQet9LXRMPoKp1fnPbRu8BdjN6wvcRsRtPWN66BDURcPBaDrwyzfD8OZtbJNebZtb
         icng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xrQ/bbDMj21bUeVcFnWSmUXf/O7cNdfCHighrHvHoI0=;
        b=iRGpe2o5zmW2B1Y6ul60cUO2o6c7nJsc+E/l12SCxG4e5T6GDLscWT4kJDpIkztnot
         NrUhF5OH5/NTQ/xDHnJ4rIrwcBKWRUKHTbm0aMWtrSwM3gD/J66N2uJAYJAaO2fK6LiJ
         CxUT++urmg1f1ZiHLXwt8ectdB5OR+A4kDh0NCoUMZ20txSSlMIWU8pN7o8v95JRQ33Z
         ytlmNUEsMp9owsx8wEeR5wQk8QXI8RiSAf05EIINuRgNiviTNj99FtC4j00zM2S5dY81
         IQ7rWOiC0YMdg6FmgFSHiP5tz2/D6CWaYfI3h69Z2XEqmUcopvkJn8lVN4kOPEw3l3YS
         7UYA==
X-Gm-Message-State: APjAAAXzQd+560e/d26DldleL6qvAXEKtumdC7zYDh0StNgEoAQ5wZ7B
        wawvzx+gqy1erUYDr4ld9a9e3Q==
X-Google-Smtp-Source: APXvYqxnT7T2+1phCJV6S1N4oIIkYPeZjwYCVH5mwlJDsGl9qPLI8l6pJkqZY9ZKz3FCgQ5VDfjCDg==
X-Received: by 2002:ae9:ed4f:: with SMTP id c76mr31917577qkg.154.1563475875491;
        Thu, 18 Jul 2019 11:51:15 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x2sm12741230qkc.92.2019.07.18.11.51.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 11:51:15 -0700 (PDT)
Date:   Thu, 18 Jul 2019 11:51:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, lmb@cloudflare.com,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH bpf] tools/bpf: fix bpftool build with OUTPUT set
Message-ID: <20190718115111.643027cf@cakuba.netronome.com>
In-Reply-To: <20190718142041.83342-1-iii@linux.ibm.com>
References: <CACAyw9-CWRHVH3TJ=Tke2x8YiLsH47sLCijdp=V+5M836R9aAA@mail.gmail.com>
        <20190718142041.83342-1-iii@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jul 2019 16:20:41 +0200, Ilya Leoshkevich wrote:
> Hi Lorenz,
> 
> I've been using the following patch for quite some time now.
> Please let me know if it works for you.
> 
> Best regards,
> Ilya
> 
> ---
> 
> When OUTPUT is set, bpftool and libbpf put their objects into the same
> directory, and since some of them have the same names, the collision
> happens.
> 
> Fix by invoking libbpf build in a manner similar to $(call descend) -
> descend itself cannot be used, since libbpf is a sibling, and not a
> child, of bpftool.
> 
> Also, don't link bpftool with libbpf.a twice.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  tools/bpf/bpftool/Makefile | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index a7afea4dec47..2cbc3c166f44 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -15,23 +15,18 @@ else
>  endif
>  
>  BPF_DIR = $(srctree)/tools/lib/bpf/
> -
> -ifneq ($(OUTPUT),)
> -  BPF_PATH = $(OUTPUT)
> -else
> -  BPF_PATH = $(BPF_DIR)
> -endif
> -
> -LIBBPF = $(BPF_PATH)libbpf.a
> +BPF_PATH = $(objtree)/tools/lib/bpf

objtree won't be set for simple make in the directory. Perhaps we
should stick to using OUTPUT and srctree?

We should probably make a script with all the ways of calling make
should work. Otherwise we can lose track too easily.

# thru kbuild
make tools/bpf

T=$(mktemp -d)
make tools/bpf OUTPUT=$T
rm -rf $T

# from kernel source tree
make -C tools/bpf/bpftool

T=$(mktemp -d)
make -C tools/bpf/bpftool OUTPUT=$T
rm -rf $T

# from tools
cd tools/
make bpf

T=$(mktemp -d)
make bpf OUTPUT=$T
rm -rf $T

# from bpftool's dir
cd bpf/bpftool
make

T=$(mktemp -d)
make OUTPUT=$T
rm -rf $T

.. add your own.

> +LIBBPF = $(BPF_PATH)/libbpf.a
>  
>  BPFTOOL_VERSION := $(shell make --no-print-directory -sC ../../.. kernelversion)
>  
>  $(LIBBPF): FORCE
> -	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(OUTPUT) $(OUTPUT)libbpf.a
> +	$(Q)mkdir -p $(BPF_PATH)
> +	$(Q)$(MAKE) $(COMMAND_O) subdir=tools/lib/bpf -C $(BPF_DIR) $(LIBBPF)
>  
>  $(LIBBPF)-clean:
>  	$(call QUIET_CLEAN, libbpf)
> -	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(OUTPUT) clean >/dev/null
> +	$(Q)$(MAKE) $(COMMAND_O) subdir=tools/lib/bpf -C $(BPF_DIR) clean >/dev/null
>  
>  prefix ?= /usr/local
>  bash_compdir ?= /usr/share/bash-completion/completions
> @@ -112,7 +107,7 @@ $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
>  	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
>  
>  $(OUTPUT)bpftool: $(OBJS) $(LIBBPF)
> -	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
> +	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
>  
>  $(OUTPUT)%.o: %.c
>  	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<

