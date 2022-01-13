Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B9448D5BF
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 11:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiAMKa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 05:30:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229987AbiAMKaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 05:30:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642069824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PJsTJKLt2JcDbcxy82NVeknyGduWUGDL/KWEXFjrv3g=;
        b=KyBxrCGooQzcS1vaZ/XUckLFZ0256erWzTwLLTnT/9en35LGwT3gsbTi1EyAKYQgzsnQiq
        1mG6VARyLqPL4P4D/IL5w8Eganc7sqBpm9INMMUMQEgBV3SSWKHLn8qqf+8IUrwQWWrI/V
        hq6Y2iLsWjpUoU1sPXl1d386Z7VtSTA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-nGf_kGxzMEOnVVyAhzPqwQ-1; Thu, 13 Jan 2022 05:30:22 -0500
X-MC-Unique: nGf_kGxzMEOnVVyAhzPqwQ-1
Received: by mail-ed1-f69.google.com with SMTP id g2-20020a056402424200b003f8ee03207eso4974690edb.7
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 02:30:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PJsTJKLt2JcDbcxy82NVeknyGduWUGDL/KWEXFjrv3g=;
        b=ZlOTOGP/SkktqGxsAEDCE2JWkI86AKnacVSn+TEG4f5e8Hl0tmC/3WBMwFC0ylmzl2
         N/pz36RMj6SEa8h6wTAW/uKPB+GQAHE5WRh9KOkKdW7akN8CMampXR67tM4o8vOzF79z
         JBsJwiCJ76wpTH5Oiaibw5Su2DfXs54FXbUWigaVetPdPD2lRyTth0tgvXewqX/hjivU
         n6Q8NA7STz1ALGXqtYNjgljixPldd22IxvKiIw5it4LAEsTYwbCD4mX1hbHHf3u2eHVW
         u4WIFIwm37D2cOwHn4AjJdWaasxDkNDG2q6aUKSB4t5x0Bu68CLlJRiCWr7D1tVe9RL0
         q2LA==
X-Gm-Message-State: AOAM530Hr0HDqGXt6TkWnM/Dp34+9NVF2WTzXWX8NP9DpkSN9+a9Zubr
        eLtrh6ea8MFVzJzEHocj70lZnrO9cRUGYxz+edoWaQ9fFW7pm6FMDyZ1l4Rv9Ar4JLvrx1GiaAH
        9jDyhx0WfVzCPXFrA
X-Received: by 2002:a50:9549:: with SMTP id v9mr3582852eda.335.1642069821581;
        Thu, 13 Jan 2022 02:30:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVOadQi+bD/4n1POnAU2zvJ/TyiQIQrglVqY5e8WcXBeb3l9bZuhdqzuDSrfGlyf5+JilmLw==
X-Received: by 2002:a50:9549:: with SMTP id v9mr3582829eda.335.1642069821403;
        Thu, 13 Jan 2022 02:30:21 -0800 (PST)
Received: from redhat.com ([2.55.6.51])
        by smtp.gmail.com with ESMTPSA id qf18sm730326ejc.124.2022.01.13.02.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 02:30:20 -0800 (PST)
Date:   Thu, 13 Jan 2022 05:30:18 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] Supoort shared irq for virtqueues
Message-ID: <20220113053000-mutt-send-email-mst@kernel.org>
References: <20220110051851.84807-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110051851.84807-1-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 01:18:44PM +0800, Zhu Lingshan wrote:
> On some platforms, it has been observed that a device may fail to
> allocate enough MSI-X vectors, under such circumstances, the vqs have
> to share a irq/vector.
> 
> This series extends irq requester/handlers abilities to deal with:
> (granted nvectors, and max_intr = total vq number + 1(config interrupt) )
> 
> 1)nvectors = max_intr: each vq has its own vector/irq,
> config interrupt is enabled, normal case
> 2)max_intr > nvectors >= 2: vqs share one irq/vector, config interrupt is
> enabled
> 3)nvectors = 1, vqs share one irq/vector, config interrupt is disabled.
> Otherwise it fails.
> 
> This series also made necessary changes to irq cleaners and related
> helpers.


BTW you should copy the virtio mailing list, too.
Not just netdev.

> Pleaase help reivew.
> 
> Thanks!
> Zhu Lingshan
> 
> Zhu Lingshan (7):
>   vDPA/ifcvf: implement IO read/write helpers in the header file
>   vDPA/ifcvf: introduce new helpers to set config vector and vq vectors
>   vDPA/ifcvf: implement device MSIX vector allocation helper
>   vDPA/ifcvf: implement shared irq handlers for vqs
>   vDPA/ifcvf: irq request helpers for both shared and per_vq irq
>   vDPA/ifcvf: implement config interrupt request helper
>   vDPA/ifcvf: improve irq requester, to handle per_vq/shared/config irq
> 
>  drivers/vdpa/ifcvf/ifcvf_base.c |  65 ++++--------
>  drivers/vdpa/ifcvf/ifcvf_base.h |  45 +++++++-
>  drivers/vdpa/ifcvf/ifcvf_main.c | 179 +++++++++++++++++++++++++++-----
>  3 files changed, 215 insertions(+), 74 deletions(-)
> 
> -- 
> 2.27.0

