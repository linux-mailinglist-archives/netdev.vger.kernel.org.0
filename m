Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0206513E04
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 09:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfEEHDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 03:03:24 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36531 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEEHDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 03:03:23 -0400
Received: by mail-lj1-f195.google.com with SMTP id y8so8256977ljd.3;
        Sun, 05 May 2019 00:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ualfQGZO/XL4lpOzDR7Gj6XZhSNh/P7TGnKM3Oo0yYU=;
        b=k9MkHLWrw8QMSSyEGj3mMm3aBQvUmwq6NhVbZsaGYYe5VxkvpY4Qpq/9n7bOSngNlF
         1BzocAGm9wh2IMU+mjaG2chKIwdddASVXgwoIGpSSc3CjWqyBsmpoxP0uEc8Dk4UKo0k
         8ubOvFsihXEqv0cPM4VTnmo4NqY8UEOwwfWUhCLBZoQpyEeRWgsvyDVOhSfBzJ9gTdls
         m2DlZvgF08I2yX7VpGRUTGGiSvkNzr/aZfYHT6JgTumt8kSdzYHQPOdNfLdj4eMDDGbh
         AYJJGLY4IrDxW+iKR8OaolrgtUYWXdK3uCVrDEGPa3EvALnuZsnWkMEVjJO4ChdXfbpS
         mtig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ualfQGZO/XL4lpOzDR7Gj6XZhSNh/P7TGnKM3Oo0yYU=;
        b=GT1gYiUUtExMaxfO7+Y5DKb3ydwMSc11x1hzDR2Xp++VID/K2hxr1AaBQSqd0/vggg
         euNJ2jUev0wrA7fCbiHDdqS3bUlTXtf7c8xk5C4S0eD2WTezbK8qvA2fry1JPBAzw8TQ
         ZZ/toM3UVgucpjKS0mdHd9caVn50N1wwMSiI8nCfwwZ7WaC+NGgQbuNdAcgfsKUNomyK
         zjv01RSr3x7NGnIic2KbrNkTdGwXU3fMeXa2lgmL4kX+M6uka2p8NfjRcAcodayQsh1v
         jjb3YfRtpx6KEiai64Qn7CJIp5xTUT5Lj9Kh9g3bxzhkHZT9Tk2WjRck7fsBvCLvCxwF
         fGZA==
X-Gm-Message-State: APjAAAXYSAXAsJRoy0bVORCoUBcLBYlke3qkET/L8WnMHslUwjb+Rh4k
        TbuCfzupVKFfLInANERPSm8GR+PPQgKRESRapOw=
X-Google-Smtp-Source: APXvYqzdT6aPGFOKokWuDctgUsdvgDiasBMhIy4A5IlTVq0ZLRCNWZW7PXDhFE6K1CL/m0eIZ2rt9nekjkwzLYGYZ70=
X-Received: by 2002:a2e:3c06:: with SMTP id j6mr9138016lja.99.1557039801359;
 Sun, 05 May 2019 00:03:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190502081453.25097-1-mrostecki@opensuse.org>
In-Reply-To: <20190502081453.25097-1-mrostecki@opensuse.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 5 May 2019 00:03:09 -0700
Message-ID: <CAADnVQ+exT+Jv=i9a4MWNB_eeO6ZeJWAm0=OL5_EZ1gQLvRk-w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf, libbpf: Add .so files to gitignore
To:     Michal Rostecki <mrostecki@opensuse.org>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 2, 2019 at 1:15 AM Michal Rostecki <mrostecki@opensuse.org> wrote:
>
> This change adds libbpf shared libraries to .gitignore which were
> previously not included there.
>
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
> ---
>  tools/lib/bpf/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
> index 7d9e182a1f51..0b181b23f97d 100644
> --- a/tools/lib/bpf/.gitignore
> +++ b/tools/lib/bpf/.gitignore
> @@ -1,4 +1,5 @@
>  libbpf_version.h
>  libbpf.pc
> +libbpf.so.0*

Some folks build libbpf as part of selftests.
Please update .gitignore in tools/lib/bpf and
in tools/testing/selftests/bpf

Also instead of "bpf, libbpf:" subj prefix just mention "libbpf:"
