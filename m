Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAF520F81D
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 17:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389381AbgF3PSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 11:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729565AbgF3PSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 11:18:23 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9BCC061755;
        Tue, 30 Jun 2020 08:18:23 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id e3so3110309qvo.10;
        Tue, 30 Jun 2020 08:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+FSu8z0tCpTjTyhcFsYCancQEtUH7C/nlaNSLslO+iw=;
        b=ec2eHS/2YLc02lNvg090m2cz2nGDnBKDS3AFAzeK26DYHpGAuZa/YGNbP4LuZzthtE
         vG2OEFrDZQHL3vqgDt+chyeGPwHdZYoIfLoA+P2tEjMepo7sZVd9qxUUenEzehz9LIYZ
         HDJyZiSi4dJKnkDj4/t7Rf1FKDHYzFoOv4RdNtq3ZKiVXSivsG0YxlxAFZqOPXHgocC2
         UDr7Rb+rlBuPnOqhiLdRp/pVO0omyZz5ceVVECl9vs7nlJMjCnztSrmNdOpuM8K3oUI/
         ItwLdsz6DVLCInU+0CTSZf3vrLeUFgQnMB0Mht/C/FH0sFNITCNNf7WONaLBslBSIB6E
         RRhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+FSu8z0tCpTjTyhcFsYCancQEtUH7C/nlaNSLslO+iw=;
        b=g8SO69FYb1VCSCRhuED/aXRxI3xgTC+pFor1T5PfmzHie08XeD2/EXvqK8vCSYMBgx
         qI4iaOb7GBMAHXEpE1joQypxBs3T5zPf5xDk/oVnHSGPOGopkNHIYLxHvs2VdgY3K9Ah
         BZtEnYVKVAcG1wlrWPh1fUj0djNThEXOW8WHqYsivv0auHOYzLEFNhvbRkUSgXufjHpY
         5vRZe+IwnAOv8S3z8RmdrQ1DrHizhqr9diXPLolxTfu+pCyN2v81EcpJ2Voov5csuaNJ
         RCp4EocmySmHsU/Yfg0nIh5IkVRCjlRmTGhfLFoDrtX++bN9Mo8hCO1KR7IaHTVaL0Js
         AMFQ==
X-Gm-Message-State: AOAM5332pMYMsfnjk9DuHvn4ALJDB0YcyXbtqdjGqduPaEI3B6pftUfO
        76fx98126MxyN7UMvD/AAA40Fc5qiyCgwWnNDYE=
X-Google-Smtp-Source: ABdhPJyITefbnmkLfBNTGBm+HEBpDniCuZzmxJWtcO5+Jsr5qtsyv/Ga8anZ1/HZpkQg1FIVS8S3A56jlL+mXyDrrAA=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr19373199qvb.228.1593530297739;
 Tue, 30 Jun 2020 08:18:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200630060739.1722733-1-andriin@fb.com> <20200630060739.1722733-3-andriin@fb.com>
 <cd88906d-2ca7-e37b-9214-6094571d41fc@iogearbox.net>
In-Reply-To: <cd88906d-2ca7-e37b-9214-6094571d41fc@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jun 2020 08:18:06 -0700
Message-ID: <CAEf4BzZsEJDAzeY6vJG5873Y4nnB9b+NrSiSzAHQWATMKfnO_w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: add byte swapping selftest
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 7:09 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/30/20 8:07 AM, Andrii Nakryiko wrote:
> > Add simple selftest validating byte swap built-ins and compile-time macros.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   .../testing/selftests/bpf/prog_tests/endian.c | 53 +++++++++++++++++++
> >   .../testing/selftests/bpf/progs/test_endian.c | 37 +++++++++++++
> >   2 files changed, 90 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/endian.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_endian.c
>
> This fails the build for me with:
>
> [...]
>    GEN-SKEL [test_progs] tailcall3.skel.h
>    GEN-SKEL [test_progs] test_endian.skel.h
> libbpf: invalid relo for 'const16' in special section 0xfff2; forgot to initialize global var?..
> Error: failed to open BPF object file: 0
> Makefile:372: recipe for target '/root/bpf-next/tools/testing/selftests/bpf/test_endian.skel.h' failed
> make: *** [/root/bpf-next/tools/testing/selftests/bpf/test_endian.skel.h] Error 255
> make: *** Deleting file '/root/bpf-next/tools/testing/selftests/bpf/test_endian.skel.h'

Interesting. You must have a bit of an older Clang. I noticed people
submit code without explicit initialization of global variables, which
is ok now, because I think Clang doesn't emit it into the COM section
anymore. I'm surprised you don't get other compilation errors.

But regardless, I'll respin with explicit zero-initialization to fix this.
