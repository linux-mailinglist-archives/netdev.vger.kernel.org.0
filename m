Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414EC205B34
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbgFWSzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733170AbgFWSzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:55:38 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E21C061573;
        Tue, 23 Jun 2020 11:55:37 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id e13so1565727qkg.5;
        Tue, 23 Jun 2020 11:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+GtTOEjrnVjJo2x9/yYoA12gBw1AbLHR2r4C11c4zLM=;
        b=b//vyW2r5AQ2vHf92V/+ojguanoz50bXx2ZwGSWuAcZWkul59K6Ng7d7vYURLpKucS
         KUzjwJ8DbrCD2na5nH133K1lCDc05E/uEsfNiTBiDf7mGj1hEku6S2dHYaDxrNYb9hmh
         O21uxJWyX5++2j3j1EVCp2R94coMHoaG49cDS5oYvIyHF5ri9Hz2FnEWCwE6tWQ/GWVk
         +bs1ki7Fq8LWACPk/tydX3eesq3oVs10lPxWkgP4VtkCO68GuBKziiWzPljmZ/orL9/O
         X4jnOASaxSDQK7+llki2IGAHG0VldUBcvEcqjGYVnnNaw4h7iHOpHV6jza1RZRP+Pzvw
         HDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+GtTOEjrnVjJo2x9/yYoA12gBw1AbLHR2r4C11c4zLM=;
        b=MJnAsmVUbDiprMiAgELFcHfuQ2Va8yoPzlPlwBl13W/cBXoWt4ceX5hPXmHqL1z4um
         QFq3khQijim5VBKd+9VxzIkfawuPolAhpfXKdXwXuE4LW9EY1uKfNknfIrs8fbc9q5l6
         yIqr+ujP/x/5PKxBjZeeQ/+igj4fkEr3AgAKtm52ClwzEyWBNm/uFLjdqaEqfMnDEWe0
         5Fh26MEb67dBRJ9j9ermK8oVAQLqgI4Ytq/q8/WFa4VotrzXdVkMuAkM8yi/SGr27p+6
         ZTV+BUJ8deH9kRebMYDqx84Sj+eCOgUUBJX1Yt4kGbNBmTMZ/oVHYidFlq0TtDiPJxLb
         xGxA==
X-Gm-Message-State: AOAM532W+gaZD4/0PZZ1HzIOX/IHiSIt46kEUKEqES8vGbZceeo9sI62
        NKu9NOSCRV2dKqdaar8oIZUfRgLPFnVZbcyHRE7vJoBj
X-Google-Smtp-Source: ABdhPJyoSo8AQ6QQbqf36ib+qkBnaZa7TedkFPdRrJAbHrnHrG9S2nekoSxMvo/Bw79n5jYu+zQAs5Vfwc99ysPpSMI=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr15804490qkn.36.1592938537019;
 Tue, 23 Jun 2020 11:55:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200623161749.2500196-1-yhs@fb.com> <20200623161804.2501684-1-yhs@fb.com>
In-Reply-To: <20200623161804.2501684-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 11:55:26 -0700
Message-ID: <CAEf4BzbUtWz6BUiuOcCpbw0_F+1jYmKx2SJZiGxRxbKus3pBug@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 12/15] selftests/bpf: add more common macros
 to bpf_tracing_net.h
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 9:19 AM Yonghong Song <yhs@fb.com> wrote:
>
> These newly added macros will be used in subsequent bpf iterator
> tcp{4,6} and udp{4,6} programs.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/progs/bpf_tracing_net.h     | 35 +++++++++++++++++++
>  1 file changed, 35 insertions(+)
>

[...]
