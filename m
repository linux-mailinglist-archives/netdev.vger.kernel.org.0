Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E177213BF
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 08:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfEQGby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 02:31:54 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37434 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfEQGbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 02:31:53 -0400
Received: by mail-qk1-f195.google.com with SMTP id d10so3839895qko.4;
        Thu, 16 May 2019 23:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W31gkYOGw781FNC6CVGSMH2gW6sCoEah9gyo6dY5h3I=;
        b=Ne1FnTZA8Jjy+KB2fJI+EtXYhTUuB7eEXAfALB4rjWVH9szrbDDdCkvvmbzvYs24Oo
         V54zTImsr4l6MITqM7Q3KcvH13RVpE9pDbEyzS7cZ522FXrlxGZyuBj/03oyMcSPdCci
         0KviDXX3JN2uXJq+CDh4WqNwHnDDCxG2lXzPn05U8DQbJSp/TrVMN7zU5U6jxqdf1rS5
         jfLmFqjka7mPoiEU6j7LBVVPOR8wAXN2yzuMwTGXLRdtJ59cYGIJdn1o6KNyZm+rcNQt
         1XS8/1P+eZTfET8LLxQUvedU7SdnyiaAItxgYEEggVOXVwMh6IcFCT1sHdA+sZmao2wP
         cQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W31gkYOGw781FNC6CVGSMH2gW6sCoEah9gyo6dY5h3I=;
        b=nH/uYNfi5DboonqbtpY+kitIyN7hpRBtcuZifTqbphKZQrCUsZbQQFX1KQgSWCqU2J
         NlC0RooqQocOFsHEs1h1KB4QH0f3AhGmm7VGdhrI8Zy8KH+yuQnYSKlNCK21+nrdGgKg
         Srt/8FcBRUadwOFM7PzWtl6ZcU9BJ1mI2ACOGN9aFaPKEECuYpXAEfBUY1WFSRSjp5Fb
         1dqGy8w6t1vdlszFfTTnBE7E45JQ/TEcsK5RgdT5Pi/AeDsoCxi6dFAIa7bXSCc3vENF
         yU0CEBZDgYyboUWMKMdM3kRJ0/GEKBTI+JF3WPwV2/Qvr5WUdbnYM/o1BYlqZE5fVu5v
         Oukg==
X-Gm-Message-State: APjAAAXS7+OreQGbURbPKeuwT1AnMwJakf2o7nGIqQ7ZSMywQwC8AwAB
        zBLEc0Re6QIAIEU8rN7etRmUvuE56FYuahWOcQU=
X-Google-Smtp-Source: APXvYqxXwws5bqmaIvXOcAcbw/nna4oe3VtmdFA7L/tg7fs2ToWjrTJV+cYO1CxcDfpx3kPh32/k35ETEhgynqKiG1U=
X-Received: by 2002:a37:ac11:: with SMTP id e17mr37603354qkm.339.1558074712697;
 Thu, 16 May 2019 23:31:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190517043411.3796806-1-ast@kernel.org>
In-Reply-To: <20190517043411.3796806-1-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 May 2019 23:31:41 -0700
Message-ID: <CAEf4BzbQDoAZGEEkO7uHWhuYZxnqACk_X=h9f08ZvQA853MA=w@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: fix bpf_get_current_task
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 9:34 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Fix bpf_get_current_task() declaration.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Andrii Nakryiko <andriin@fb.com>

> ---
>  tools/testing/selftests/bpf/bpf_helpers.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 6e80b66d7fb1..5f6f9e7aba2a 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -278,7 +278,7 @@ static int (*bpf_skb_change_type)(void *ctx, __u32 type) =
>         (void *) BPF_FUNC_skb_change_type;
>  static unsigned int (*bpf_get_hash_recalc)(void *ctx) =
>         (void *) BPF_FUNC_get_hash_recalc;
> -static unsigned long long (*bpf_get_current_task)(void *ctx) =
> +static unsigned long long (*bpf_get_current_task)(void) =
>         (void *) BPF_FUNC_get_current_task;
>  static int (*bpf_skb_change_tail)(void *ctx, __u32 len, __u64 flags) =
>         (void *) BPF_FUNC_skb_change_tail;
> --
> 2.20.0
>
