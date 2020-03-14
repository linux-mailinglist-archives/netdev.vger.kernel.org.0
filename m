Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A722C18596C
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 03:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgCOCxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 22:53:31 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40507 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgCOCxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 22:53:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id z12so5123466wmf.5
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 19:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kja37SPXwzEksJ36iiMyWTLU78yyaDXwRzn7y821ZCw=;
        b=u/imu7U2Xk0C1TqL486BVOivMnxddstgyKCf8R7asaQZHyqEnsi2qPOAy1U0fVV0z2
         VF2z7vBBY0jFd5m+339jgtq2xNiYQRGfUOTDVBrEDEAPRG1rdSXqwcU1mwlJ/uwYlkuA
         NphlQBJOBmlhIhXZeDUPwXnce0JsNaoA8zNCoVuXaDh3nKOPL4MaXqW3YFCe0ZBa1DAo
         bOgeblPTpi5Yzz90RmlenW1v5RzsBTyVbBsvwx/QPrJHCfPwK+huzfbuYqXGB4ZrvGd4
         5KGFQVr+iRBRc0NmPbhE4zGL+WGkz8ZvrINVRTl7Z2gmNl+8v8e0SKs2F7Wb7bL28L9U
         gJoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kja37SPXwzEksJ36iiMyWTLU78yyaDXwRzn7y821ZCw=;
        b=AnNbYdU3LSpZUqhsfeut4ZflkRI/l0/AwQtaFQxRPzvcD9HirCK0puZMvOP30kGJuC
         5YF7BY0vvSMO9vGGlUO/o5VPsY+KFJO1By/PCKPdXBj0hOjcG6v0Tca/G5S2ZsoXdPVI
         fav3HhgGrE/QJy8ZQhFAC4j3uN9m0lOrjMTHm5wtS0TjvDShsYKSS3hOfuK1mTA/ZEIT
         RxgnFBr1Ue/m9jGtd69FvRBogPStoSYf6028Gv3SnRlYT6+6xVdoUyeuaXgv0toXHTOX
         gVD1pEu5HD5uoX5vHna5iShh3WPmCRCuD6tgejLbpQExi03h6snrFA/DGrVp2nXiv4RW
         SArw==
X-Gm-Message-State: ANhLgQ1wTDawG/iJo4ebH4e1FlZcYIzx+bGdwl7UVsVkWAHEulEYm+eI
        +tWQSE1D0lOZS9cBpnJEcOd51KxlI8GmStEZgGHoQla1/yI=
X-Google-Smtp-Source: ADFU+vtdJxlp8KQQ8/8PB6FKPDdoq8yFm99F0i4bxpgD7fNSzg2/8V1fnmaGOCxFn0I64DowMIO9YK6kJeqIcU2p+qE=
X-Received: by 2002:a1c:2d88:: with SMTP id t130mr18189307wmt.68.1584200440415;
 Sat, 14 Mar 2020 08:40:40 -0700 (PDT)
MIME-Version: 1.0
References: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
 <1584092566-4793-4-git-send-email-sunil.kovvuri@gmail.com> <20200313181139.GC67638@unreal>
In-Reply-To: <20200313181139.GC67638@unreal>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Sat, 14 Mar 2020 21:10:28 +0530
Message-ID: <CA+sq2CeP3rfhBmxcs9Z6n7wVBmqP6upb8XFZF7nZ3R=QUtTF_g@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/7] octeontx2-vf: Virtual function driver support
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 11:41 PM Leon Romanovsky <leon@kernel.org> wrote:
 > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> > new file mode 100644
> > index 0000000..cf366dc
> > --- /dev/null
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> > @@ -0,0 +1,659 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Marvell OcteonTx2 RVU Virtual Function ethernet driver
> > + *
> > + * Copyright (C) 2020 Marvell International Ltd.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
>
> Please don't add license text, the SPDX line is enough.
>

Can you please point me to where this is written.
It would be great if these are made rules and written somewhere so
that everyone can go through and follow.
I see that there are so many patches being submitted with copyright text.
So this is very confusing.

> > +
> > +static int otx2vf_process_mbox_msg_up(struct otx2_nic *vf,
> > +                                   struct mbox_msghdr *req)
> > +{
> > +     /* Check if valid, if not reply with a invalid msg */
> > +     if (req->sig != OTX2_MBOX_REQ_SIG) {
> > +             otx2_reply_invalid_msg(&vf->mbox.mbox_up, 0, 0, req->id);
> > +             return -ENODEV;
> > +     }
> > +
> > +     switch (req->id) {
> > +#define M(_name, _id, _fn_name, _req_type, _rsp_type)                        \
> > +     case _id: {                                                     \
> > +             struct _rsp_type *rsp;                                  \
> > +             int err;                                                \
> > +                                                                     \
> > +             rsp = (struct _rsp_type *)otx2_mbox_alloc_msg(          \
> > +                     &vf->mbox.mbox_up, 0,                           \
> > +                     sizeof(struct _rsp_type));                      \
> > +             if (!rsp)                                               \
> > +                     return -ENOMEM;                                 \
> > +                                                                     \
> > +             rsp->hdr.id = _id;                                      \
> > +             rsp->hdr.sig = OTX2_MBOX_RSP_SIG;                       \
> > +             rsp->hdr.pcifunc = 0;                                   \
> > +             rsp->hdr.rc = 0;                                        \
> > +                                                                     \
> > +             err = otx2_mbox_up_handler_ ## _fn_name(                \
> > +                     vf, (struct _req_type *)req, rsp);              \
> > +             return err;                                             \
> > +     }
> > +MBOX_UP_CGX_MESSAGES
> > +#undef M
>
> "return ..." inside macro which is called by another macro is highly
> discouraged by the Linux kernel coding style.
>

There are many mailbox messages to handle and adding each one of them
to switch case would be a
lot of duplicate code. Hence we choose to with these macros.

Thanks,
Sunil.
