Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FAB6D840A
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbjDEQsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjDEQsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:48:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3E830FD;
        Wed,  5 Apr 2023 09:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0B9462979;
        Wed,  5 Apr 2023 16:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E07CC433EF;
        Wed,  5 Apr 2023 16:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680713288;
        bh=22ZlOUdVMzmaWyuCliiH+IGS7pPTTM98jyuFQs6JaxU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=As01gsATq0TJyi7JZUFiySulLYX1O6SAhxW8EjpE7ttZQbvsIeAn8QOPjv0D7nJhQ
         ToYBoEPqVCKPoQUMymCpxRk+n/SXD3MQLOOV1vBZtwzfaadBZnsuaH2M3BRgBXc/KH
         3hGpYy43n52biSNcpxyrbhQO4YKEZ8U9plksKd+pVCqS39zJqeDB7KVY2xjAJPxNxA
         R4TUBk+BtQaoWC54IIWSstOu69iWGOI20Op/exPJV7h6ffhNFo8KgLTQe9pmKBR7Zr
         rpDnFhoTYA3H41JvkGqdGffOr7HJJQ8WNVc792d9pHltZ5J5OEGrGWuHuLIl6k142/
         /6pI6ZD/6qTlw==
Received: by mail-yb1-f170.google.com with SMTP id d3so15417180ybu.1;
        Wed, 05 Apr 2023 09:48:08 -0700 (PDT)
X-Gm-Message-State: AAQBX9dm92h3aR0ap0F8wuL0r2rISDEhUxtduHzDuhIaMXqBE1csrKBA
        C1GbjqWk7aHgZLeWy6FF/4e5MviXl1aC2QXNyg==
X-Google-Smtp-Source: AKy350ZQx0dkPXkdwb3C7yfZngsJ/me3yZn0KqkDJct1jJHk/VdVBxS0W1oMDzSaZEkNczgg8bKEBgL3JEFO7l3y88w=
X-Received: by 2002:a25:da0a:0:b0:b77:81f:42dc with SMTP id
 n10-20020a25da0a000000b00b77081f42dcmr4682130ybf.1.1680713287294; Wed, 05 Apr
 2023 09:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
 <20230329-acpi-header-cleanup-v1-5-8dc5cd3c610e@kernel.org> <CAJZ5v0h8pEq4Tx-Q=VPT-XR73NRk=_XQg6vgr-wA-CFesuuSLg@mail.gmail.com>
In-Reply-To: <CAJZ5v0h8pEq4Tx-Q=VPT-XR73NRk=_XQg6vgr-wA-CFesuuSLg@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 5 Apr 2023 11:47:55 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKVg_1T2SkMRryDFyYho1Kz+ppNkqozPdyyX_t4EFBJpg@mail.gmail.com>
Message-ID: <CAL_JsqKVg_1T2SkMRryDFyYho1Kz+ppNkqozPdyyX_t4EFBJpg@mail.gmail.com>
Subject: Re: [PATCH 5/5] ACPI: Replace irqdomain.h include with struct declarations
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Len Brown <lenb@kernel.org>,
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 5, 2023 at 9:59=E2=80=AFAM Rafael J. Wysocki <rafael@kernel.org=
> wrote:
>
> Hi Rob,
>
> On Wed, Mar 29, 2023 at 11:21=E2=80=AFPM Rob Herring <robh@kernel.org> wr=
ote:
> >
> > linux/acpi.h includes irqdomain.h which includes of.h. Break the includ=
e
> > chain by replacing the irqdomain include with forward declarations for
> > struct irq_domain and irq_domain_ops which is sufficient for acpi.h.
> >
> > Cc: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
> >  include/linux/acpi.h | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> > index efff750f326d..169c17c0b0dc 100644
> > --- a/include/linux/acpi.h
> > +++ b/include/linux/acpi.h
> > @@ -10,12 +10,14 @@
> >
> >  #include <linux/errno.h>
> >  #include <linux/ioport.h>      /* for struct resource */
> > -#include <linux/irqdomain.h>
> >  #include <linux/resource_ext.h>
> >  #include <linux/device.h>
> >  #include <linux/property.h>
> >  #include <linux/uuid.h>
> >
> > +struct irq_domain;
> > +struct irq_domain_ops;
> > +
> >  #ifndef _LINUX
> >  #define _LINUX
> >  #endif
> >
> > --
>
> This causes build issues in linux-next, so I've dropped the series.  I
> will be happy to pick it up again when the build issues are addressed,
> though.

Is it just the one in pata_macio.c or are there others you are aware of?

Rob
