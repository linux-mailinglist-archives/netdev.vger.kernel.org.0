Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750CE3890D2
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347462AbhESObH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346545AbhESObG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:31:06 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66630C06175F
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 07:29:46 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w12so7875993edx.1
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 07:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tcFFwK4ubLQGtrrFPo8oxWhQ57twWHPmskXcZ4gjHVg=;
        b=BtHDAoL/+vmnzwn32dO9VJomqAbxA3WrOWdvMI/O2GfiBg4CuHAKVMC6I0vwHgsuZ4
         CylF+U8iERN8XVcl3Ql7hVq5hT1OB4jIae3YAOAQcFb9n3q+J9/704oX2lYVRfWy4y72
         6fFwGXHUuXsHqinRvlK31XoT17jOGw09GBuRtWNk1d3gaLa3UTu9TssB/jyRRXhqRzcq
         Y/KiN3VxvWrCVUgbgfgR/XgA58pZeRt6/xzgKlYIbwiHLXT0zc72GmA3Hs9B6uqLf6mL
         9XqsvureCREqDo8pcdj2Wt4maaSPk/3m/eFflPUKdIKdNymktGxgYs/GF/fkTugIL6DA
         cjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tcFFwK4ubLQGtrrFPo8oxWhQ57twWHPmskXcZ4gjHVg=;
        b=g57KIMKgKKWTdOIp6fru1p667o1sWrIoI3gK1mIJGt8Zn9MjBGAnc85vKmLmzqVZrk
         T/i/b+gGqVt/SVxorvPmOGd5vW/9GZ++bgFQtdhJorQGu3T994NFSrhXzGZ+GoBtofaP
         IhTXnyKLiWQG9p2TFLguC6H5jIUMClhs+qV+jUNqbgod5nGdV/pY/U/dWB4n3XkL3wiV
         dGd67VvEUDw9VKt3TdinEjNFZ95cYF5A4Y+dzoTCbQNXZIYcIAA2KO6nImCa1aLFH1O3
         u8FoiNJ9D+fc75apdAeqIbIGG2jTP0PTO5yTXE13vYHzMmsUWnn0XiMvmOIkdO0UFCTA
         N83Q==
X-Gm-Message-State: AOAM531XW5j8Ux2HN4s7etIFgDV9zsxRBlN0qGm7ES/5w22L4fkMh4+O
        /sjhUCbvFiESp9orc5c3HQeVu9IBn2y0fI+uko8=
X-Google-Smtp-Source: ABdhPJwqtoQx+cnuGcYqEPWSAjCfXjw+cIyi4i2isyfaocEzPn/TbP92EHZy+uW7JQnKdl20uXZgyXGNZab7i0NbJSI=
X-Received: by 2002:aa7:da03:: with SMTP id r3mr14857780eds.121.1621434584929;
 Wed, 19 May 2021 07:29:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210519111340.20613-1-smalin@marvell.com> <20210519111340.20613-18-smalin@marvell.com>
 <YKUFLVHrUdzEsUeq@unreal>
In-Reply-To: <YKUFLVHrUdzEsUeq@unreal>
From:   Shai Malin <malin1024@gmail.com>
Date:   Wed, 19 May 2021 17:29:32 +0300
Message-ID: <CAKKgK4z+Ha9cv0zHtjrBiTb=K9MvWZB-kzg5CP9__pCJYmyNVA@mail.gmail.com>
Subject: Re: [RFC PATCH v5 17/27] qedn: Add qedn probe
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Dean Balandin <dbalandin@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 May 2021 at 15:31, Leon Romanovsky wrote:
> On Wed, May 19, 2021 at 02:13:30PM +0300, Shai Malin wrote:
> > This patch introduces the functionality of loading and unloading
> > physical function.
> > qedn_probe() loads the offload device PF(physical function), and
> > initialize the HW and the FW with the PF parameters using the
> > HW ops->qed_nvmetcp_ops, which are similar to other "qed_*_ops" which
> > are used by the qede, qedr, qedf and qedi device drivers.
> > qedn_remove() unloads the offload device PF, re-initialize the HW and
> > the FW with the PF parameters.
> >
> > The struct qedn_ctx is per PF container for PF-specific attributes and
> > resources.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > ---
> >  drivers/nvme/hw/Kconfig          |   1 +
> >  drivers/nvme/hw/qedn/qedn.h      |  35 +++++++
> >  drivers/nvme/hw/qedn/qedn_main.c | 159 ++++++++++++++++++++++++++++++-
> >  3 files changed, 190 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/nvme/hw/Kconfig b/drivers/nvme/hw/Kconfig
> > index 374f1f9dbd3d..91b1bd6f07d8 100644
> > --- a/drivers/nvme/hw/Kconfig
> > +++ b/drivers/nvme/hw/Kconfig
> > @@ -2,6 +2,7 @@
> >  config NVME_QEDN
> >       tristate "Marvell NVM Express over Fabrics TCP offload"
> >       depends on NVME_TCP_OFFLOAD
> > +     select QED_NVMETCP
> >       help
> >         This enables the Marvell NVMe TCP offload support (qedn).
> >
> > diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
> > index bcd0748a10fd..f13073afbced 100644
> > --- a/drivers/nvme/hw/qedn/qedn.h
> > +++ b/drivers/nvme/hw/qedn/qedn.h
> > @@ -6,14 +6,49 @@
> >  #ifndef _QEDN_H_
> >  #define _QEDN_H_
> >
> > +#include <linux/qed/qed_if.h>
> > +#include <linux/qed/qed_nvmetcp_if.h>
> > +
> >  /* Driver includes */
> >  #include "../../host/tcp-offload.h"
> >
> > +#define QEDN_MAJOR_VERSION           8
> > +#define QEDN_MINOR_VERSION           62
> > +#define QEDN_REVISION_VERSION                10
> > +#define QEDN_ENGINEERING_VERSION     0
> > +#define DRV_MODULE_VERSION __stringify(QEDE_MAJOR_VERSION) "."       \
> > +             __stringify(QEDE_MINOR_VERSION) "."             \
> > +             __stringify(QEDE_REVISION_VERSION) "."          \
> > +             __stringify(QEDE_ENGINEERING_VERSION)
> > +
>
> This driver module version is not used in this series and more
> important the module version have no meaning in upstream at all
> and the community strongly against addition of new such code.

Will be fixed.

>
> >  #define QEDN_MODULE_NAME "qedn"
>
> And the general note, it will be great if you convert your probe/remove
> flows to use auxiliary bus like other drivers that cross subsystems.

qedn is simply fitting in with the existing design of qed/qede/qedr/qedf/qedi.
Changing the entire multi-protocol design to auxiliary bus is being studied.
