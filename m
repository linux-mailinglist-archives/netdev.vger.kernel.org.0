Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27133170CBF
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 00:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgBZXsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 18:48:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbgBZXsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 18:48:32 -0500
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 015D424679;
        Wed, 26 Feb 2020 23:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582760912;
        bh=XJHK/UuB/Y2+Ir3mkb0hbeudO3I0uq4AMHLCzh/Nm9c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bU2VOYP2Iihmqpn49HrsDqfiUxTm34PzEjQPqkcZzRikhuBSt11ryORkiA4FuWQB4
         uN89DJPyVgMr2Ut6xqTapIBO+NYq44jsq3SatHdKXf4hLKRdGfGrvs9WzKIqV7ScpW
         8un1M1bu66F846fwWYdLUSphDHZXh9Pesm28fWQw=
Received: by mail-lj1-f182.google.com with SMTP id w1so1162525ljh.5;
        Wed, 26 Feb 2020 15:48:31 -0800 (PST)
X-Gm-Message-State: ANhLgQ0rvTq9QaXrr7ALAd3smdiX59RD57y7BurlOblttxgmHitnLMSP
        sfDPsGQZSUhdidrP8ZYOvz0mCArDM/67hPCuPvM=
X-Google-Smtp-Source: ADFU+vtfRbPudOCLpjk8N4q/BkcjR0tLKN0N7D9fZMkMGk/6tph7b7GU/DRMWcn50KpTI57loE05bMvbTNXyyxlZGe0=
X-Received: by 2002:a2e:89d4:: with SMTP id c20mr896413ljk.228.1582760910143;
 Wed, 26 Feb 2020 15:48:30 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-15-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-15-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 15:48:19 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5OH7YitT86i7v2NySM7Nny3kgRWDKbHE02NBXfaEoCbg@mail.gmail.com>
Message-ID: <CAPhsuW5OH7YitT86i7v2NySM7Nny3kgRWDKbHE02NBXfaEoCbg@mail.gmail.com>
Subject: Re: [PATCH 14/18] bpf: Add dispatchers to kallsyms
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

On Wed, Feb 26, 2020 at 5:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding dispatchers to kallsyms. It's displayed as
>   bpf_dispatcher_<NAME>
>
> where NAME is the name of dispatcher.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
