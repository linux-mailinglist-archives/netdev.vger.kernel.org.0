Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD4C7170CA4
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 00:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgBZXge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 18:36:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbgBZXgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 18:36:33 -0500
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17A2B2467D;
        Wed, 26 Feb 2020 23:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582760193;
        bh=vXpyWwhUGUQiX5wgoNX1FisqdYdJy20No/deVFYlJkU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dJwxw/RfS7DkTN3k0AP1N+HpEWoJbxSsE0e6+DYSovGR46ynSqqFv9D754Y/Q1Ikw
         xYTx0ARYUqQ5u90E+Z8Cf3dVP53FUC/r9Bbf7hAB2p/FHST7R7TKXq4czeBgvu4L4N
         B41SyCeQdkgtkebcaqeYPgyuXftjAsTUsmxZPGN0=
Received: by mail-lf1-f45.google.com with SMTP id r14so631613lfm.5;
        Wed, 26 Feb 2020 15:36:33 -0800 (PST)
X-Gm-Message-State: ANhLgQ3wjuUJoTpmx04/hGGTP6x41Pc2TGDklTWUPED1S8dhk254HIEN
        CUML3JFo9hN1RapqbrK6scRTpwQiFiG/qv1m68I=
X-Google-Smtp-Source: ADFU+vsNWFvucc6bvsLVTB4fTBz+IMK7M5fkkSPO8WUB3Nxr327qnEK3G2xJo9hTTPGa/Xvx5Ux01f4AIiPq/lcYA70=
X-Received: by 2002:a19:840d:: with SMTP id g13mr527766lfd.162.1582760191201;
 Wed, 26 Feb 2020 15:36:31 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-13-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-13-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 15:36:19 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5mb=3VNnyvy4k5FHRh9-OdKDE5cz6vW=0qVqfP7-x7yg@mail.gmail.com>
Message-ID: <CAPhsuW5mb=3VNnyvy4k5FHRh9-OdKDE5cz6vW=0qVqfP7-x7yg@mail.gmail.com>
Subject: Re: [PATCH 12/18] bpf: Add trampolines to kallsyms
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
> Adding trampolines to kallsyms. It's displayed as
>   bpf_trampoline_<ID> [bpf]
>
> where ID is the BTF id of the trampoline function.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
