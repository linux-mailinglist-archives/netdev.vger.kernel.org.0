Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FFC64078F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 14:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiLBNPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 08:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiLBNPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 08:15:37 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D01C2D34;
        Fri,  2 Dec 2022 05:15:36 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so5157836pjb.0;
        Fri, 02 Dec 2022 05:15:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CXax7MzLMmcpUbR7j4j5Z+A0zH0BPeP/1NeIQzWumhA=;
        b=8MVgukWp4/TCO8U8xhF3HBlRuihurmBl5EToj1A0UGgweTuDnjoxXmT+M2sIOwfcPH
         0vno5/8eCo5vWKUUD+7uuo6bRQtXOq6M6qjQyXeINf3xTCbPBLU3EKTDVycAMifWQ/XM
         Zkd++EPIfNFF89kcB+BYNzRC4SV+ww8iDfnGOhgwKifu+lQ9F25SGEtXavCJSD8/vdJh
         tNABwC9jLgePVYozT1OGRHeoNb3NjCusPogPVQiwZjct+X/acYLsO3B6YR+F1FxTOsYl
         WytuycO3//mF44NxzQGtihEQ5/V5/dRZlcc731MLnVTOlrlmZ2Zt1PNz7d1gIssvPhg3
         /9Cw==
X-Gm-Message-State: ANoB5pniOyt/e3F6X5wntgjntgmFIJJm1bbiqI6WC1yAr18aemlykh5y
        hnRvCaW0kgyd8U7ntsrJBHYUaj7ylpxnVyOkmo0MBvmO
X-Google-Smtp-Source: AA0mqf7rou+HDTGrB7duYcNJqBj1ifeMeXSb9YluHr/oNmFkiW6kdUvNrTQ1CO5rfw2zo45qNcQto+7cIbG4RE18Brw=
X-Received: by 2002:a17:90a:a60c:b0:213:2e97:5ea4 with SMTP id
 c12-20020a17090aa60c00b002132e975ea4mr81737675pjq.92.1669986934229; Fri, 02
 Dec 2022 05:15:34 -0800 (PST)
MIME-Version: 1.0
References: <20221130174658.29282-1-mailhol.vincent@wanadoo.fr>
 <20221130174658.29282-8-mailhol.vincent@wanadoo.fr> <20221202122702.rlxvatn2m6dx7zyp@pengutronix.de>
In-Reply-To: <20221202122702.rlxvatn2m6dx7zyp@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 2 Dec 2022 22:15:23 +0900
Message-ID: <CAMZ6Rq+f9wMG7H0k-c4T5Jo+64gk8+0b=tP8Vz26-cx0odG34Q@mail.gmail.com>
Subject: Re: [PATCH v5 7/7] Documentation: devlink: add devlink documentation
 for the etas_es58x driver
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 2 Dec. 2022 at 21:49, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 01.12.2022 02:46:58, Vincent Mailhol wrote:
> > List all the version information reported by the etas_es58x driver
> > through devlink. Also, update MAINTAINERS with the newly created file.
> >
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > ---
> >  .../networking/devlink/etas_es58x.rst         | 36 +++++++++++++++++++
> >  MAINTAINERS                                   |  1 +
> >  2 files changed, 37 insertions(+)
> >  create mode 100644 Documentation/networking/devlink/etas_es58x.rst
> >
> > diff --git a/Documentation/networking/devlink/etas_es58x.rst b/Documentation/networking/devlink/etas_es58x.rst
> > new file mode 100644
> > index 000000000000..9893e57b625a
> > --- /dev/null
> > +++ b/Documentation/networking/devlink/etas_es58x.rst
> > @@ -0,0 +1,36 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +==========================
> > +etas_es58x devlink support
> > +==========================
> > +
> > +This document describes the devlink features implemented by the
> > +``etas_es58x`` device driver.
> > +
> > +Info versions
> > +=============
> > +
> > +The ``etas_es58x`` driver reports the following versions
> > +
> > +.. list-table:: devlink info versions implemented
> > +   :widths: 5 5 90
> > +
> > +   * - Name
> > +     - Type
> > +     - Description
> > +   * - ``fw``
> > +     - running
> > +     - Version of the firmware running on the device. Also available
> > +       through ``ethtool -i`` as the first member of the
> > +       ``firmware-version``.
> > +   * - ``bl``
>             ^^
>             fw.bootloader?
>
> Fixed that up while applying.

Thanks for catching this. "fw" was the name in v4. "fw.bootloader" is
indeed correct.


Yours sincerely,
Vincent Mailhol
