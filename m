Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E4035233C
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhDAXNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231160AbhDAXNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:13:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33387610FA;
        Thu,  1 Apr 2021 23:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617318793;
        bh=ByCZqIe1e7hazFRH++kiAEAGCdLWiVrfLdpiyiJTX1M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mPhEiXIkPFXJMpr4Rn5vHC83CeO2jA0z84WR/f/rvHN4uwes+P4ZedrrIcbXJa5Si
         sqd19/2y/3Ek+NR3ADc2AVtHPDBE/zLKmszckysp21ASND6ICjOA9piKjKSPGo8mtQ
         pPQ4q1U/MlFBSmsoLOcY77AkFGyqLKNSbUjR8i9jg/asel/IbImwjUEFSR+cVym2Ee
         12BgMZTZEZNYAVkaegyCPzkP4hREvdP5+apC4Uw2Aj/O2/+95pLN+y1ssYOphw0jvr
         h0pnrdJ7RmNH1K3lN5mveYr+q3xqpQgz7K4nOdtCL0Gj7tIGe8bouTNErwlXtEhsnB
         oKWGjn6oGlf8g==
Received: by mail-lf1-f51.google.com with SMTP id w28so5167347lfn.2;
        Thu, 01 Apr 2021 16:13:13 -0700 (PDT)
X-Gm-Message-State: AOAM533JDy2/z4Cu/U3ZX7uyT8bVt8xaCzkupmG0JUmw8TqjV5UEh79K
        gqhqRjrh3hYm9JflYWc0ARvRfV936dYeF4GSQUQ=
X-Google-Smtp-Source: ABdhPJzfULRP6XTk/DCoDWy/oq9taXLGT1wyYUiQaw0gEdqD3RAjbxyzKJrllK95F41URpYn+U4wtsXw8Vj1HFFYtaE=
X-Received: by 2002:a05:6512:3582:: with SMTP id m2mr6985279lfr.10.1617318791424;
 Thu, 01 Apr 2021 16:13:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210401072037.995849-1-wanjiabing@vivo.com>
In-Reply-To: <20210401072037.995849-1-wanjiabing@vivo.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 1 Apr 2021 16:13:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW43X4ra8JU+YYndT7VKkc3h0k=2oKKpCtUtf+w+emPorw@mail.gmail.com>
Message-ID: <CAPhsuW43X4ra8JU+YYndT7VKkc3h0k=2oKKpCtUtf+w+emPorw@mail.gmail.com>
Subject: Re: [PATCH] linux/bpf.h: Remove repeated struct declaration
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kael_w@yeah.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 1, 2021 at 12:22 AM Wan Jiabing <wanjiabing@vivo.com> wrote:
>
> struct btf_type is declared twice. One is declared at 35th line.
> The blew one is not needed. Remove the duplicate.
>
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Acked-by: Song Liu <songliubraving@fb.com>
