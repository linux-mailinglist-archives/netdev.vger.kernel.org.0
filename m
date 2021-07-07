Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164503BF25E
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 01:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhGGXTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 19:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhGGXTt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 19:19:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F5FC61C84;
        Wed,  7 Jul 2021 23:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625699814;
        bh=oaY1QLNwgWcBreIyyoWsiRmFNPmVa5XEPrqbO1OF0qg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lNLOvOPGE/MnxWuruSWHbXez8uR+TPODxR7cLXGNm/elRmkYkTyCVYI0cAHpgglLF
         GFIiuJwkisU5rytEGUb4so/LfhntRir+8aZdLQc+PujKikUk9Oyj2OnkDxSaeO83f4
         923zOGzBXc6ZZ0RzxSBRgo4n7PbU5LxVkwTsVwPoZLP1PlrU/jE0TAJ8GwaeXT2ilr
         UxceBizkUJr/NW5dny2A4bAT97avRlhZJVN0mXkunFsMxg/a595CRBcEPZh4mRpRnn
         q18r+9rf9Mwm5Yr26ztNZ6re89osRI/3GJUZolyZJ2Equ/jMHoLYdkaj7GVtBcBdTS
         2GJYJ+UfL9DQA==
Received: by mail-lf1-f45.google.com with SMTP id y42so8886728lfa.3;
        Wed, 07 Jul 2021 16:16:54 -0700 (PDT)
X-Gm-Message-State: AOAM5317fDguqFkr3aGIongcXABFl5EZRdPnEWZR/FJWDo+oKFhUXwi/
        9gidoIfgOqo5aW42QgnW4Th75eaRvp3P9onHihM=
X-Google-Smtp-Source: ABdhPJzZQCFhxB6Q+KjZBEycNNvXkeN2V+IcljzAC7GyUZPCMLinZporurRrbs2Ak3XQ2jRBThyFBg5phd2m03K6l90=
X-Received: by 2002:ac2:42cb:: with SMTP id n11mr17900698lfl.160.1625699812750;
 Wed, 07 Jul 2021 16:16:52 -0700 (PDT)
MIME-Version: 1.0
References: <162523477604.786243.13372630844944530891.stgit@firesoul>
In-Reply-To: <162523477604.786243.13372630844944530891.stgit@firesoul>
From:   Song Liu <song@kernel.org>
Date:   Wed, 7 Jul 2021 16:16:41 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7f_kyWG+gL2+W03iK3K3jUJy6AjmAdxqHX33GbUMS3oQ@mail.gmail.com>
Message-ID: <CAPhsuW7f_kyWG+gL2+W03iK3K3jUJy6AjmAdxqHX33GbUMS3oQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next V1] samples/bpf: xdp_redirect_cpu_user: cpumap
 qsize set larger default
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 2, 2021 at 7:07 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
[...]
>
> The production system was also configured to avoid deep-sleep via:
>  tuned-adm profile network-latency
>
> [1] https://jeremyeder.com/2013/08/30/oh-did-you-expect-the-cpu/
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Song Liu <songliubraving@fb.com>
[...]
