Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418F11BB988
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgD1JKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:10:13 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55405 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726271AbgD1JKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:10:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588065011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mLlYGRaGtKebiqNKn4LSDNep/UjPJ1Wdd7UKZgKBh+I=;
        b=Q2JJDWhjoKUkX/aidPjC2LYs158kty9jZt4gKtPinNIKPzj+8+GB5CXHfWYlFdIPF0Okuk
        +7XmcoFu+TINUH5MmoVGY0FqsVkyC7XtZn/LnKI+qgrs4iXvvwND5Ehv8QIg6VarchC8B3
        1Dg4RCeS7OQHw9g5wZ2JI3vXqRdQw0Y=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-QA1PEhunMbKaibu87CwgoA-1; Tue, 28 Apr 2020 05:10:09 -0400
X-MC-Unique: QA1PEhunMbKaibu87CwgoA-1
Received: by mail-ej1-f69.google.com with SMTP id rp12so12591876ejb.11
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 02:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mLlYGRaGtKebiqNKn4LSDNep/UjPJ1Wdd7UKZgKBh+I=;
        b=Gh1dLBwssrLUtnHes0kiC3DWTTy1H6Yt5SoebgvhpZuCIb04knYHW+AEp00/RLf3bj
         K8eKJW3Hx37aXXT/PAGwJ0XhXid1hNvFLkfeenS2ZkHiMYyfWmuOpzc6UCZfVlMcgJux
         eBg7ocQdGxeid/lsAvAhyUhXqWwc+F9GeEswHETZ5zXnly0Wogsehsxi2hacIy2uIgUq
         w/wp+15TM4/M7rTrZPuwsjMdWdSI5mywHZoRo8j88DMGvf8z4Zoh9E55lgQswj2MLtqD
         swl78Gq0bVDUUk48rxlB65nUg2FXSWTVx/KEIHJgwhxDt5azReY2QWG/ZRh942/cM+r/
         6ZKw==
X-Gm-Message-State: AGi0PuYP0x3JHDZul3BbgFCT7qV9SW3JqJ7AGX1pq8zWtD/PgGLsPuTm
        Ss8sIziCIf9ka2tIlML5Ux++lJUojbs4qx7iUqbXs+/F5J2RpxwcJC189dzrybYuTFz4VCdl3Mk
        fgXhC7AWqcOh5RdELI+yQBUUHXkmAVYpt
X-Received: by 2002:a05:6402:1bc8:: with SMTP id ch8mr21301834edb.53.1588065007972;
        Tue, 28 Apr 2020 02:10:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypI7exk67W6l3srijx+7ZoHHvZxaLkftkJjr6scA9pXyJLOK8sT9EPUmWR47gN8RlgL6KeQXQedmsQ6GPyjyR3I=
X-Received: by 2002:a05:6402:1bc8:: with SMTP id ch8mr21301806edb.53.1588065007659;
 Tue, 28 Apr 2020 02:10:07 -0700 (PDT)
