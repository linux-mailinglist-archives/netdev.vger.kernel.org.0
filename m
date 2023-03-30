Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DD66D0C8F
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjC3RTN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 30 Mar 2023 13:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbjC3RTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:19:08 -0400
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3983CE1A2;
        Thu, 30 Mar 2023 10:19:05 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id eg48so79228577edb.13;
        Thu, 30 Mar 2023 10:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680196743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/sK01N/HcAzey7kutWyAm0fiwuXpPIV0t8lDayMPKNs=;
        b=4r8n6zZoDCBwTrqlp6Wpc0Opn4JmZTEDhm+FmJNJeKI6a+Pv+Q3RRlFjsr1uHrpUiY
         0HSzyc61/TnpDx/H/pVUreWsdyBdtGV+x4Csmimk+qL4CaKEQMubSejsU5t7TkBMumlV
         tqiiK1nGmdaZLimos68yQmt1f3rcJRT4uVCgkc47+ucCL1iL7lmNy8YFh9nBs7zOXLG6
         sZIPb3oDVkR5WJ++wT5no7X6p2SqTJUDaasZwkK9CcE/cbpVuFmpool7B2KL62Td03OE
         GGEkFXgbAdf8+ln3IVOVQxQlslyu5WkIMOajXpclKe5atWNr3Gqhro3KV1qkmKwGqKii
         +B/g==
X-Gm-Message-State: AAQBX9c/Q3e3+Ef2ddBZtuqGNsgJGTlZ/KKCVMs9gQtpXl2WcW/c8ddy
        DbjroA3ziOmH0T8o6RJuuzwZjXfwszhnQIk8fr4=
X-Google-Smtp-Source: AKy350YytQ1yNiR6W3Bf1WUTGN6F1FlrOPm5tq5wq5gaK9i6al6bWOGltYKF/XedV9kSLG6QNcyQIMF5Rh1uNWAeOVs=
X-Received: by 2002:a17:907:a0cd:b0:947:4b15:51e5 with SMTP id
 hw13-20020a170907a0cd00b009474b1551e5mr1794105ejc.2.1680196743353; Thu, 30
 Mar 2023 10:19:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org> <ZCUon17pXpgBr0eQ@kroah.com>
In-Reply-To: <ZCUon17pXpgBr0eQ@kroah.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 30 Mar 2023 19:18:52 +0200
Message-ID: <CAJZ5v0jKA9GQULe360ZnwiKc4HRHcLJR=LxDwwm7DGP59JU_rw@mail.gmail.com>
Subject: Re: [PATCH 0/5] Remove acpi.h implicit include of of.h
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh@kernel.org>
Cc:     Len Brown <lenb@kernel.org>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
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

On Thu, Mar 30, 2023 at 8:13 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Mar 29, 2023 at 04:20:41PM -0500, Rob Herring wrote:
> > In the process of cleaning up DT includes, I found that some drivers
> > using DT functions could build without any explicit DT include. I traced
> > the include to be coming from acpi.h via irqdomain.h.
> >
> > I was pleasantly surprised that there were not 100s or even 10s of
> > warnings when breaking the include chain. So here's the resulting
> > series.
> >
> > I'd suggest Rafael take the whole series. Alternatively,the fixes can be
> > applied in 6.4 and then the last patch either after rc1 or the
> > following cycle.
> >
> > Signed-off-by: Rob Herring <robh@kernel.org>
>
> Nice cleanup, all are:
>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

All applied as 6.4 material with the tags collected so far, thanks!
