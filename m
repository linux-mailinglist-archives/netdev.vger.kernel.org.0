Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 469AA4C0CC
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 20:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfFSSb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 14:31:59 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46914 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfFSSb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 14:31:59 -0400
Received: by mail-io1-f65.google.com with SMTP id i10so667369iol.13;
        Wed, 19 Jun 2019 11:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=WMAEpKDX0ogkoHoItqe3dZiuD+RgqX5fNQGojqqQ+m0=;
        b=dX61wv1rD/FtO6rpV6JFPhv3rQvNOnQsUMpmsNt6UjgmAF83pjGN7O/YEL+kDVPNJ6
         ipjCbinx+ckvI3NxIxobenamca2R//qNGj8XC4xeMxusEgCJENOJQCi1BkK5VsmypDcz
         trPdnl4Su8L/5PLX1a/669gpbCWhpxnCNpSlNFdPjznkmM3ZQntsEMbHcCfiwJyv8rlQ
         4iTrh9HGij2mvbxXWkliK4gS/xrAEut4E7SROSFtUmO8NGrcbUvCjB+YagT8ttPZfsYi
         HG2xhNOefM0a7fW4yqs4tS2DVstDBvx/pzbcoPH3Gb2AoC0a+o/67hwNtooWi2bpSk1A
         zJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=WMAEpKDX0ogkoHoItqe3dZiuD+RgqX5fNQGojqqQ+m0=;
        b=IRprO76qCHQdqaCEREbz8uOj1U2O418ACFvoEewHOXTbuarhr2dq8GvaHkFmnL48gY
         joSt7qbFpzK3l4BTREWzOINIcgZnU3uNkzWZE1U1e753Z1on9OHaesgoIGYsH8Jh3SPf
         jesTIvWraQlU/JD9NMhYibrAppLUarU59JGq7h1XCnjWL4nAaZ+nEYyqmiWDGz9ZaHo/
         CoVODMiPJXN7q5uHsj85Q/p+yBOtlS3MXmmfjI0jyLsesnd9GJsrPRmgLmneljNbZJMP
         hM6qNcu4ucf2tZxjW49C1u7DRX/iV0YHqh1t2T5p2Jftmg6EcLqO0CxHP3DXNXUqiBPQ
         dNvg==
X-Gm-Message-State: APjAAAUsNDTFEGuEJSHQ2rDBIKqCdgdhLcl7YRJeVQERbs5CdOfTl6ts
        Nv4JVEroENLeQEu8MLSVuVUYlWV3vNWdFHuk5Zp5GDx9bWU=
X-Google-Smtp-Source: APXvYqw0wnrrKQ5ayH2r9SOjtBVnoF/FXrtE+70SanrXw9QFMgs4nmqRGQHO+fNIGrZukcu8q5Fv3pAa6l/lennmW30=
X-Received: by 2002:a6b:dc17:: with SMTP id s23mr2768340ioc.56.1560969118497;
 Wed, 19 Jun 2019 11:31:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190619174556.21194-1-puranjay12@gmail.com> <e49daf89-1bf0-77e8-c71f-ec0802f25f6c@linuxfoundation.org>
 <20190619182122.GA4827@arch>
In-Reply-To: <20190619182122.GA4827@arch>
From:   Puranjay Mohan <puranjay12@gmail.com>
Date:   Thu, 20 Jun 2019 00:01:46 +0530
Message-ID: <CANk7y0h8gC6JR=FWXQC=vYWrPxFT2KFwi6zQaThjhzAMwG9gGw@mail.gmail.com>
Subject: Fwd: [PATCH] net: fddi: skfp: Include generic PCI definitions from pci_regs.h
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 12:04:19PM -0600, Shuah Khan wrote:
> On 6/19/19 11:45 AM, Puranjay Mohan wrote:
> > Include the generic PCI definitions from include/uapi/linux/pci_regs.h
> > change PCI_REV_ID to PCI_REVISION_ID to make it compatible with the
> > generic define.
> > This driver uses only one generic PCI define.
> >
> > Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
> > ---
> >   drivers/net/fddi/skfp/drvfbi.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/fddi/skfp/drvfbi.c b/drivers/net/fddi/skfp/drvfbi.c
> > index bdd5700e71fa..38f6d943385d 100644
> > --- a/drivers/net/fddi/skfp/drvfbi.c
> > +++ b/drivers/net/fddi/skfp/drvfbi.c
> > @@ -20,6 +20,7 @@
> >   #include "h/supern_2.h"
> >   #include "h/skfbiinc.h"
> >   #include <linux/bitrev.h>
> > +#include <uapi/linux/pci_regs.h>
> >   #ifndef   lint
> >   static const char ID_sccs[] = "@(#)drvfbi.c       1.63 99/02/11 (C) SK " ;
> > @@ -127,7 +128,7 @@ static void card_start(struct s_smc *smc)
> >      *       at very first before any other initialization functions is
> >      *       executed.
> >      */
> > -   rev_id = inp(PCI_C(PCI_REV_ID)) ;
> > +   rev_id = inp(PCI_C(PCI_REVISION_ID)) ;
> >     if ((rev_id & 0xf0) == SK_ML_ID_1 || (rev_id & 0xf0) == SK_ML_ID_2) {
> >             smc->hw.hw_is_64bit = TRUE ;
> >     } else {
> >
>
> Why not delete the PCI_REV_ID define in:
>
> drivers/net/fddi/skfp/h/skfbi.h
>
I have removed all generic  PCI definitions from skfbi.h in the next
patch which I have sent, I wanted to keep it organised by sending two
patches

> It looks like this header has duplicate PCI config space header defines,
> not just this one. Some of them are slightly different names:
>
> e.g:
>
> #define PCI_CACHE_LSZ   0x0c    /*  8 bit       Cache Line Size */
>
> Looks like it defines the standard PCI config space instead of
> including and using the standard defines from uapi/linux/pci_regs.h
>
It defines many duplicate definitions in skfbi.h, but only uses one of
them, hence they are removed in the next patch as told by bjorn.
It uses only one generic PCI define in driver code, i.e. PCI_REV_ID, it
has been replaced by PCI_REVISION_ID to make it work with the define
included with uapi/linux/pci_regs.h
> Something to look into.
>
> thanks,
> -- Shuah
>
>
>
>
>


-- 
Thanks and Regards

Yours Truly,

Puranjay Mohan
