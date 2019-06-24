Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B16251C01
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 22:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbfFXUIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 16:08:07 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36633 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfFXUIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 16:08:07 -0400
Received: by mail-qt1-f194.google.com with SMTP id p15so15914115qtl.3;
        Mon, 24 Jun 2019 13:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jn/w53YJ4Q/KOGOCBKw6wUZlBtvSFROxiUctr/L28Ro=;
        b=Uo42VIhnTbzCA4Ozzfe6YQOxoA3CFwPgWBgS2/smjKrbL8V70yQZaVcV7Dhz55IyFi
         MDHwAuo0fbuNYqvyHZPKxi5HFAZ9eMZu40E05KpoxaEhoW2ym2bsGdI2AMmPsH2GbwaI
         A8D5rxBt5QtnMGec03ZSf43TMVeCzjP1k4riaJXqCdwx9tSA29Zk5y4PfSEgb+C/tOn4
         8/XxPI8IvH5Sz96v28xdsJS4r2jKwN3kB2hgGFL/oiYGW2LVy4lAiWashl/ra3omK0lo
         q2AU+hNgmHQDS3dH6VdXdgcwxLFmKd25hnSmFvc5C7sve1yQV3fxNcHVf/397C5E82S0
         3VHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jn/w53YJ4Q/KOGOCBKw6wUZlBtvSFROxiUctr/L28Ro=;
        b=Dt3YeNUSeCdQd3t07QpFpT1ihgDtToB+++edSNBLDagaYu7LQVY0FG5R5VxdQtP2Yr
         K9bZajZlsnVQwctXXol5d7lvxbGvNONDr6x0tT9f59Dz7DIxfHrn6ieMqjkZf419Otdw
         Odp6DhyJdP5N+ptDv0UAw0Wz+gRGn27ch6J7KpSqFuN/lNaWAXKjg/abi5g1UHdF5hKz
         D2//sZJUhbnHvWL2ZhPES+TkKp5+8XBeefktYegMDbUJ1yhVtMVKVTJeYDKf0UBw43oc
         Erah5SrlE4b39QlKTcXE69JL4LKlif+sGya5TX1rp0Omyaehuu2qi3L72ok+AzRZ0mRv
         us/w==
X-Gm-Message-State: APjAAAVBWIJNGL7Tm1vC79lTmC2NPyrEqZVU8VnZou8dUHpw4G5+oX95
        VIz4YdTv9yNrrc3jakCGqzki7HpVs2HjgWR96C4=
X-Google-Smtp-Source: APXvYqzL9Aq6zBn7pr7JmJnrrDNTZgpzKLz/k4Ru5O5kpuz00LKqwQXw9OuJb4OT2je3tIIoAtXBTp6qQ7PnsEltOTg=
X-Received: by 2002:ac8:25e7:: with SMTP id f36mr119795809qtf.139.1561406885830;
 Mon, 24 Jun 2019 13:08:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190624052455.10659-1-bjorn.topel@gmail.com>
In-Reply-To: <20190624052455.10659-1-bjorn.topel@gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 24 Jun 2019 13:07:54 -0700
Message-ID: <CAPhsuW4yRnimgpqZxEU0t33epXnOVjKXsAU-bks=c21i7OdDsg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] MAINTAINERS: add reviewer to maintainers entry
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 10:45 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Jonathan Lemon has volunteered as an official AF_XDP reviewer. Thank
> you, Jonathan!

Thanks Jonathan! Please reply with your Acked-by.

Thanks,
Song

>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0cfe98a6761a..dd875578d53c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17284,6 +17284,7 @@ N:      xdp
>  XDP SOCKETS (AF_XDP)
>  M:     Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>  M:     Magnus Karlsson <magnus.karlsson@intel.com>
> +R:     Jonathan Lemon <jonathan.lemon@gmail.com>
>  L:     netdev@vger.kernel.org
>  L:     bpf@vger.kernel.org
>  S:     Maintained
> --
> 2.20.1
>
