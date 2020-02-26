Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83499170BE3
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 23:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgBZWv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 17:51:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727763AbgBZWv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 17:51:27 -0500
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E44BB2467D;
        Wed, 26 Feb 2020 22:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582757487;
        bh=+YWv/+rohBZC7pJpEZSYUsyDYUXcGFFvUizlm3YA5Yw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZgTiZUQ61x3NUjOL5NiPPoVaFM4dhfdAqx1DCQsfeGMbYXe3kLPCmoDFo8Qu7u1AI
         zUNuuU6Q+H5mPPXMzeejqrGX5c+mI5CvltynClmIWiaHQzo9pUMNG4PyZNq04I5hcQ
         lU2anuBcsXzJiTJvBfnsxSxIOacoCEjdz5LzkKyU=
Received: by mail-lf1-f53.google.com with SMTP id n25so583964lfl.0;
        Wed, 26 Feb 2020 14:51:26 -0800 (PST)
X-Gm-Message-State: ANhLgQ1fLRFdlbKZLMC2u7pJGmMoLcVYnMFOPsKNHe8lIDyGFtCr6ock
        +YojV4XG0/fVnAbnXy5a3wY4GyVm3QETe94/naw=
X-Google-Smtp-Source: ADFU+vulNT+qEuR789y3B6OTGrquPLcLVjoVwOHBZKzWvL/YdHCLiZ9YJrhVo3uJ2ugjAsMqGM9uHx7537LBaQD7W6o=
X-Received: by 2002:a05:6512:6cb:: with SMTP id u11mr444948lff.69.1582757485012;
 Wed, 26 Feb 2020 14:51:25 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-6-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-6-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 14:51:14 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6NCwxW2qQCFcA3qGOeyd=qz0ZHQGUidWfO-oXeen0r2g@mail.gmail.com>
Message-ID: <CAPhsuW6NCwxW2qQCFcA3qGOeyd=qz0ZHQGUidWfO-oXeen0r2g@mail.gmail.com>
Subject: Re: [PATCH 05/18] bpf: Add lnode list node to struct bpf_ksym
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 5:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding lnode list node to 'struct bpf_ksym' object,
> so the symbol itself can be chained and used in other
> objects like bpf_trampoline and bpf_dispatcher.
>
> Changing iterator to bpf_ksym in bpf_get_kallsym.
>
> The ksym->start is holding the prog->bpf_func value,
> so it's ok to use it in bpf_get_kallsym.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

nit: I think we should describe this as "move lnode list node to
struct bpf_ksym".
