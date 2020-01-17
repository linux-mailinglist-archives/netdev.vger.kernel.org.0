Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC311413B0
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 22:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgAQVwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 16:52:03 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34037 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAQVwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 16:52:03 -0500
Received: by mail-qt1-f196.google.com with SMTP id 5so22974638qtz.1;
        Fri, 17 Jan 2020 13:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LXFr+Oe+DVTEU1iGCR5ab4LZThTsrbbCxkzxMkJjD5c=;
        b=SCKFYcXAx2pYOkg8sBdmA6UuPGSAN4IeyL1Dz/KSEDe5j/IrkXBa5bXmt6hFX6UhDM
         2YYiUQFJw+8eXd/z3QSihMEyOYslWrk5vlX3iUsqa28FTs+P7NiNAIdO8+kQMfhKOa5H
         G7pz4MTfa/UlimYFKtDwhRX73LJsP1FnpKiQhV+JY3QcgfU0G6tLwr57mRjBknDU4y47
         msMgfAq7oc+VegMblw7Xw8uk64413y5aq2GWD0MMhStKrj5p3zliEbHRu6HeTHyN57wx
         o2FQQesMgQvTTsSRJew4/ERaY6H8GFbehj5A6j6jBrRm5YSlchBa5enyuQgApmiUP4/y
         WIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LXFr+Oe+DVTEU1iGCR5ab4LZThTsrbbCxkzxMkJjD5c=;
        b=IVE0bbXgttmXNRct/wh81V6UOn9dEQmxsO+4cbkPjdklvcBJOAxXdg0Z2NMoDv/zIi
         RipZWrXV9uRwr5nszgNLdOab6ICUkEfn6vmDSnBzffkNXlnBtonXCYutw1pQGg7LV57F
         RV0E9fO5VbEvfvFvtGb4cde1gGPbY05lNdsHxLQAB36ed3rSDhNUVDVuew+qXKPSgmEL
         PxyfCTtUCjEYLRuFw4EbL1O6btZu89SwlC5Lm968Ep8FER2mIMJUexlB2TyPitUXfw+M
         Mhd1sUS7DYdk1dEJM5HfVKZfFYvpvCeSDPrhxDAXhF/KHS/0aMdC5Jbhnir8crEEdMc4
         kx9g==
X-Gm-Message-State: APjAAAVpP+UumZjTsAKAHfNXmm77q7caJ7L13k4Q5leD3DevjikrY+aF
        U4t+//4Neecmaxoy9fwxxCaKR1G9DjY07JkYnik=
X-Google-Smtp-Source: APXvYqzPEH9j5BfkpS6SL5DHwqfsDvCoAE4QyeeHElbCapqNYQ1YI48ORniseUuBtLPs6QBmFuL8F8zVKIchHdd54ls=
X-Received: by 2002:ac8:7b29:: with SMTP id l9mr9364164qtu.141.1579297921555;
 Fri, 17 Jan 2020 13:52:01 -0800 (PST)
MIME-Version: 1.0
References: <157926819690.1555735.10756593211671752826.stgit@toke.dk> <157926820131.1555735.1177228853838027248.stgit@toke.dk>
In-Reply-To: <157926820131.1555735.1177228853838027248.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Jan 2020 13:51:50 -0800
Message-ID: <CAEf4BzbAV0TmEUL=62jz+RD6SPmu927z-dhGL9JHepcAOGMSJA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 04/10] tools/runqslower: Use consistent
 include paths for libbpf
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 5:37 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Fix the runqslower tool to include libbpf header files with the bpf/
> prefix, to be consistent with external users of the library. Also ensure
> that all includes of exported libbpf header files (those that are exporte=
d
> on 'make install' of the library) use bracketed includes instead of quote=
d.
>
> To not break the build, keep the old include path until everything has be=
en
> changed to the new one; a subsequent patch will remove that.
>
> Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken f=
rom selftests dir")
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/bpf/runqslower/Makefile         |    5 +++--
>  tools/bpf/runqslower/runqslower.bpf.c |    2 +-
>  tools/bpf/runqslower/runqslower.c     |    4 ++--
>  3 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefil=
e
> index b62fc9646c39..9f022f7f2593 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -5,6 +5,7 @@ LLC :=3D llc
>  LLVM_STRIP :=3D llvm-strip
>  DEFAULT_BPFTOOL :=3D $(OUTPUT)/sbin/bpftool
>  BPFTOOL ?=3D $(DEFAULT_BPFTOOL)
> +INCLUDES :=3D -I$(OUTPUT) -I$(abspath ../../lib) -I$(abspath ../../lib/b=
pf)
>  LIBBPF_SRC :=3D $(abspath ../../lib/bpf)

drop LIBBPF_SRC, it's not used anymore

>  CFLAGS :=3D -g -Wall
>
> @@ -51,13 +52,13 @@ $(OUTPUT)/%.skel.h: $(OUTPUT)/%.bpf.o | $(BPFTOOL)
>
>  $(OUTPUT)/%.bpf.o: %.bpf.c $(OUTPUT)/libbpf.a | $(OUTPUT)
>         $(call msg,BPF,$@)
> -       $(Q)$(CLANG) -g -O2 -target bpf -I$(OUTPUT) -I$(LIBBPF_SRC)      =
     \
> +       $(Q)$(CLANG) -g -O2 -target bpf $(INCLUDES)           \

please preserve formatting and alignment conventions of a file

>                  -c $(filter %.c,$^) -o $@ &&                            =
     \
>         $(LLVM_STRIP) -g $@
>
>  $(OUTPUT)/%.o: %.c | $(OUTPUT)
>         $(call msg,CC,$@)
> -       $(Q)$(CC) $(CFLAGS) -I$(LIBBPF_SRC) -I$(OUTPUT) -c $(filter %.c,$=
^) -o $@
> +       $(Q)$(CC) $(CFLAGS) $(INCLUDES) -c $(filter %.c,$^) -o $@
>
>  $(OUTPUT):

[...]
