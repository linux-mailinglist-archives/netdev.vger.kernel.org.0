Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C629E6D8036
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 16:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbjDEO7r convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Apr 2023 10:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDEO7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 10:59:45 -0400
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CB61FF7;
        Wed,  5 Apr 2023 07:59:44 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id t10so141660331edd.12;
        Wed, 05 Apr 2023 07:59:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680706782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PIwPFSHZcZTOVeokZaz942Rb6z1/6U2kl/cQF2ZCigE=;
        b=5bS2HCsY35fAE37qkFgV8uZnvsrcEf1jzxU2tn9nGp+zJIh1LIW1m4M/jwBCSSHBKV
         su7HMqesWIDztCB5kTGfAclcRu0hyZEJwprGFpfwHnIbKdMlPl+P2WG3afpLcu/BnCa/
         RXhm+ey2ysrTga10wgSbYSzmidWdMEh9UiwknM4ttqv43oTOrru09szjeDKMHitJ6VuN
         5wYRL4uuddVSHvuDBHW07f8yNKknSYzlOh2O8XzOaAYR6i3YLcNeAI7LaEpuw0qfdYsJ
         xkKolKpiQCp3F3YgvH4KUIAu49iFWv1lpDNRg8LGlNM/vbw94as5yov4R2aW/rJkoFxG
         3S2Q==
X-Gm-Message-State: AAQBX9cYyPRrgMnrA+1LcF29aj4alA9+jUc7zJPTNx1R3K5nrgojX61v
        mboDFX7NhwuFnwfKS0ivL4WBXemNFCWTpv3w2/4=
X-Google-Smtp-Source: AKy350a4pvA7bHYbF3tn7kupoBqb+rMIx2cjRVXOEUqiuhWhUrNUA75BhjkFXftrDZzlVLFANv2u1dboAZf4nW2MZkk=
X-Received: by 2002:a17:907:3f92:b0:934:b5d6:14d0 with SMTP id
 hr18-20020a1709073f9200b00934b5d614d0mr1986841ejc.2.1680706782565; Wed, 05
 Apr 2023 07:59:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org> <20230329-acpi-header-cleanup-v1-5-8dc5cd3c610e@kernel.org>
In-Reply-To: <20230329-acpi-header-cleanup-v1-5-8dc5cd3c610e@kernel.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 5 Apr 2023 16:59:31 +0200
Message-ID: <CAJZ5v0h8pEq4Tx-Q=VPT-XR73NRk=_XQg6vgr-wA-CFesuuSLg@mail.gmail.com>
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

Hi Rob,

On Wed, Mar 29, 2023 at 11:21 PM Rob Herring <robh@kernel.org> wrote:
>
> linux/acpi.h includes irqdomain.h which includes of.h. Break the include
> chain by replacing the irqdomain include with forward declarations for
> struct irq_domain and irq_domain_ops which is sufficient for acpi.h.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  include/linux/acpi.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index efff750f326d..169c17c0b0dc 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -10,12 +10,14 @@
>
>  #include <linux/errno.h>
>  #include <linux/ioport.h>      /* for struct resource */
> -#include <linux/irqdomain.h>
>  #include <linux/resource_ext.h>
>  #include <linux/device.h>
>  #include <linux/property.h>
>  #include <linux/uuid.h>
>
> +struct irq_domain;
> +struct irq_domain_ops;
> +
>  #ifndef _LINUX
>  #define _LINUX
>  #endif
>
> --

This causes build issues in linux-next, so I've dropped the series.  I
will be happy to pick it up again when the build issues are addressed,
though.

Thanks!
