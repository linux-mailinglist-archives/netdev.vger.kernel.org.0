Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABA3CB00F
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389400AbfJCUWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:22:20 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44866 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729638AbfJCUWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 16:22:20 -0400
Received: by mail-qt1-f195.google.com with SMTP id u40so5421996qth.11;
        Thu, 03 Oct 2019 13:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XWINcmdMf+kfvzZB9NiZDsCdyB9H1G12eqwgNmfzh2o=;
        b=meM87T4wIwiYKXBRITh/Cj7V5V3XX0sWg86ptJZXf68I/hirYjgkdFsWaGE/pwrh27
         spFk9wjIFzRjln2M/wPI9CxyEA3ojtQyWigBAvQnH1mXCYUtlI8ZygkVg2qHHkMKLT2G
         GIyBM8ckWbK763Jl3bSLguH4tnwfQil0wzU6E99jRaO8zQSa9X2DspZo+cZLqNKU4uks
         aSTk/dL4iZzuBlAgDT/C2pHoQLIlHkB4IFxbxdWNyDltnt/4WNLP3xM/ArjH77zB+gdN
         YpiTXKlC3Ru0OxiwNt6W6fiSN4RIA6H3eVMuqLvpadnS/dslM8XwFVyZlErqNMsRYjqo
         DXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XWINcmdMf+kfvzZB9NiZDsCdyB9H1G12eqwgNmfzh2o=;
        b=JwuOSMhD3sGrmEGos5axWmoxLCJloifbFNoFusKW0SoL9W8l6b+MiRpvtNZlG5NDBB
         j4mPTIqnYAsvy/YBOU5KLvv5wz9vlD0Gu878vqJXtOP4BKeonQH8ttFpRRKkAMJZIyWp
         xaa1xmFtDLUwd7AJpm26Xn83rdJLMqyrJzonR9ZPfDtIgXjI6ZRkosWOiD42VTvNVQWG
         ak6CsAqcABdhBCgRD5JB339EB/52W5UHLZjsy618f41ZujjuJPpkNXuEQx7NLrMwWVNb
         Cy8iCtEv1RWJ1+uptF4ZPBi9Q7vzWfA2QX8Ob7kPOWUT8lL3OH5mgpYRzxtEzJrGJlyD
         WoLA==
X-Gm-Message-State: APjAAAV0nuwz1qPWs9dKyowpYnvE1cl+Ve6NjGZCcFCyySMDneHySqNt
        RyBrKVEGQQC7CiSQY4FF4/nPoIM7CG4ytFWxmm4=
X-Google-Smtp-Source: APXvYqy0lg17SkuBCt3dxSBkOHieCpJWFa0uD8nrnnQBNDjPhgsONZ47BcNKd8lFq8KHkAuhO0tFsV87sI/cEQGWpaA=
X-Received: by 2002:ac8:3482:: with SMTP id w2mr11855508qtb.379.1570134138516;
 Thu, 03 Oct 2019 13:22:18 -0700 (PDT)
MIME-Version: 1.0
References: <20191002215041.1083058-1-andriin@fb.com> <20191002215041.1083058-6-andriin@fb.com>
In-Reply-To: <20191002215041.1083058-6-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 3 Oct 2019 13:22:07 -0700
Message-ID: <CAPhsuW7hbGE5HwjDQVGhiaHhqSzrgBdKs-C7ct6k2=FGh6LU+g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 5/7] libbpf: move bpf_{helpers,endian,tracing}.h
 into libbpf
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 3:03 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Move bpf_helpers.h, bpf_tracing.h, and bpf_endian.h into libbpf. Ensure
> they are installed along the other libbpf headers. Also, adjust
> selftests and samples include path to include libbpf now.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  samples/bpf/Makefile                               | 2 +-
>  tools/lib/bpf/Makefile                             | 5 ++++-
>  tools/{testing/selftests => lib}/bpf/bpf_endian.h  | 0
>  tools/{testing/selftests => lib}/bpf/bpf_helpers.h | 0
>  tools/{testing/selftests => lib}/bpf/bpf_tracing.h | 0
>  tools/testing/selftests/bpf/Makefile               | 2 +-
>  6 files changed, 6 insertions(+), 3 deletions(-)
>  rename tools/{testing/selftests => lib}/bpf/bpf_endian.h (100%)
>  rename tools/{testing/selftests => lib}/bpf/bpf_helpers.h (100%)
>  rename tools/{testing/selftests => lib}/bpf/bpf_tracing.h (100%)
^^^^^ nice! :)
