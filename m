Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A804312314
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfEBUSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:18:54 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:39924 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBUSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:18:54 -0400
Received: by mail-it1-f193.google.com with SMTP id t200so5682241itf.4;
        Thu, 02 May 2019 13:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BqrdERgYm6oaGKzw62ZugOufogtv2Ccque8qwoUuCvs=;
        b=ZcsBdqCC6n31fkPJ8ASfbQWNAEEs6BUW0COVKXsow4GizghE73TsCSVKffmYPpRD6M
         5rl5YpDT+m3fCNXTwjL/luVLKdJLHfg1cHd96VbZf+UKwZVpCOfNirDGB7oc2JOHWsWy
         ahW/Ukl02kdIltUB9LG1sdMl2LS9Y9tEiZc2tI9XE+mAn1juFrE7NMIFS6WQZEg690JQ
         RsNyS6j8GpCTAgO0NN6MGq3x6MRdTQwdBFbn7MYsO8X8DMGjh8YEMpzj8+3YynwC3NmR
         eJCS6XLN0J7NQnGdxyxEuvS9pitLDIrAZ0DiNF37DIHhlskFcYLRE4JcWR9ITzboUlWV
         Oy+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BqrdERgYm6oaGKzw62ZugOufogtv2Ccque8qwoUuCvs=;
        b=gBIvkkN8XSGht5+WSc9CjsBxI9ijF4BMXK9J/bC9cwdMT8eg0S/255xs7jqDhXMhyL
         5gUqRxcy9+mV0BneufGBaPCZJ0ZX6weI7jGhrgvj1Qst/HhRIyKoZLMR/jJWiXh2XgC8
         9VC97zqt7sQfn7G1N1E98GHDKRmp71amGxwf2x8nyWlaMrvAlGblP8YwpwKOFZfcm7HX
         XXuXW97c508VoVYhxWGoY9cOJT+KZwslMtWmOzF7LPupOFXfutgxsmdjsXKONTbi/DPC
         yVww+ul+f8zUJMPFfL8XI2FN9r+ywVviE1KZxVxVusdUKKEYeoAPBckh2PI/TVssr49F
         wPfg==
X-Gm-Message-State: APjAAAUpm7SFE3j+zOAlXzzEC9kAGdMBkrs9ZRJJoibqx0Re4mW9KteR
        AVGlciJ5k6ZaERSLb3n2g6bQ+8wike/Clq6NhWY=
X-Google-Smtp-Source: APXvYqyhOjAAwkfA5XXosGRI9NbToQpDgFnNe5aaxF4ifLbemoFih1YT2N1NiR6Hbnx5GPsozlBSmx/sG05/NrfRaaM=
X-Received: by 2002:a24:4210:: with SMTP id i16mr3914027itb.37.1556828333546;
 Thu, 02 May 2019 13:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <1556822018-75282-1-git-send-email-u9012063@gmail.com>
In-Reply-To: <1556822018-75282-1-git-send-email-u9012063@gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Thu, 2 May 2019 13:18:17 -0700
Message-ID: <CAH3MdRVLVugbJbD4_u2bYjqitC4xFL_j8GoHUTBN77Tm9Dy3Ew@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: add libbpf_util.h to header install.
To:     William Tu <u9012063@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>, blp@ovn.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 2, 2019 at 11:34 AM William Tu <u9012063@gmail.com> wrote:
>
> The libbpf_util.h is used by xsk.h, so add it to
> the install headers.

Can we try to change code a little bit to avoid exposing libbpf_util.h?
Originally libbpf_util.h is considered as libbpf internal.
I am not strongly against this patch. But would really like to see
whether we have an alternative not exposing libbpf_util.h.

>
> Reported-by: Ben Pfaff <blp@ovn.org>
> Signed-off-by: William Tu <u9012063@gmail.com>
> ---
>  tools/lib/bpf/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index c6c06bc6683c..f91639bf5650 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -230,6 +230,7 @@ install_headers:
>                 $(call do_install,bpf.h,$(prefix)/include/bpf,644); \
>                 $(call do_install,libbpf.h,$(prefix)/include/bpf,644); \
>                 $(call do_install,btf.h,$(prefix)/include/bpf,644); \
> +               $(call do_install,libbpf_util.h,$(prefix)/include/bpf,644); \
>                 $(call do_install,xsk.h,$(prefix)/include/bpf,644);
>
>  install_pkgconfig: $(PC_FILE)
> --
> 2.7.4
>
