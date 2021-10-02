Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD1741FE0D
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 22:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhJBUch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 16:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbhJBUcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 16:32:36 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9673AC061714
        for <netdev@vger.kernel.org>; Sat,  2 Oct 2021 13:30:50 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id 66so15200285vsd.11
        for <netdev@vger.kernel.org>; Sat, 02 Oct 2021 13:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R6q93+UAArKwuO+eqr6jdH/wpvGlluXnePii2ySrFFg=;
        b=a0bLgPcXFMoQrofCdVVhdbLV9nxsolZYem1+Xq7GKC0Jd8jg8vEwrM44eZDxualQdM
         S0PykCEc7iFsrCeNxe5tF9p8wWmO6C87OqMNx4gQ4W1z5poBotITricDIszIGWD4lyqO
         F9H+y/29BLlvVROlnC4yzf6pU/Hjo7rh6K2OpL8R9D77CVkBrnLgyFogMYVlTUlf2ljL
         jRaOO5KKMCv8hdHfhk1c1lg/VRdF6XqAxdraqGt1x7RA8lNMfTxEK/aCbgt8Gq0EzgLR
         bTG3meHGED4lyMm/yk8iBLuZk88Vce5ffJpCVWY9mkCLdUu/+TAD94H5N0y32hBaH+hW
         fKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R6q93+UAArKwuO+eqr6jdH/wpvGlluXnePii2ySrFFg=;
        b=BWNKS6MqxvtK5PX4uVkM+n/VTDIQ3QjjkYtL6nCiUNst1BKoSAVFUSnM+tIU6r0oMD
         rFwr1jQZUaiH0ajJPIR//tctj4zSaIM5bSymcNpmcqYV/NY0t4z1dn//sCsRw8EE8ATc
         +3wNIa7M9aZxbNxT5GuZIJaU3BYEqkyWt0ZrlXDnFBjnb/eWoDwRHJ3fSviWcSkuhZFN
         KobHzcG2EeZqX/Y5X0Zyr7muzRLnsgPTQso0ynljNGIe8CUTfxz2yLGKlLXtgpIPs0/x
         mngR4ZF9WuuVxKsPo4ZaFAqxaAWvbXbjga30S2uzksb0l6I+pzV0IhHYdpPpAZ9OLhfw
         vMKw==
X-Gm-Message-State: AOAM532zi8GwgZpDMm/202Ng0fWgdQvH88vpFvwtumlJ46P3/X+GsZ6U
        4OEBJQtfXSrFdscD3hnTwcOo62wCIF3xiC/+KZAquw==
X-Google-Smtp-Source: ABdhPJwqPHlcaksiGhKAcCAuWy+rJPOgtZGIjmNlrYWtLA8M/9O6RmcmNSVawWnhFdQ+Se4ZA+MssZjnZ9DUYT8S9/Y=
X-Received: by 2002:a67:d08f:: with SMTP id s15mr9258822vsi.54.1633206649819;
 Sat, 02 Oct 2021 13:30:49 -0700 (PDT)
MIME-Version: 1.0
References: <20211001110856.14730-1-quentin@isovalent.com> <20211001110856.14730-8-quentin@isovalent.com>
 <CAEf4BzaOXUgiDwsTFhWKwKm=05qTjQCyXRB6a=n_kdCgSdAZ6A@mail.gmail.com>
In-Reply-To: <CAEf4BzaOXUgiDwsTFhWKwKm=05qTjQCyXRB6a=n_kdCgSdAZ6A@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Sat, 2 Oct 2021 21:30:38 +0100
Message-ID: <CACdoK4JHs+BRv_0WYqa+RO_XXsSg4J-xCpEErLD7XLhhMwVq5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 7/9] samples/bpf: install libbpf headers when building
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2 Oct 2021 at 00:22, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Oct 1, 2021 at 4:09 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > API headers from libbpf should not be accessed directly from the source
> > directory. Instead, they should be exported with "make install_headers".
> > Make sure that samples/bpf/Makefile installs the headers properly when
> > building.
> >
> > The object compiled from and exported by libbpf are now placed into a
> > subdirectory of sample/bpf/ instead of remaining in tools/lib/bpf/. We
> > attempt to remove this directory on "make clean". However, the "clean"
> > target re-enters the samples/bpf/ directory from the root of the
> > repository ("$(MAKE) -C ../../ M=$(CURDIR) clean"), in such a way that
> > $(srctree) and $(src) are not defined, making it impossible to use
> > $(LIBBPF_OUTPUT) and $(LIBBPF_DESTDIR) in the recipe. So we only attempt
> > to clean $(CURDIR)/libbpf, which is the default value.
> >
> > We also change the output directory for bpftool, to place the generated
> > objects under samples/bpf/bpftool/ instead of building in bpftool's
> > directory directly. Doing so, we make sure bpftool reuses the libbpf
> > library previously compiled and installed.

> > @@ -268,16 +272,28 @@ all:
> >  clean:
> >         $(MAKE) -C ../../ M=$(CURDIR) clean
> >         @find $(CURDIR) -type f -name '*~' -delete
> > +       @/bin/rm -rf $(CURDIR)/libbpf $(CURDIR)/bpftool
>
> should this be $(RM) -rf ? I've seen other makefiles don't hardcode
> /bin/rm. And also below we are passing RM='rm -rf', not /bin/rm.
> Inconsistent :)

Inconsistent?! But I took it just a few lines above, from
BTF_LLVM_PROBE! :) But I also prefer "$(RM) -r" (the -f is included in
"$(RM)"), so sure, I'll address.
Quentin
