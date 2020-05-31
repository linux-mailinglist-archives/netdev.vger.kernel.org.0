Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA561E95F6
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 09:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbgEaHDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 03:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEaHDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 03:03:12 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907E5C05BD43;
        Sun, 31 May 2020 00:03:12 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id b6so4267540ljj.1;
        Sun, 31 May 2020 00:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=orX/y8KZmJNFBM29Gj7r/7pgbaU1Wmo90frTAFgI1II=;
        b=HxqCyM1EcKPbKMqPglb23SznK7zXBoHpxAe9uB5JZW4tnTxun6GQOGDw+5tBcOaECm
         suvkefwQ8xbLMfVC0td4JIZo/MMBvKSj6BexhDRnxlbkIPb/scSpoVVPe143s/vDo4EC
         sP/LA3rn6FUKhnOs2cy+7Ln4pSfdQzUvT/GVMCO+HuBezDF+raa3MHX6WRGeIUKvbY0b
         /rQt0v1xJO4cQB3MVfq6unPXq/6Y7qyuavQKhIX2u0UJKEr+1qoFR2p6oCwqk1XAj1SF
         fukGMWUxvbvVYgv1Oau5RfuKCOLwZnXQ2O3IS8CFpnidpslrSl5qRmZuHTYhOE49Ep23
         O3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=orX/y8KZmJNFBM29Gj7r/7pgbaU1Wmo90frTAFgI1II=;
        b=OMxo/P1Pea4s33P1mwMT7YtjItdM7NTWVbEPIAiThKlWIya8Np/FdkZOxb/IJT8IRG
         T11iKLb6RAtoL4NblYt3MLR9Sol5AIoxOuTYPdztorIs/rArbvWkOtHSaIo8ZK0UFyKI
         kRo2pKZ4WJCrWEE1888qsTxm04k7nlqbIirc0SUq9XIfQZ4Be4zH5NkxEUwM8EOfxxPC
         uqZGBTh/6PDNgP0IcKphE63NvHjlXlP4cNm6MXUVjLU9LSXDluJQDjaUax+VC/sXqnJC
         RBtaVUSSlC5OCOKPPpeFuTFx1gsJsU+asnDit9Spy0H+iCMNGwaE9ca3v3Y9bBszJatz
         VsaQ==
X-Gm-Message-State: AOAM530Aj4Ite11D3x8c0qOFVAV6WJPJTlag8hG34a3HTcv32Q484T2+
        +3DeLqoaerQq/VgSvhAqbTjW7knmAGw1t1XX72U=
X-Google-Smtp-Source: ABdhPJywHXsqBndX3laZcwix8rl6zEFIaUWSsfG6YMGcM9LSe//w5BtrRO/NuMPavCMahVKPqbWUuUk4ilCBWssYdFI=
X-Received: by 2002:a2e:b5d7:: with SMTP id g23mr1384527ljn.70.1590908591076;
 Sun, 31 May 2020 00:03:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200529234309.484480-1-jhubbard@nvidia.com> <20200529234309.484480-2-jhubbard@nvidia.com>
In-Reply-To: <20200529234309.484480-2-jhubbard@nvidia.com>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Sun, 31 May 2020 12:41:19 +0530
Message-ID: <CAFqt6zaCSngh7-N_qZ6-S3Cj8CHF8DTSPv8anP_oJg5E6UWu9g@mail.gmail.com>
Subject: Re: [PATCH 1/2] docs: mm/gup: pin_user_pages.rst: add a "case 5"
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 30, 2020 at 5:13 AM John Hubbard <jhubbard@nvidia.com> wrote:
>
> There are four cases listed in pin_user_pages.rst. These are
> intended to help developers figure out whether to use
> get_user_pages*(), or pin_user_pages*(). However, the four cases
> do not cover all the situations. For example, drivers/vhost/vhost.c
> has a "pin, write to page, set page dirty, unpin" case.
>
> Add a fifth case, to help explain that there is a general pattern
> that requires pin_user_pages*() API calls.
>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jan Kara <jack@suse.cz>
> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  Documentation/core-api/pin_user_pages.rst | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/Documentation/core-api/pin_user_pages.rst b/Documentation/co=
re-api/pin_user_pages.rst
> index 4675b04e8829..b9f2688a2c67 100644
> --- a/Documentation/core-api/pin_user_pages.rst
> +++ b/Documentation/core-api/pin_user_pages.rst
> @@ -171,6 +171,26 @@ If only struct page data (as opposed to the actual m=
emory contents that a page
>  is tracking) is affected, then normal GUP calls are sufficient, and neit=
her flag
>  needs to be set.
>
> +CASE 5: Pinning in order to write to the data within the page
> +-------------------------------------------------------------
> +Even though neither DMA nor Direct IO is involved, just a simple case of=
 "pin,
> +access page's data, unpin" can cause a problem.

Will it be, *"pin, access page's data, set page dirty, unpin" * ?

Case 5 may be considered a
> +superset of Case 1, plus Case 2, plus anything that invokes that pattern=
. In
> +other words, if the code is neither Case 1 nor Case 2, it may still requ=
ire
> +FOLL_PIN, for patterns like this:
> +
> +Correct (uses FOLL_PIN calls):
> +    pin_user_pages()
> +    access the data within the pages
> +    set_page_dirty_lock()
> +    unpin_user_pages()
> +
> +INCORRECT (uses FOLL_GET calls):
> +    get_user_pages()
> +    access the data within the pages
> +    set_page_dirty_lock()
> +    put_page()
> +
>  page_maybe_dma_pinned(): the whole point of pinning
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>
> --
> 2.26.2
>
