Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466941350EF
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 02:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgAIBU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 20:20:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbgAIBU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 20:20:57 -0500
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DF19206ED;
        Thu,  9 Jan 2020 01:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578532857;
        bh=BzcdLymcAnMhokcoNQ0EAd8i10HZEfbtCtWnLT3slis=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Qk1Ms3mx5EbK4D0F3j5Tdd57KZgvNsGyxN03MvkyqeFhTKwcwKfbSr3nSwQ1VfXSr
         wJPsV5jdzwkMNETze4RDjitlCg9HZVvDXLwRP8jzFFE5RUhTY0PQCeudDIS8A/dp2u
         IsdogrGLLnpF1geEnHdANGUKzRKSjTYZ2H5XUX6I=
Received: by mail-qt1-f177.google.com with SMTP id n15so4532958qtp.5;
        Wed, 08 Jan 2020 17:20:57 -0800 (PST)
X-Gm-Message-State: APjAAAUAFJ9/f4/xc12YH410qGHjijFvVdu52uhcyclHv+0wJHfEWh7V
        YOBKuCD0NOD7FOLtFcFu+TY+JDeilTwhqdUveas=
X-Google-Smtp-Source: APXvYqyLWehWTYdUI5Gfevq+ixnCRiztBppd11LJH0lDzRmaPcPWTND1xGy/Uh6F+KUyj/Ya1239R/Ee9JfAMRme/KE=
X-Received: by 2002:aed:21b6:: with SMTP id l51mr6185279qtc.22.1578532856223;
 Wed, 08 Jan 2020 17:20:56 -0800 (PST)
MIME-Version: 1.0
References: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
 <157851928650.21459.1089027650128166319.stgit@john-Precision-5820-Tower>
In-Reply-To: <157851928650.21459.1089027650128166319.stgit@john-Precision-5820-Tower>
From:   Song Liu <song@kernel.org>
Date:   Wed, 8 Jan 2020 17:20:45 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6DqNbnPipJDZ8LUx0bmq2ZHDxzzG0KYPrw527KPq9iFQ@mail.gmail.com>
Message-ID: <CAPhsuW6DqNbnPipJDZ8LUx0bmq2ZHDxzzG0KYPrw527KPq9iFQ@mail.gmail.com>
Subject: Re: [bpf PATCH 1/2] bpf: xdp, update devmap comments to reflect
 napi/rcu usage
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 1:36 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Now that we rely on synchronize_rcu and call_rcu waiting to
> exit perempt-disable regions (NAPI) lets update the comments
> to reflect this.
>
> Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>