MIME-Version: 1.0
References: <57923a5a17573e7939a78a55ba5b6dd28ad1862f.1588064112.git.dcaratti@redhat.com>
In-Reply-To: <57923a5a17573e7939a78a55ba5b6dd28ad1862f.1588064112.git.dcaratti@redhat.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Tue, 28 Apr 2020 11:09:56 +0200
Message-ID: <CAPpH65zFiOOCT6TkCwRZ-Y5VkwzBOso9ssTuuQR25kmtXpRE0w@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] tc: full JSON support for 'bpf' filter
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        linux-netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:00 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> example using eBPF:
>
>  # tc filter add dev dummy0 ingress bpf \
>  > direct-action obj ./bpf/filter.o sec tc-ingress
>  # tc  -j filter show dev dummy0 ingress | jq
>  [
>    {
>      "protocol": "all",
>      "pref": 49152,
>      "kind": "bpf",
>      "chain": 0
>    },
>    {
>      "protocol": "all",
>      "pref": 49152,
>      "kind": "bpf",
>      "chain": 0,
>      "options": {
>        "handle": "1",
>        "bpf_name": "filter.o:[tc-ingress]",
>        "direct-action": true,
>        "not_in_hw": true,
>        "prog": {
>          "id": 101,
>          "tag": "a04f5eef06a7f555",
>          "jited": 1
>        }
>      }
>    }
>  ]
>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  tc/f_bpf.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/tc/f_bpf.c b/tc/f_bpf.c
> index 135271aa1697..519186f929e5 100644
> --- a/tc/f_bpf.c
> +++ b/tc/f_bpf.c
> @@ -203,22 +203,24 @@ static int bpf_print_opt(struct filter_util *qu, FILE *f,
>         parse_rtattr_nested(tb, TCA_BPF_MAX, opt);
>
>         if (handle)
> -               fprintf(f, "handle 0x%x ", handle);
> +               print_hex(PRINT_ANY, "handle", "handle 0x%x ", handle);
>
>         if (tb[TCA_BPF_CLASSID]) {
>                 SPRINT_BUF(b1);
> -               fprintf(f, "flowid %s ",
> +               print_string(PRINT_ANY, "flowid", "flowid %s ",
>                         sprint_tc_classid(rta_getattr_u32(tb[TCA_BPF_CLASSID]), b1));
>         }
>
>         if (tb[TCA_BPF_NAME])
> -               fprintf(f, "%s ", rta_getattr_str(tb[TCA_BPF_NAME]));
> +               print_string(PRINT_ANY, "bpf_name", "%s ",
> +                            rta_getattr_str(tb[TCA_BPF_NAME]));
>
>         if (tb[TCA_BPF_FLAGS]) {
>                 unsigned int flags = rta_getattr_u32(tb[TCA_BPF_FLAGS]);
>
>                 if (flags & TCA_BPF_FLAG_ACT_DIRECT)
> -                       fprintf(f, "direct-action ");
> +                       print_bool(PRINT_ANY,
> +                                  "direct-action", "direct-action ", true);
>         }
>
>         if (tb[TCA_BPF_FLAGS_GEN]) {
> @@ -226,14 +228,14 @@ static int bpf_print_opt(struct filter_util *qu, FILE *f,
>                         rta_getattr_u32(tb[TCA_BPF_FLAGS_GEN]);
>
>                 if (flags & TCA_CLS_FLAGS_SKIP_HW)
> -                       fprintf(f, "skip_hw ");
> +                       print_bool(PRINT_ANY, "skip_hw", "skip_hw ", true);
>                 if (flags & TCA_CLS_FLAGS_SKIP_SW)
> -                       fprintf(f, "skip_sw ");
> -
> +                       print_bool(PRINT_ANY, "skip_sw", "skip_sw ", true);
>                 if (flags & TCA_CLS_FLAGS_IN_HW)
> -                       fprintf(f, "in_hw ");
> +                       print_bool(PRINT_ANY, "in_hw", "in_hw ", true);
>                 else if (flags & TCA_CLS_FLAGS_NOT_IN_HW)
> -                       fprintf(f, "not_in_hw ");
> +                       print_bool(PRINT_ANY,
> +                                  "not_in_hw", "not_in_hw ", true);
>         }
>
>         if (tb[TCA_BPF_OPS] && tb[TCA_BPF_OPS_LEN])
> @@ -245,14 +247,13 @@ static int bpf_print_opt(struct filter_util *qu, FILE *f,
>         if (!dump_ok && tb[TCA_BPF_TAG]) {
>                 SPRINT_BUF(b);
>
> -               fprintf(f, "tag %s ",
> -                       hexstring_n2a(RTA_DATA(tb[TCA_BPF_TAG]),
> -                                     RTA_PAYLOAD(tb[TCA_BPF_TAG]),
> -                                     b, sizeof(b)));
> +               print_string(PRINT_ANY, "tag", "tag %s ",
> +                            hexstring_n2a(RTA_DATA(tb[TCA_BPF_TAG]),
> +                            RTA_PAYLOAD(tb[TCA_BPF_TAG]), b, sizeof(b)));
>         }
>
>         if (tb[TCA_BPF_POLICE]) {
> -               fprintf(f, "\n");
> +               print_string(PRINT_FP, NULL, "\n", "");
>                 tc_print_police(f, tb[TCA_BPF_POLICE]);
>         }
>

You may want to use print_nl() here, lib/json_print.c:228. It fits
exactly this use case.
All the rest LGTM.

> --
> 2.25.3
>

