Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE718D0067
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 20:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfJHSCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 14:02:30 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36821 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfJHSCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 14:02:30 -0400
Received: by mail-qk1-f194.google.com with SMTP id y189so17665561qkc.3;
        Tue, 08 Oct 2019 11:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iPqRIP0q+7/xvOSmCGFdMvtR0Symr5nOAZbEKJbSIIg=;
        b=tqTnD7KdE/PdKRO6mIe8u+5aESEzhT86GeoroZFYk6XSd4R5ePwOd1fBtcI4wIcpj+
         HkcMeQeX10D8sSyuU8RrvicrrQyxjvImSqsFIPOfek5CH+xKFWuSZ5RrQU9jQNXXt/W4
         16IG3vUh46iESNsG29ei+zfTW4ICRfXkcUlx3glfUgdfUXNmpIPzwfySqBtlFHsXBSjN
         USJdukCs//o3YIe1W5/F7yT3Zx+e2ZH8y7iP/DffYVRvL+TObn3MCk6qJR83xRMMTDom
         j+imOGrgN4zgHxtRnf+SoTjq39C/WufbxlhFGlrLzePz+2gnF3qDrUfpXa7vTCxpG/+c
         8jww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iPqRIP0q+7/xvOSmCGFdMvtR0Symr5nOAZbEKJbSIIg=;
        b=RO9onU/N4YQ5g4sVfG9/RwehgFzI918JjjM410JqHC9c34+/AHawVWwIJV04bm2ivL
         4jH6Ory5zlILeRz5VBbG58M1B2sGMVB+fQ+dnkDJAJRF3l1GiX6WtDcMh1ncJb8BRzux
         GvhIFc7Pzyw9A1TR20wOZtXwS66PX3KxR2vRfDzymxQgaMK+NdMCYWKiC81WvllGzoGs
         bIXm0IvdGQwRqSF1qdv0gbjibM/CeQJUVdk/YSiRT9ltJv64elyCGIWlOi9EkN8+D4vB
         DWvzONo+o9SsuwjHUQS4WbnVS0vWEYQLORmrrJ7xC3bCbnb26Comrox6BFN5GYNN50ut
         QR7g==
X-Gm-Message-State: APjAAAU76NTDi2cEbHq8OJrrOSD7FItnx2I/2cJ/7tZGhy13NhT9XUgo
        oqXVAh+WrVZI+mnc07ruCPE8KE0sL0zA/W/22TI=
X-Google-Smtp-Source: APXvYqy87zxsZ1OZiZZdklgIJtLVcOV1vpbpspNOoqKbys0Ic/TYVs/458T0voKzvu5+IeLUoDWkvJOiMY4LjuNq9ds=
X-Received: by 2002:a37:98f:: with SMTP id 137mr31781144qkj.449.1570557748052;
 Tue, 08 Oct 2019 11:02:28 -0700 (PDT)
MIME-Version: 1.0
References: <20191003212856.1222735-1-andriin@fb.com> <20191003212856.1222735-6-andriin@fb.com>
 <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com> <CAEf4BzYRJ4i05prEJF_aCQK5jnmpSUqrwTXYsj4FDahCWcNQdQ@mail.gmail.com>
 <4fcbe7bf-201a-727a-a6f1-2088aea82a33@gmail.com> <CAEf4BzZr9cxt=JrGYPUhDTRfbBocM18tFFaP+LiJSCF-g4hs2w@mail.gmail.com>
 <20191004113026.4c23cd41@cakuba.hsd1.ca.comcast.net> <62b1bc6b-8c8a-b766-6bfc-2fb16017d591@fb.com>
 <20191008173709.07da56ef@redhat.com>
In-Reply-To: <20191008173709.07da56ef@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Oct 2019 11:02:16 -0700
Message-ID: <CAEf4BzbUVVThaLAwepit9V1voe7CBMPiK1rjkq-i-JXbFOnw2Q@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move bpf_{helpers,endian,tracing}.h
 into libbpf
To:     Jiri Benc <jbenc@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 8:37 AM Jiri Benc <jbenc@redhat.com> wrote:
>
> On Fri, 4 Oct 2019 18:37:44 +0000, Yonghong Song wrote:
> > distro can package bpf/btf uapi headers into libbpf package.
> > Users linking with libbpf.a/libbpf.so can use bpf/btf.h with include
> > path pointing to libbpf dev package include directory.
> > Could this work?
>
> I don't think it would. Distros have often a policy against bundling
> files that are available from one package (in this case, kernel-headers
> or similar) in a different package (libbpf).
>
> The correct way is making the libbpf package depend on a particular
> version of kernel-headers (or newer). As I said, I don't see a problem
> here. It's not a special situation, it's just usual dependencies.
>

We ended up switching to auto-generating BPF helpers from UAPI headers
w/ hardcoding BPF_FUNC_xxx values in bpf_helpers.h. So there is now no
dependency on any specific kernel version there.

>  Jiri
