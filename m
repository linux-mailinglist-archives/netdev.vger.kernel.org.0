Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58660205B41
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387476AbgFWS4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733170AbgFWS4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:56:43 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D64C061573;
        Tue, 23 Jun 2020 11:56:43 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id g13so5867475qtv.8;
        Tue, 23 Jun 2020 11:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OdEs8XCWud6zPtKCCy3vVXXVB5i1Ldq4hr9kZhvUHzs=;
        b=CbDg03Rw3Khmtv7g5GeHAndphb2mNm+XfR4XWnx1M/RRHpidXx/8PYSsnxunhAzexJ
         bHoeZts7jcYNzfrNmApGAbROG1NO+CmZgdysN6G0kE39iqbpgkvaSQlof8BQJBvXHvsW
         vvG3p/AreRkuyjOI3EZMrNfSwwGWFl7pZ5EmzndtM2ucfmp2Y9MAZwCSbNV1rInFG0So
         sTiG6lh/jNIcMJ3SmaXXhPuybREMdImgq/SZ8NrLGe3GhiQGDe3zjTDSo+ZQl22kX7hv
         MQlOk++74Z0TH8B33VRj5OJ/85SZkpsFrbcHOdTsnaJmD9D8gUFGfZIXqNXkjQTrTxbp
         2hxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OdEs8XCWud6zPtKCCy3vVXXVB5i1Ldq4hr9kZhvUHzs=;
        b=DK0bNeQWQcUbcmlMxMSKz0JkeHGPB8mUetr++xa3uq2G+AuNm0ZgYBhYoU8nsU2yz5
         T2F9YVMWiXvIMaeZ5qRG64pTgAhlByUhkJnBj/r1iqAE0x22oj0WmIXpGJ+FFb6FCrDC
         lq0G5pyQ/mTNhxHv144qZTyuvghjhcTEh40bCwTD25wIxqfmFzhmAc7Z0jwraSiKJ5L7
         kmeiGpnkbuPR5XwfY5JuCeEWGgFbLAyM0I7X0kBiIvOLQ5t/3qybDMrxI3gmQcrL9AoD
         3P22+NphYNb7QFaVNS9qbZMEm4liyywgcYoCK0M+PIE/aEssqg7CPhIt3jDZe0Aflolt
         n3KQ==
X-Gm-Message-State: AOAM531iPewior+Gt+BYNyxET1Y9jLos5EMJksF0wmcU8wbnd2vBYuJc
        +FdQx+V1+sjrGfRhk3AcC+E/xPgbJchKXAT6nqg=
X-Google-Smtp-Source: ABdhPJwed26RlIXo4962AHM7Nsj9QZia6M/k2LQY7w0EvF6unDFzu6+Bfg7oj4Qt9lod5tgUi+Z9DOZvhnBUo5slbK8=
X-Received: by 2002:ac8:4cc9:: with SMTP id l9mr8998102qtv.59.1592938602385;
 Tue, 23 Jun 2020 11:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200623084207.149253-1-colin.king@canonical.com>
In-Reply-To: <20200623084207.149253-1-colin.king@canonical.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 11:56:31 -0700
Message-ID: <CAEf4Bzbp8h9w0w56kHnaXW37+zoHapRR0Sjc7=vaH7i5ceF9fw@mail.gmail.com>
Subject: Re: [PATCH][next] libbpf: fix spelling mistake "kallasyms" -> "kallsyms"
To:     Colin King <colin.king@canonical.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 1:43 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake in a pr_warn message. Fix it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 18461deb1b19..deea27aadcef 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5741,7 +5741,7 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
>                 if (ret == EOF && feof(f))
>                         break;
>                 if (ret != 3) {
> -                       pr_warn("failed to read kallasyms entry: %d\n", ret);
> +                       pr_warn("failed to read kallsyms entry: %d\n", ret);
>                         err = -EINVAL;
>                         goto out;
>                 }
> --
> 2.27.0
>
