Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAF926FDB0
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgIRM7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgIRM7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:59:14 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA46C06174A;
        Fri, 18 Sep 2020 05:59:13 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id m25so1406419oou.0;
        Fri, 18 Sep 2020 05:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w8HQ3J+t/0CpN0ZzyptZv1efAlGCKuHKmS2AU0wzvzU=;
        b=JWcuknOXar6OLMnxJxohK1oyz8imbmM5I0OQLONIsZbjbi+4SqHN/ny7mr+uvySCZ9
         Qtipg6LAwgPjfmANgnX16jiEH/4eNeXUzQP1iv/R+Uyk7BxG9YBaGX7XiQ00ou5M1uwB
         gH3rVjw6YVlJov5B8UVKiGSeUiS/APp6kvSWFjO16Jcp9jBd1GC9RxSuG0ShOBQcgm2z
         bt0FBSVasUEnxt7Lotl9AluspQztroN22cb/ZVyGGzcr3ZisFJoJEbN5CkF5fc1fipSx
         ER1cAt/TKR5ZEim+Wd88E/4+jIC9OOlkV8wsweo/O3DAFDd7m33Yr7YL2/Ho7fnib6V0
         hiZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w8HQ3J+t/0CpN0ZzyptZv1efAlGCKuHKmS2AU0wzvzU=;
        b=XRrp5cTUiHAeQqiT6D2UWaFtg8zejxjqgf8bSe2pcyPE343t13aKC2A4CqEBdKCvzH
         fMn/5Bx5SMgKiKAZTiglEeYdijbjxcIknZDjJqvMEzp01BTpZguSbAWohJQmQJtm3fnI
         s388EZ0js2PIQa4AUtbT60jQ+2CyyKXUGKcl3+uNBuIs6qQQuDK9wwtuIv1CBIgOSF5b
         9n+X+ol8DdvuiYL0HcBkmrgb24sgAudO7Y3j5wsgSHLwTOvNwAvplYKmMbwgWISNyhn7
         1vsQp+xPsCG8apQ8E9kfcrjnqzPrCaLfbTiAPdO3dQpXNfLpV2mL2wb6FjSOdjnSMtBb
         ph/w==
X-Gm-Message-State: AOAM5306qYAyCdE2Q75WCdwWR8m//6oxrg2wgsld0+LD3pR36dTRD/t8
        dCIAJ/i4k8sKJB4sL8HQUeogRk5clD1LtM01hEo=
X-Google-Smtp-Source: ABdhPJzq0e2lsb1ql/BlG1VxAZsanmPDPsQfHSgePevEn5og9q1JV0yFvknIbQD6oz4Pun6nL3YSa/ycmmre8w3u6f0=
X-Received: by 2002:a4a:5a06:: with SMTP id v6mr23967835ooa.22.1600433953158;
 Fri, 18 Sep 2020 05:59:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200909154120.363209-1-liq3ea@163.com>
In-Reply-To: <20200909154120.363209-1-liq3ea@163.com>
From:   Li Qiang <liq3ea@gmail.com>
Date:   Fri, 18 Sep 2020 20:58:37 +0800
Message-ID: <CAKXe6SKAFqOQtxbLwA4WA8aEBB-8EtEPvrpsNYU8rLUt9t6zSQ@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: fix memory leak in error path
To:     Li Qiang <liq3ea@163.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Any status update?

Thanks,
Li Qiang

Li Qiang <liq3ea@163.com> =E4=BA=8E2020=E5=B9=B49=E6=9C=889=E6=97=A5=E5=91=
=A8=E4=B8=89 =E4=B8=8B=E5=8D=8811:42=E5=86=99=E9=81=93=EF=BC=9A
>
> Free the 'page_list' when the 'npages' is zero.
>
> Signed-off-by: Li Qiang <liq3ea@163.com>
> ---
>  drivers/vhost/vdpa.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 3fab94f88894..6a9fcaf1831d 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -609,8 +609,10 @@ static int vhost_vdpa_process_iotlb_update(struct vh=
ost_vdpa *v,
>                 gup_flags |=3D FOLL_WRITE;
>
>         npages =3D PAGE_ALIGN(msg->size + (iova & ~PAGE_MASK)) >> PAGE_SH=
IFT;
> -       if (!npages)
> -               return -EINVAL;
> +       if (!npages) {
> +               ret =3D -EINVAL;
> +               goto free_page;
> +       }
>
>         mmap_read_lock(dev->mm);
>
> @@ -666,6 +668,8 @@ static int vhost_vdpa_process_iotlb_update(struct vho=
st_vdpa *v,
>                 atomic64_sub(npages, &dev->mm->pinned_vm);
>         }
>         mmap_read_unlock(dev->mm);
> +
> +free_page:
>         free_page((unsigned long)page_list);
>         return ret;
>  }
> --
> 2.25.1
>
