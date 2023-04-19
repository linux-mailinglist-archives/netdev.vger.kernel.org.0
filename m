Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790386E7061
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 02:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjDSAUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 20:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjDSAT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 20:19:59 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085475B9D;
        Tue, 18 Apr 2023 17:19:58 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-54f6a796bd0so365566557b3.12;
        Tue, 18 Apr 2023 17:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681863597; x=1684455597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLuO0FT5ni9AWAkx5yPjYHqfEIyb0XFRqoQb1KsSeWo=;
        b=S8BVArrwZ18B3H56hONoNjBqSY2GxUdofcqWqzJDOYmkUDgGj9IW9Fss+xIx24ZCkH
         rWKWKRmOLpsNysUka+G3yQGMXlun/SmG15M859txABUKhY436kINzZCjVnYWXCndLvM4
         8KHJOYNMZqXDxbtjVZZM4j1GHgZRjuLWqaGnqf9DY6jWHCfIOcFQ0TWDGxJ4w2OBlCG9
         +JSdnkA9SIGgRIB5iqkgxNZ8A6iA/rheFVlWl6EFk9RcFCmKMMxW30OA4WDvr6Rym5YX
         IJCZboifMX1RPOAQv9vwqjSmJmFipGblaFwRTXNZ/3pg3QqIN44HhZanluq4/gRMiX6b
         fR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681863597; x=1684455597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vLuO0FT5ni9AWAkx5yPjYHqfEIyb0XFRqoQb1KsSeWo=;
        b=GxJ24GfShAisU4iWiRoZkUOBl9RbEHnWAhqCQaMB1qA5eSf37ZXVyKRs7KC4fv108L
         gC7I0uxa2nHe3SSOV3lg8TQIi5zwURkeInuAUsvWJg5sRBepiiSiv65pE8j9Sbxoy/x7
         jpw5bofUaeT9oD4e/6AFuNbdvqak77qnwz5QssuGRsShQKz9xlTKpZQ24UTchW6Jia37
         VAdUEEWKDdsaFb/jxh8AzCbUbK8YQyXESYMHdFmhdkXmIYf75Od3zjrDSNMbcnZvgW2b
         z0Yu7eFYJs4z/wdzX2lCas8Gdm2Yqs6yNAfmvjxt3Uxb/Sbnh11gjlKHNvcjQ5RA3kWF
         BBgA==
X-Gm-Message-State: AAQBX9eauiWnToI6D0RxF9iyqluxG/Ixe9O59kyaz9EyYb+ePbsi4fij
        mJpjMlpsSuBj1vp+Wx0uwLE5ekGmVqfhjPiI6TEes56dCfI=
X-Google-Smtp-Source: AKy350acuABH35eqRI4cUGE5NLDSP0MyKmWLUWy3oJ4G7KYUoSorueyUHRaoZPEgopF3hbuWqZbe4hQVaXr24b3Qtd0=
X-Received: by 2002:a81:17d0:0:b0:552:ae41:50a2 with SMTP id
 199-20020a8117d0000000b00552ae4150a2mr693540ywx.21.1681863596964; Tue, 18 Apr
 2023 17:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
In-Reply-To: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
From:   Justin Chen <justinpopo6@gmail.com>
Date:   Tue, 18 Apr 2023 17:19:46 -0700
Message-ID: <CAJx26kUvry0pTKmuqmt4ZK+wFg9-bWpi871jsUJWmVBRw1wuEA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6] Brcm ASP 2.0 Ethernet controller
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justin.chen@broadcom.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 5:10=E2=80=AFPM Justin Chen <justinpopo6@gmail.com>=
 wrote:
>
> From: Justin Chen <justin.chen@broadcom.com>
Woops, looks like I screwed up on some of my email addresses in the
patch set. Will fix in v2 after first round of reviews.

Justin
>
> Add support for the Broadcom ASP 2.0 Ethernet controller which is first
> introduced with 72165.
>
> Add support for 74165 10/100 integrated Ethernet PHY which also uses
> the ASP 2.0 Ethernet controller.
>
> Florian Fainelli (2):
>   dt-bindings: net: Brcm ASP 2.0 Ethernet controller
>   net: phy: bcm7xxx: Add EPHY entry for 74165
>
> Justin Chen (4):
>   dt-bindings: net: brcm,unimac-mdio: Add asp-v2.0
>   net: bcmasp: Add support for ASP2.0 Ethernet controller
>   net: phy: mdio-bcm-unimac: Add asp v2.0 support
>   MAINTAINERS: ASP 2.0 Ethernet driver maintainers
>
>  .../devicetree/bindings/net/brcm,asp-v2.0.yaml     |  146 ++
>  .../devicetree/bindings/net/brcm,unimac-mdio.yaml  |    2 +
>  MAINTAINERS                                        |    9 +
>  drivers/net/ethernet/broadcom/Kconfig              |   11 +
>  drivers/net/ethernet/broadcom/Makefile             |    1 +
>  drivers/net/ethernet/broadcom/asp2/Makefile        |    2 +
>  drivers/net/ethernet/broadcom/asp2/bcmasp.c        | 1527 ++++++++++++++=
++++++
>  drivers/net/ethernet/broadcom/asp2/bcmasp.h        |  636 ++++++++
>  .../net/ethernet/broadcom/asp2/bcmasp_ethtool.c    |  620 ++++++++
>  drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   | 1425 ++++++++++++++=
++++
>  .../net/ethernet/broadcom/asp2/bcmasp_intf_defs.h  |  238 +++
>  drivers/net/mdio/mdio-bcm-unimac.c                 |    2 +
>  drivers/net/phy/bcm7xxx.c                          |    1 +
>  include/linux/brcmphy.h                            |    1 +
>  14 files changed, 4621 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.y=
aml
>  create mode 100644 drivers/net/ethernet/broadcom/asp2/Makefile
>  create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp.c
>  create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp.h
>  create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
>  create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
>  create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_intf_defs.h
>
> --
> 2.7.4
>
