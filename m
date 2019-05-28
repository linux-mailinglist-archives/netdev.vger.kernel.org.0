Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56CA02BE8C
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 07:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfE1FTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 01:19:41 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:36221 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727342AbfE1FTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 01:19:41 -0400
Received: by mail-it1-f194.google.com with SMTP id e184so2030723ite.1
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 22:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zFv9SFYySkMJsLGzaWdIVBSKb6/ERvC/jlJi9kiZuBk=;
        b=rmPe0h0NzXstY3L2sB/eMuyYNx8BPw4z5QCsemhlEaUvoq9MZjkeI4oqeIUXDjeO/5
         dTuWsfBT8fqshakdNZr+yEfYZ+y+qfkb00a/HJ6JOqbIaUKPUnfZevHNDhOhj4I7asZf
         tqeVVpOE5s+fLhouHi6QjZjeEl0s4gSS62s4iAGMBqGl+c1ahsspyTBponihAtdazduE
         z0RbatIyrJZcR5Ywnd1CY4/bhYQZo40JRjSFyk/iW0JyCpmdg9EfSYWOiUyL7g+445Hn
         W9hW0Bb0f1SbMHpUjbrNORvq+QJdR7CvguCKcAmLAhuo8QJdKp06Pw3jIxNrws9q8NDy
         eu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zFv9SFYySkMJsLGzaWdIVBSKb6/ERvC/jlJi9kiZuBk=;
        b=dhvcOC3zD9Xo7gt7s9+7Kb24GGHgIk3ovLNZlWYsIQi0EyzFCXpGkKSa8Hh/OUiSfK
         /axL23IY5B5xaqXZGjnpimqKKKPRvqISpnsKZQW2GPeZLp1/aIyU3K7nPXiFNjLQQU00
         x6lMl9PClCsVdooHIUziQeQYyJdAyR5bJGPydGPB0XuxzkxBGcOCzsATi2djX91KawXc
         +aGGZd3nxa/RSk0s4R8m/4wqx//i5PQwHhqN6yFhYLPboRsugiSLut3WIRV5k/Q7furM
         iWmJWemSbl0C/Ms/YYP9YL3PFtJkcm0PgTyebQOPQvzTjS+nLGWHDKWa2Lq1vfBFaucJ
         eW4Q==
X-Gm-Message-State: APjAAAXwIn1OWCxir7Dr6OODF26h6SnTWiPFuL0q+1raRSloMKx9o/B2
        9K2/kJAeg1Is4ij3Cwg6swnoNTyAsOTzwoZlH9A=
X-Google-Smtp-Source: APXvYqyngXMZKwqMtvowwQygdZ0/A79vN7e5Ex/DE3MUABnllnZQnPib6jxHIHxBDRN8Pi6Uzkht+9LoELHxg2yBKNY=
X-Received: by 2002:a24:e4b:: with SMTP id 72mr1923670ite.142.1559020780470;
 Mon, 27 May 2019 22:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190526103211.12608-1-luke.tw@gmail.com>
In-Reply-To: <20190526103211.12608-1-luke.tw@gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Mon, 27 May 2019 22:19:04 -0700
Message-ID: <CAH3MdRX0m9EM6kUuRKr8MCf=G-EOUGHf9OobsRZgLV46s8mEfA@mail.gmail.com>
Subject: Re: [PATCH] [PATCH bpf] style fix in while(!feof()) loop
To:     Chang-Hsien Tsai <luke.tw@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 26, 2019 at 3:35 AM Chang-Hsien Tsai <luke.tw@gmail.com> wrote:
>
> use fgets() as the while loop condition.
>
> Signed-off-by: Chang-Hsien Tsai <luke.tw@gmail.com>
Looks like right now we did not really differentiate error in fgets from EOF,
so the change is in this patch is equivalent to its previous behavior.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>  tools/bpf/bpftool/xlated_dumper.c           | 4 +---
>  tools/testing/selftests/bpf/trace_helpers.c | 4 +---
>  2 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/tools/bpf/bpftool/xlated_dumper.c b/tools/bpf/bpftool/xlated_dumper.c
> index 0bb17bf88b18..494d7ae3614d 100644
> --- a/tools/bpf/bpftool/xlated_dumper.c
> +++ b/tools/bpf/bpftool/xlated_dumper.c
> @@ -31,9 +31,7 @@ void kernel_syms_load(struct dump_data *dd)
>         if (!fp)
>                 return;
>
> -       while (!feof(fp)) {
> -               if (!fgets(buff, sizeof(buff), fp))
> -                       break;
> +       while (fgets(buff, sizeof(buff), fp)) {
>                 tmp = reallocarray(dd->sym_mapping, dd->sym_count + 1,
>                                    sizeof(*dd->sym_mapping));
>                 if (!tmp) {
> diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
> index 9a9fc6c9b70b..b47f205f0310 100644
> --- a/tools/testing/selftests/bpf/trace_helpers.c
> +++ b/tools/testing/selftests/bpf/trace_helpers.c
> @@ -30,9 +30,7 @@ int load_kallsyms(void)
>         if (!f)
>                 return -ENOENT;
>
> -       while (!feof(f)) {
> -               if (!fgets(buf, sizeof(buf), f))
> -                       break;
> +       while (fgets(buf, sizeof(buf), f)) {
>                 if (sscanf(buf, "%p %c %s", &addr, &symbol, func) != 3)
>                         break;
>                 if (!addr)
> --
> 2.17.1
>
