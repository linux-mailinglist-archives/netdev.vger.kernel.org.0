Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1B7455995
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfFYU7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:59:13 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45797 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfFYU7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:59:13 -0400
Received: by mail-qk1-f194.google.com with SMTP id s22so13797571qkj.12;
        Tue, 25 Jun 2019 13:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SznKw/4Q28ISDx9MuOlgmkJn46xF24IKGcART6Ixvq8=;
        b=lfQTZDQ/kP9ekFOxmvlvUp5GWvxZOZo/FX0rphMfIA1K9Pt7D6j3dsertBcTPvL8pt
         sX7TyVfT634gAmfREbLFGtSt1doAudPUi+NX5cQ72t5BMBnR5Svb59m17F0YJJNquw5F
         Ux8U+1DWQ5Gm93tCYbQBhLN55bG4avxUtzBZ2FDLhgyRqs715MDqHVVXgDAaCJrgWdxq
         EbLTw5zbT3nFkGJ5A9xgRPtM0J02FFB230bPnr/J/rO9pVn5tmlYPAM5Y+qdv1js2odk
         n2VviblY35OUHiPMDwZ5UvuiRcwjK5+BqRtw51lF7Gf5Tw9YabGlwR/o7SlM3ZaW2a+n
         AJIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SznKw/4Q28ISDx9MuOlgmkJn46xF24IKGcART6Ixvq8=;
        b=m/M71ZFpl9kArvCaxjLFjymIh1ThM91hD/upCKcxqoV6zhBTMWAaAIqiKvMcFBWVLm
         d43+hug/ITaycrRM3t5cRhVHCK8MxRViQCBQuvU1bdeGeilbEqnqZNOqw/3+C6ROZ51a
         ujn6cLJPEDVcs7DdVU4mUNtCBAqm94/p+fjtpFM5SJspiubKOgl3IJqSw1FDodbbFK2+
         3yiE8/D4s3bnPvgwsOza7XFMURLT9TPBZ+KchswilnVoF1pO0aIFNROGhpClZ8MOcD+p
         6gZw4pEAaDZfhG0bXIMhcSa1fJ3fYFkbuCaYRcRgiVS0dow71AM1sfhwmis3MTKKEOSU
         YUTQ==
X-Gm-Message-State: APjAAAVjbfgJUZx2ZfHRw/BADKfQKCYT+5MubfFLYvoBNJvj9dTP9EgT
        v6Ifvj0WLY9PRVU15zNOkWPHyCw1OtLkix+Uwmw=
X-Google-Smtp-Source: APXvYqy1LxA7P6qsfPBp27nTqcQSeg6zwFYi/DWcjgaVs2kNIXoLU0bA0EpUcekN/vvd/2/0aXi3yeCDqhsmw5gwpHs=
X-Received: by 2002:a37:4d82:: with SMTP id a124mr690103qkb.72.1561496351999;
 Tue, 25 Jun 2019 13:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190625202700.28030-1-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190625202700.28030-1-ivan.khoronzhuk@linaro.org>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 25 Jun 2019 13:59:00 -0700
Message-ID: <CAPhsuW4w9oo=mNKo162apbw8rirQKWbJAnkcbjrcamNwfdUJNw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix max() type mismatch for 32bit
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 1:28 PM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> It fixes build error for 32bit caused by type mismatch
> size_t/unsigned long.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 68f45a96769f..5186b7710430 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -778,7 +778,7 @@ static struct bpf_map *bpf_object__add_map(struct bpf_object *obj)
>         if (obj->nr_maps < obj->maps_cap)
>                 return &obj->maps[obj->nr_maps++];
>
> -       new_cap = max(4ul, obj->maps_cap * 3 / 2);
> +       new_cap = max((size_t)4, obj->maps_cap * 3 / 2);
>         new_maps = realloc(obj->maps, new_cap * sizeof(*obj->maps));
>         if (!new_maps) {
>                 pr_warning("alloc maps for object failed\n");
> --
> 2.17.1
>
