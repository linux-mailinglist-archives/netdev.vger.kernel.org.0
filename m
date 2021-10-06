Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079E54245ED
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhJFSWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhJFSWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 14:22:50 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AD0C061746;
        Wed,  6 Oct 2021 11:20:58 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id q189so7558800ybq.1;
        Wed, 06 Oct 2021 11:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p0oPqIp7KvFrHTyZh7IK9NyLd4cc/B09chGykvbilI0=;
        b=VApVL8UGqSIM98iCIn7+Y0Kch8hm98caoGxhv+PX5gRgOYwrID4t9FCcp4ZDjh93Fi
         PjcMTtnZFWlzCPfyUnVS3IEiWjHLmgwixpz6b1gdrA4/p7xs1uXvcylNMAonv/Hivt8R
         f3XwTCdfpnOnLSx8FIe5s+ShL+4DT4WbL3s8JWtRjW/N4aiiuPKWMPGdW3RUh/DrlDWU
         5ZBh/pj+7eLwRKasorSbmiLSQwa9r+X3GoQItsO7Df8fuYveZxKHaNvHEdSB+IKZDdV4
         oqBzzuf2EADKsPkzpPAt1O5MLlIIpxWiLD1C0a/XsJA/waCHaTaBHwDmC/0tRtC/yPGu
         Fjjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p0oPqIp7KvFrHTyZh7IK9NyLd4cc/B09chGykvbilI0=;
        b=Sgp5vNgfiibvGMGNsI6EG7eeApES2oqFMy0UvRNuzYS8xNK+XcKUeaHoV5k0x5VpQH
         OsLg8CERp88bPiDikeSNrcyI1JwIC2nVAGtkECt0OWoBybOf/bW2JvqwiqV7Um6jQ0M6
         NzT+ur1nI1114LyLO4JYCOPHNPZqBhRVgeabWynwm0H9dErqR7yu4alUnjZDvP8z228A
         +eQmyAtOQt/MRhW3GWi0z1mHCKWv0m4s+52YaeeVGaYlpfTxvxdi7KnWNZwLEyspadjc
         wx1RszwWkCEDv6KiBLehqbXJ2eyYvNktTCzq0NU9QzaV7iNvk0uK59pgCDVLIpvXfw3m
         r6jg==
X-Gm-Message-State: AOAM531KjWhqKXgPg0i2sGkuM96uD5RxVGTRjyzmiZPatg8C7NE+9EAM
        g0/p9R2eQsEFkKUgAFcbthbUeqgBpXWVhqcbC0Y=
X-Google-Smtp-Source: ABdhPJyvV9zirzKsGEaGZ/Tt1p8nAafgTn0aX+zS1vXXzfnEUyN7BIU2TaMuyuP9nnAXgW8Pg8qFtQwtyJBuVQahGOo=
X-Received: by 2002:a25:7c42:: with SMTP id x63mr32489404ybc.225.1633544457543;
 Wed, 06 Oct 2021 11:20:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211003192208.6297-1-quentin@isovalent.com> <20211003192208.6297-5-quentin@isovalent.com>
In-Reply-To: <20211003192208.6297-5-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Oct 2021 11:20:46 -0700
Message-ID: <CAEf4Bza4y5DjJfxQYDJEALQh+3SaukPtNJVLaLdMZK-SgpDpyw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 04/10] tools: runqslower: install libbpf
 headers when building
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 3, 2021 at 12:22 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> API headers from libbpf should not be accessed directly from the
> library's source directory. Instead, they should be exported with "make
> install_headers". Let's make sure that runqslower installs the
> headers properly when building.
>
> We use a libbpf_hdrs target to mark the logical dependency on libbpf's
> headers export for a number of object files, even though the headers
> should have been exported at this time (since bpftool needs them, and is
> required to generate the skeleton or the vmlinux.h).
>
> When descending from a parent Makefile, the specific output directories
> for building the library and exporting the headers are configurable with
> BPFOBJ_OUTPUT and BPF_DESTDIR, respectively. This is in addition to
> OUTPUT, on top of which those variables are constructed by default.
>
> Also adjust the Makefile for the BPF selftests. We pass a number of
> variables to the "make" invocation, because we want to point runqslower
> to the (target) libbpf shared with other tools, instead of building its
> own version. In addition, runqslower relies on (target) bpftool, and we
> also want to pass the proper variables to its Makefile so that bpftool
> itself reuses the same libbpf.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/runqslower/Makefile        | 22 +++++++++++++---------
>  tools/testing/selftests/bpf/Makefile | 15 +++++++++------
>  2 files changed, 22 insertions(+), 15 deletions(-)
>
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
> index 3818ec511fd2..049aef7e9a4c 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -9,9 +9,9 @@ BPFTOOL ?= $(DEFAULT_BPFTOOL)
>  LIBBPF_SRC := $(abspath ../../lib/bpf)
>  BPFOBJ_OUTPUT := $(OUTPUT)libbpf/
>  BPFOBJ := $(BPFOBJ_OUTPUT)libbpf.a
> -BPF_INCLUDE := $(BPFOBJ_OUTPUT)
> -INCLUDES := -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../lib)        \
> -       -I$(abspath ../../include/uapi)
> +BPF_DESTDIR := $(BPFOBJ_OUTPUT)
> +BPF_INCLUDE := $(BPF_DESTDIR)/include
> +INCLUDES := -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../include/uapi)
>  CFLAGS := -g -Wall
>
>  # Try to detect best kernel BTF source
> @@ -33,7 +33,7 @@ endif
>
>  .DELETE_ON_ERROR:
>
> -.PHONY: all clean runqslower
> +.PHONY: all clean runqslower libbpf_hdrs
>  all: runqslower
>
>  runqslower: $(OUTPUT)/runqslower
> @@ -46,13 +46,15 @@ clean:
>         $(Q)$(RM) $(OUTPUT)runqslower
>         $(Q)$(RM) -r .output
>
> +libbpf_hdrs: $(BPFOBJ)
> +
>  $(OUTPUT)/runqslower: $(OUTPUT)/runqslower.o $(BPFOBJ)
>         $(QUIET_LINK)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
>
>  $(OUTPUT)/runqslower.o: runqslower.h $(OUTPUT)/runqslower.skel.h             \
> -                       $(OUTPUT)/runqslower.bpf.o
> +                       $(OUTPUT)/runqslower.bpf.o libbpf_hdrs

this phony dependency will cause runqslower.o to be always rebuilt,
try running make multiple times with no changes inside
tools/bpf/runqslower. Can this be done just as an order-only
dependency?

>
> -$(OUTPUT)/runqslower.bpf.o: $(OUTPUT)/vmlinux.h runqslower.h
> +$(OUTPUT)/runqslower.bpf.o: $(OUTPUT)/vmlinux.h runqslower.h libbpf_hdrs
>
>  $(OUTPUT)/%.skel.h: $(OUTPUT)/%.bpf.o | $(BPFTOOL)
>         $(QUIET_GEN)$(BPFTOOL) gen skeleton $< > $@

[...]
