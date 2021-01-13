Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB9C2F4136
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 02:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbhAMBaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 20:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbhAMBaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 20:30:11 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB311C061575;
        Tue, 12 Jan 2021 17:29:30 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id n11so716331lji.5;
        Tue, 12 Jan 2021 17:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7OzEdrgsXIQxiJXUsDqH0AQlhsFIMk4yh3iZifJglRI=;
        b=cbGdmVGNuCgakrB8GlQBE6xkWOlHMoMX6A32FxG/Q4QGr5gzsVryzUuKi4dcz/9zRY
         Urx80t+k3vMAsevDJ2oIv6g+VKNgiWAhlDNIwOmWn8nVSacxQrV+HatFlioWr9iSm1ss
         CedL8hbBKLYaypVwkCKbcKKHHkoDcMTZJXTAPUsJWZ0CxGA5eaO7IDm0izLiPnx4onzL
         pHz8Ia+O0Ipd0chUU0otXavYbTjUwwMqV/9K/geDsclYaPXgKxVEH5Zh69xKBuSJDTIA
         vqX1zuGXjUh6cfE9tttaYM469Z/memZQScQGmmtAE6ZEUqsKng1AAWJxd/TY9ePiLIHA
         ma5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7OzEdrgsXIQxiJXUsDqH0AQlhsFIMk4yh3iZifJglRI=;
        b=CBpLGU/9VH7JozHwW/dFO/LpTg0j7d4zCxTx9joaH+UdA/Yq9vXSpvQ2uiauOsLYtB
         N0/5Nf4/ZIFycdYYYSKTxEA7oBODb6pAJ6vYw52HeHW8mto6533n+I3cWV/xR4vCtO0y
         PQs/kb7W7yerIp21fydab9RQ3gQjOL/UJgkuiAn95q11hSdRvNuz6aqRR+B8KSzTARmd
         bzkAKRysQBxs22djPdnFedlHzbl4YUttsKs9l1LBKQbY/0AUB67s+l02SB9SXMVTCThX
         s2PQiKaDApwrN9hdtU8lJXTmfmRdLGSbqMgG35/Hir4Day3/nOkObC40Lp6fYKYfCTSQ
         E+zw==
X-Gm-Message-State: AOAM533aZtsm7VpYrFjiZ8PhiSEQbuX9WvtPEluB5q61FN+6aF9U0jJv
        DIhniWk8fVwaDeTvuxKtPe0+5hD2zWVVLngpbqw=
X-Google-Smtp-Source: ABdhPJyzfWDD+oAbVc9I/79/ciPc//xjSknbFO6v/jsEA3LB5XVqzc4VbkC92g8vKRgHSPg39VTZ1yUefM+ve4G3x7w=
X-Received: by 2002:a2e:3c01:: with SMTP id j1mr858783lja.258.1610501368034;
 Tue, 12 Jan 2021 17:29:28 -0800 (PST)
MIME-Version: 1.0
References: <20210112075520.4103414-1-andrii@kernel.org> <20210112075520.4103414-8-andrii@kernel.org>
In-Reply-To: <20210112075520.4103414-8-andrii@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 12 Jan 2021 17:29:16 -0800
Message-ID: <CAADnVQ+8-wrK1CFSLoVwAhZD3BQkbB-_niDKPcadf6WV7d+vkw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 7/7] selftests/bpf: test kernel module ksym externs
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 3:41 AM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Add per-CPU variable to bpf_testmod.ko and use those from new selftest to
> validate it works end-to-end.
>
> Acked-by: Yonghong Song <yhs@fb.com>
> Acked-by: Hao Luo <haoluo@google.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Applied.

FYI for everyone. This test needs the latest pahole.
