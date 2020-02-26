Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C24E170C71
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 00:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgBZXQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 18:16:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgBZXQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 18:16:22 -0500
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33444222C2;
        Wed, 26 Feb 2020 23:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582758981;
        bh=imsIPvzUdMXdp2b5b0naPY0H/3L4+0NMbzhPaO819G4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=I2WoaJn2BLRLBDPp3yKIlU56uRElYsI+uDBQTHg1axXmj2TICcTArEfSdbG1vyIzW
         bNqe5t69KSZhl/OT4siXo7midEhI5jDrL5Fy0iV+d6HZwfzt+F+S8hYf2UC+PBDrqA
         W8Pw8lyVwct9EGMsdLcyuFddo04FfrtKoBly6pLU=
Received: by mail-lj1-f180.google.com with SMTP id r19so1099398ljg.3;
        Wed, 26 Feb 2020 15:16:21 -0800 (PST)
X-Gm-Message-State: ANhLgQ26X1+28/J7IclTxOiUmCySK+ozicXW3yC095iIJWy6KlydBMXX
        rJlGKaxKQAZytx1zOKQ28nVMZBvwoxx+qd6ZrtA=
X-Google-Smtp-Source: ADFU+vv8dlFcHAvYL/aS9uFbdp4/tXugZPHx3SRZxA6NAqaZH//zk9PuGpHAJKJdmHnpiDRYFK6ifiLjKibrupIio5g=
X-Received: by 2002:a2e:804b:: with SMTP id p11mr800865ljg.235.1582758979413;
 Wed, 26 Feb 2020 15:16:19 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-10-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-10-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 15:16:08 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7Rvo1a8PEh8Yszxfrhdtdb8k5=1FAM1N2qU7gwFL=p1w@mail.gmail.com>
Message-ID: <CAPhsuW7Rvo1a8PEh8Yszxfrhdtdb8k5=1FAM1N2qU7gwFL=p1w@mail.gmail.com>
Subject: Re: [PATCH 09/18] bpf: Add bpf_ksym_add/del functions
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

On Wed, Feb 26, 2020 at 5:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding bpf_ksym_add/del functions as locked version
> for __bpf_ksym_add/del. It will be used in following
> patches for bpf_trampoline and bpf_dispatcher.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
