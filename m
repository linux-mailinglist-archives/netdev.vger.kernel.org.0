Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C186D85BE
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 20:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbjDESMJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Apr 2023 14:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDESMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 14:12:07 -0400
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728A71A8;
        Wed,  5 Apr 2023 11:12:06 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id eh3so143194259edb.11;
        Wed, 05 Apr 2023 11:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680718325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y/h1wnReky+bpZGjcFPhU9qtus+mzxkSsVtUudoN3sc=;
        b=vQX4/PwL95AZ9I2LZTH0RXnvpskQLWjMiVIwVIlOgJDMFZaLBx3GotY7TD7NMwE/ZY
         Ntzi3VKCSf3O5VOXPgiBdkcGTAu088fjmifg58YQ4QZaSh1vJfKA8t5ggQRWxxTPazIi
         1VF08eMwU6WUtv7ROFZCyt8Gu6XLzVE88hue+w33pfID8UlqvqlN1LgfWKfjpw4IrQdB
         3GtAOOKf6u1r5tv8LfpCH/irngvcgCQpaltb/Vrw09D3RJH+v6rDHF4n18zZRz3xDzfu
         qgbqWmThrgHBgIg56BsSM3oGsM2S7q33RekU5iZxBDfANOGKQ3T0nbnDUGEZOLAX/kaT
         xuZg==
X-Gm-Message-State: AAQBX9dCS+FCM2foabbPmfJZ1VypqnfyEdsC63/BWQrfYKH+tUc8dxwF
        Nv6yPSBtrNmY+maFNJBhGIXDtKVb7tOgBrsjpfQ=
X-Google-Smtp-Source: AKy350a4/1UgQtuZi96LdxsX2CgTr+CU3hxhJSZ5/OXGn3TAfH7X6v13QHnOxtyoiPa1CwRyJPG+X/O/1zQCiXxYReY=
X-Received: by 2002:a17:906:6d55:b0:947:c623:2c84 with SMTP id
 a21-20020a1709066d5500b00947c6232c84mr2032299ejt.2.1680718324772; Wed, 05 Apr
 2023 11:12:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
 <20230329-acpi-header-cleanup-v1-5-8dc5cd3c610e@kernel.org>
 <CAJZ5v0h8pEq4Tx-Q=VPT-XR73NRk=_XQg6vgr-wA-CFesuuSLg@mail.gmail.com> <CAL_JsqKVg_1T2SkMRryDFyYho1Kz+ppNkqozPdyyX_t4EFBJpg@mail.gmail.com>
In-Reply-To: <CAL_JsqKVg_1T2SkMRryDFyYho1Kz+ppNkqozPdyyX_t4EFBJpg@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 5 Apr 2023 20:11:53 +0200
Message-ID: <CAJZ5v0gjJsEe4hUgTcCUXghKkWd+0ChPfDndPavioj2XMC_gMQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] ACPI: Replace irqdomain.h include with struct declarations
To:     Rob Herring <robh@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Marc Zyngier <maz@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 5, 2023 at 6:48 PM Rob Herring <robh@kernel.org> wrote:
>
> On Wed, Apr 5, 2023 at 9:59 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > Hi Rob,
> >
> > On Wed, Mar 29, 2023 at 11:21 PM Rob Herring <robh@kernel.org> wrote:
> > >
> > > linux/acpi.h includes irqdomain.h which includes of.h. Break the include
> > > chain by replacing the irqdomain include with forward declarations for
> > > struct irq_domain and irq_domain_ops which is sufficient for acpi.h.
> > >
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Signed-off-by: Rob Herring <robh@kernel.org>
> > > ---
> > >  include/linux/acpi.h | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> > > index efff750f326d..169c17c0b0dc 100644
> > > --- a/include/linux/acpi.h
> > > +++ b/include/linux/acpi.h
> > > @@ -10,12 +10,14 @@
> > >
> > >  #include <linux/errno.h>
> > >  #include <linux/ioport.h>      /* for struct resource */
> > > -#include <linux/irqdomain.h>
> > >  #include <linux/resource_ext.h>
> > >  #include <linux/device.h>
> > >  #include <linux/property.h>
> > >  #include <linux/uuid.h>
> > >
> > > +struct irq_domain;
> > > +struct irq_domain_ops;
> > > +
> > >  #ifndef _LINUX
> > >  #define _LINUX
> > >  #endif
> > >
> > > --
> >
> > This causes build issues in linux-next, so I've dropped the series.  I
> > will be happy to pick it up again when the build issues are addressed,
> > though.
>
> Is it just the one in pata_macio.c or are there others you are aware of?

I'm aware of a few:

https://lore.kernel.org/lkml/20230403201801.02839c9a@canb.auug.org.au/
https://lore.kernel.org/lkml/20230403112514.47ff91bb@canb.auug.org.au/
https://lore.kernel.org/lkml/20230403111605.7658ec62@canb.auug.org.au/
https://lore.kernel.org/lkml/20230403110650.6b13cb71@canb.auug.org.au/
