Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29073816BB
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 10:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhEOIB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 04:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbhEOIBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 04:01:15 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4579EC06175F
        for <netdev@vger.kernel.org>; Sat, 15 May 2021 01:00:01 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e10so102852ilu.11
        for <netdev@vger.kernel.org>; Sat, 15 May 2021 01:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2v45kofbre+XFBH7iwES5kxDq/i78luyh7ZofUhHGwA=;
        b=hll4l8hSG67upKPFRnlDaHX3jfvqHoQcgWV6uVIujn93G/k0kBnC8IkjG7OFUfYuGY
         QdxJxrBbHSZYNWAkrSkdz70AnhKXtaYvkJGHIVcQ1kOFV4PiRVV21Jp4hiNxZ52fVHSc
         ygqmlF0XL49DDKn4+YOOkHO/0xFiNjtRGuYf6TTyEZ1bcAN6nG+wFxIb9o8kba4PHEt9
         3AFhj5DewqoiHgNygewARYSngf/nsxuTmr3LJ5oKAmYHzTVfXmExOvjRz1X9LWRQzKYB
         ynTu2g0xy001Qv9UNy0bX7qdd4DlNtFwElLXdy6s53o8Yfbl+ojC6DXSnolyPmLeQAXs
         kSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2v45kofbre+XFBH7iwES5kxDq/i78luyh7ZofUhHGwA=;
        b=eSl52TRgG6pOkuYVwwx8RJhYo8CFL9fV2UvoQUIsuzj7STSsKUyqdYc6wMmHES2o/R
         uAIig6ifraDl0JDurbuTbeKOacLyxyd1qRcoL+kwl1J5tRmfbIw6aMNh3VM/0EzvNgLk
         WaUB7pspP+CYUP2mYKCK+YcRDD29rPlEc81o0GNELRyOdFFtvUA0eZLh0E2rPU62fndJ
         cxZOoLA+fjjcawxUMfuEU6zhkxO3Kni6MOtSTu6rqC1Rq2f/FYycNHTQSon0iyqiYpRu
         2a4wgLs6kEv9uQBA9oiO1TNMWjrQfQqb5pzHhgsNbesHaNrSKPfBI6bvu23y5xlaBdbp
         1fzA==
X-Gm-Message-State: AOAM533aqBwBQbaCdKEyQeKKfOmCXCzAH5jfN0haQKp6FfxcoxVNUeN/
        c5QBsdGCX/dYDM5QVyyFX3ebAD7jPeshBd+EVP++886tBbw=
X-Google-Smtp-Source: ABdhPJyMm0jyDb4FDHUx74Ik02MqhJ5D5RWpSFwDdmJmp20nbziCqvG5b6XRS0trlfLOt0uSQI5eX/Rj0/Bex5+qSx0=
X-Received: by 2002:a92:da06:: with SMTP id z6mr45598310ilm.129.1621065600658;
 Sat, 15 May 2021 01:00:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210515064907.28235-1-heiko.thiery@gmail.com>
In-Reply-To: <20210515064907.28235-1-heiko.thiery@gmail.com>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Sat, 15 May 2021 09:59:49 +0200
Message-ID: <CAEyMn7a_ig6-FRjyY0uv1q28KNTjcf4AHG3NZaGch_Zeo3P49g@mail.gmail.com>
Subject: Re: [PATCH] Fix warning due to format mismatch for field width
 argument to fprintf()
To:     netdev@vger.kernel.org
Cc:     Ben Hutchings <bhutchings@solarflare.com>,
        Ben Hutchings <bwh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added Ben's other mail addresses.

Am Sa., 15. Mai 2021 um 08:49 Uhr schrieb Heiko Thiery <heiko.thiery@gmail.=
com>:
>
> bnxt.c:66:54: warning: format =E2=80=98%lx=E2=80=99 expects argument of t=
ype =E2=80=98long unsigned int=E2=80=99, but argument 3 has type =E2=80=98u=
nsigned int=E2=80=99 [-Wformat=3D]
>    66 |   fprintf(stdout, "Length is too short, expected 0x%lx\n",
>       |                                                    ~~^
>       |                                                      |
>       |                                                      long unsigne=
d int
>       |                                                    %x
>
> Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> ---
>  bnxt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/bnxt.c b/bnxt.c
> index b46db72..0c62d1e 100644
> --- a/bnxt.c
> +++ b/bnxt.c
> @@ -63,7 +63,7 @@ int bnxt_dump_regs(struct ethtool_drvinfo *info __maybe=
_unused, struct ethtool_r
>                 return 0;
>
>         if (regs->len < (BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN)) {
> -               fprintf(stdout, "Length is too short, expected 0x%lx\n",
> +               fprintf(stdout, "Length is too short, expected 0x%x\n",
>                         BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN);
>                 return -1;
>         }
> --
> 2.20.1
>
