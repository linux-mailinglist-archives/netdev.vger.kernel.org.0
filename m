Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7025C52B1B9
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 07:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiERE52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 00:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiERE50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 00:57:26 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9051F48336;
        Tue, 17 May 2022 21:57:23 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g12so1472109edq.4;
        Tue, 17 May 2022 21:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9cQjMPtzVzWMMLR3FCd8zE1RGi3Xf/RRCQhm5PRrYQo=;
        b=GVpakVd4olDIiCKTtvjOIyP5NSLtCnq6WnexgNUcB/5H4VOHZlEnGwNfSZ6x90XNbR
         7RXr50u8KY1YpuR9jlzQjPNVswc/rF6VywKyUkYSacNl1xBYog0TpEEXj8fKCTb2ZHWy
         OiOp00/04notikJdEaO+2ovvLK+83EjU3Brff/pCCRJRGSkfHt9JjTG/DE8iV9Rxsem+
         QEx/UYIfGEMCIGu7B3r3RsElIB/Eyy+J4b2CUY88/1+vZISZT0rALElUqWT402Zt8AD6
         zV8W+L+GUT5RU+V2LGN67Et1YE+/nURSy11eU5TpvR/3TbUU4c5O6OfzvHTfx7prIiQW
         cb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9cQjMPtzVzWMMLR3FCd8zE1RGi3Xf/RRCQhm5PRrYQo=;
        b=7ERHP41sWUu431YB+fFPwojqYDOgK0SsnJbvVJXIF+VMhb+wmvgejuROr0NyL6goqI
         a5xiZAKdmR4/iql1dkgMMekvD1caUzvA0O2HrRT6uFre4WobpCwOScYFGN8ThAyv4akR
         R2nQ2Z8YKo76Z+nEdeQiqa6yCXq+zxPqlN4VpdXx7Zwmku/5qnPceKTANZfOM9AAyZTZ
         WFZaKSPdGy5rSIuuFCRo3rmqqgVR0C84p6ZM00sP9jQIJqKTLI6mdv+udEx97V0fBU++
         DmnL4bilAjr+3IE3P0dKAp1pL/VehWfvAYcLEBzX1SYS4yfU0Uip7XBGRLSa5VwMoGxm
         iD0Q==
X-Gm-Message-State: AOAM532Biof6PD+JIDflSiW0qU+xxPhfN8lygxrMt5x5khu2D05QvLny
        e3l51/4YFq2U8IsUetCgR20e3K+bs+BZ+XbKnuE=
X-Google-Smtp-Source: ABdhPJwli+VymbeMre2E6HJK1+EjFPm/n16fZX4UREAR0AHZazXwB0e2HdtotE34L6JLznSeSa48uGxf1kSnzT7HUNc=
X-Received: by 2002:a05:6402:5409:b0:42a:a643:4eb8 with SMTP id
 ev9-20020a056402540900b0042aa6434eb8mr18824779edb.71.1652849842034; Tue, 17
 May 2022 21:57:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220518020812.2626293-1-yangyingliang@huawei.com>
In-Reply-To: <20220518020812.2626293-1-yangyingliang@huawei.com>
From:   =?UTF-8?B?5ZGC6Iqz6aiw?= <wellslutw@gmail.com>
Date:   Wed, 18 May 2022 12:57:12 +0800
Message-ID: <CAFnkrsmmn0ut2_9uJN3kS4uQGHuO0DONJveXvYm5oRMjKCoiZw@mail.gmail.com>
Subject: Re: [PATCH -next v2] net: ethernet: sunplus: add missing
 of_node_put() in spl2sw_mdio_init()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        andrew@lunn.ch, pabeni@redhat.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yingliang,

Thanks a lot for fixing the bug.

Reviewed-by: Wells Lu <wellslutw@gmail.com>

Best regards,
Wells

Yang Yingliang <yangyingliang@huawei.com> =E6=96=BC 2022=E5=B9=B45=E6=9C=88=
18=E6=97=A5 =E9=80=B1=E4=B8=89 =E4=B8=8A=E5=8D=889:56=E5=AF=AB=E9=81=93=EF=
=BC=9A
>
> of_get_child_by_name() returns device node pointer with refcount
> incremented. The refcount should be decremented before returning
> from spl2sw_mdio_init().
>
> Fixes: fd3040b9394c ("net: ethernet: Add driver for Sunplus SP7021")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v2:
>   add fix tag.
> ---
>  drivers/net/ethernet/sunplus/spl2sw_mdio.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/sunplus/spl2sw_mdio.c b/drivers/net/eth=
ernet/sunplus/spl2sw_mdio.c
> index 139ac8f2685e..733ae1704269 100644
> --- a/drivers/net/ethernet/sunplus/spl2sw_mdio.c
> +++ b/drivers/net/ethernet/sunplus/spl2sw_mdio.c
> @@ -97,8 +97,10 @@ u32 spl2sw_mdio_init(struct spl2sw_common *comm)
>
>         /* Allocate and register mdio bus. */
>         mii_bus =3D devm_mdiobus_alloc(&comm->pdev->dev);
> -       if (!mii_bus)
> -               return -ENOMEM;
> +       if (!mii_bus) {
> +               ret =3D -ENOMEM;
> +               goto out;
> +       }
>
>         mii_bus->name =3D "sunplus_mii_bus";
>         mii_bus->parent =3D &comm->pdev->dev;
> @@ -110,10 +112,13 @@ u32 spl2sw_mdio_init(struct spl2sw_common *comm)
>         ret =3D of_mdiobus_register(mii_bus, mdio_np);
>         if (ret) {
>                 dev_err(&comm->pdev->dev, "Failed to register mdiobus!\n"=
);
> -               return ret;
> +               goto out;
>         }
>
>         comm->mii_bus =3D mii_bus;
> +
> +out:
> +       of_node_put(mdio_np);
>         return ret;
>  }
>
> --
> 2.25.1
>
