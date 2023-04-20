Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65F66E9416
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbjDTMSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbjDTMSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:18:30 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43505251;
        Thu, 20 Apr 2023 05:18:28 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1a68d61579bso8429745ad.1;
        Thu, 20 Apr 2023 05:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681993108; x=1684585108;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q7R2ZysSN9yYEd+Sz6xYkgWvSwxaeYaLBilVSEM6AL0=;
        b=WIxBVRrflKKiAXEfFDt0xSaKhy3scMtUZcYx7Bn7MD5lf0SdFNMbdaknE4WocyzL2I
         Lya7VtRUAWNQZ+/xMWkFt2CN91GXD1xxIDTH+2i0VzQyWbf0i9yp4Iq1EKq4UIJHlQO2
         9wnVNmLQ+fPyEphOO80XIAqXKuVF1sxAA2hUAtZcOnmGujk/MdSHUn3NQncq3wfNhwns
         KC0wS3XGMbQaMwxloi/8RdlxSJZkoA7GZvbZk9SvB7xnQwXifyLWi6AKZG1gdjv2zpW9
         bJQoYr9v4/9AxUDYlrYbQOOklhWxAEEzPByfr0oo4ZsZJkq2FJ/V6nV2MGP3p0j3vLVw
         Ah8A==
X-Gm-Message-State: AAQBX9eAVEl60eBzi4tDpIgItlc6xy5/OCxxO8aq2u7hr2icqkq1+vUG
        ID03l7ewDArZG4QWK5UoMhTOnmBM3cYC9+BOVak=
X-Google-Smtp-Source: AKy350YQbjcba2ZO9u1lSqIHWOfUQSZN3jG0QwoI8BFZLBK35vtR11RKrqQhryc+fx09J9hw3UxGuz5EunmwdqIkucM=
X-Received: by 2002:a17:903:2444:b0:19e:6cb9:4c8f with SMTP id
 l4-20020a170903244400b0019e6cb94c8fmr1812129pls.41.1681993108197; Thu, 20 Apr
 2023 05:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230420024403.13830-1-peter_hong@fintek.com.tw> <CAMZ6RqKWrtBMFSD=BzGuCbvj=+3X-A-oW9haJ7=4kyL2AbEuHQ@mail.gmail.com>
In-Reply-To: <CAMZ6RqKWrtBMFSD=BzGuCbvj=+3X-A-oW9haJ7=4kyL2AbEuHQ@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 20 Apr 2023 21:18:17 +0900
Message-ID: <CAMZ6RqKQv1hjPdWNK4NU4TcVjfE-TUZ+yAROXUG0=H5RhDx6iQ@mail.gmail.com>
Subject: Re: [PATCH V5] can: usb: f81604: add Fintek F81604 support
To:     "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>
Cc:     wg@grandegger.com, mkl@pengutronix.de,
        michal.swiatkowski@linux.intel.com, Steen.Hegelund@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, frank.jungclaus@esd.eu,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, hpeter+linux_kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 20 Apr. 2023 at 21:02, Vincent MAILHOL
<mailhol.vincent@wanadoo.fr> wrote:
> Hi Peter,
>
> Here are my comments. Now, it is mostly nitpicks. I guess that this is
> the final round.
>
> On Thu. 20 avr. 2023 at 11:44, Ji-Ze Hong (Peter Hong)
> <peter_hong@fintek.com.tw> wrote:
> >
> > This patch adds support for Fintek USB to 2CAN controller.
> >
> > Signed-off-by: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
> > ---
(...)
> > diff --git a/drivers/net/can/usb/f81604.c b/drivers/net/can/usb/f81604.c
> > new file mode 100644
> > index 000000000000..ea0ff08ca186
> > --- /dev/null
> > +++ b/drivers/net/can/usb/f81604.c
> > @@ -0,0 +1,1205 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Fintek F81604 USB-to-2CAN controller driver.
> > + *
> > + * Copyright (C) 2023 Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
> > + */
> > +#include <linux/bitfield.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/units.h>
> > +#include <linux/usb.h>
> > +
> > +#include <linux/can.h>
> > +#include <linux/can/dev.h>
> > +#include <linux/can/error.h>
> > +#include <linux/can/platform/sja1000.h>
> > +
> > +#include <asm-generic/unaligned.h>
> > +
> > +/* vendor and product id */
> > +#define F81604_VENDOR_ID 0x2c42
> > +#define F81604_PRODUCT_ID 0x1709
> > +#define F81604_CAN_CLOCK (12 * MEGA)
> > +#define F81604_MAX_DEV 2
> > +#define F81604_SET_DEVICE_RETRY 10
> > +
> > +#define F81604_USB_TIMEOUT 2000
> > +#define F81604_SET_GET_REGISTER 0xA0
> > +#define F81604_PORT_OFFSET 0x1000
> > +
> > +#define F81604_DATA_SIZE 14
> > +#define F81604_MAX_RX_URBS 4
> > +
> > +#define F81604_CMD_DATA 0x00
> > +
> > +#define F81604_DLC_LEN_MASK 0x0f

For consistency with the other definitions also use GENMASK here.
