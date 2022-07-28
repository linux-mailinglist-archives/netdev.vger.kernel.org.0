Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C802158360B
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 02:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbiG1ArF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 20:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiG1ArD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 20:47:03 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179A658B7A;
        Wed, 27 Jul 2022 17:47:03 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 12so282435pga.1;
        Wed, 27 Jul 2022 17:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=zq+yw9MoLlDFVjCZabxL+GTI/wzIy2gG7jrKCUyRlhA=;
        b=dZ/2SsnSHTBnsjBC2dq+jJf8Bkc6/5TgzQVfXPrSTOR9iESxJgx/pAiAkNfeGDan2H
         fTGKc2NDFsaviLubsw+pDgvWcaFnsoZAxKgBbEFH3Jz1ycuZQ5c9XSWDyUsyL7bsaN0q
         tcsTRpsG7iIB+U+s5mgnzpUh+zxfZLGXREht8anb/QCcVRr9eUFEdRvtv5k2BrIcl2OJ
         Trp3hzhqJ+yZ6Tpuhesw/Gs9MyyO7sFdlIU0l+twEboFYV6d0iaX6a+lVATGYEiTMsjC
         hUVsob8kqv/1gN5gAHYkQpwGJ/tpBzl5GqqIgFxC8RAad8TJkyB78I+7xhNkyl8QOg5z
         UanQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=zq+yw9MoLlDFVjCZabxL+GTI/wzIy2gG7jrKCUyRlhA=;
        b=1izXvdvW7YQ6IpSk+KCNS7mlwlWVNvsTf1SrHo/3GDxADqmEN0iEysOc/cKZZgvESS
         MaE48iC0GHFYUlPVx66sfe6g1HMyi5wTImwlh7RbA0cuSqT45EaMjOLQ6GeIhGVkMoRr
         Vhlr0s7l2RvooNJ82JtfiFKb0ecxvj6Dsb9+kWS2nLgSyd+fL1o9qLKgkKnMS9Y1u0FI
         Z1n/upkoGPYdjDb81QNQNRLRo0Bw8xVulEOJVivs4fuzPTeZqqjppo6OQ74pPR0pjsLM
         qBYtK/hZR5h2prMi1qyiXYoGVJ1TZsd9QawOsAt/7vRC3wBKG0+LdQaKt2lcFe6A6YCl
         HZIw==
X-Gm-Message-State: AJIora9ELfQY/gmXsy4lE6ji4hOB+GRlrIir3Rc7N6N6TN5h0UGx+YvL
        G7pdq5adEqPHXfLwBAVG7PPt/BZkBs2WIORKxF8=
X-Google-Smtp-Source: AGRyM1vJd4D2/nI5bkwbGKoWa5v9oGTDJnQdmNHzCqKm5FNToDnxz055SwQa1XGgvQalbrTssE8Jx5xXbYVqjAlXZWg=
X-Received: by 2002:a63:1b22:0:b0:411:9b47:f6bf with SMTP id
 b34-20020a631b22000000b004119b47f6bfmr20911092pgb.200.1658969222464; Wed, 27
 Jul 2022 17:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220727025255.61232-1-jrdr.linux@gmail.com> <20220728001648.cwfcmcg75lpqip5v@skbuf>
In-Reply-To: <20220728001648.cwfcmcg75lpqip5v@skbuf>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Thu, 28 Jul 2022 06:16:50 +0530
Message-ID: <CAFqt6zZF-bTh_8vYxwhG5wWvCkFHc2duK2A14_Fdt9Agzfkxwg@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: microchip: remove of_match_ptr() from ksz9477_dt_ids
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 5:46 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Wed, Jul 27, 2022 at 08:22:55AM +0530, Souptick Joarder wrote:
> > From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
> >
> > >> drivers/net/dsa/microchip/ksz9477_i2c.c:89:34:
> > warning: 'ksz9477_dt_ids' defined but not used [-Wunused-const-variable=]
> >       89 | static const struct of_device_id ksz9477_dt_ids[] = {
> >          |                                  ^~~~~~~~~~~~~~
> >
> > Removed of_match_ptr() from ksz9477_dt_ids.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
> > ---
>
> I have to say, this is a major fail for what of_match_ptr() intended to do.
>
> commit 3a1e362e3f3cd571b3974b8d44b8e358ec7a098c
> Author: Ben Dooks <ben-linux@fluff.org>
> Date:   Wed Aug 3 10:11:42 2011 +0100
>
>     OF: Add of_match_ptr() macro
>
>     Add a macro of_match_ptr() that allows the .of_match_table
>     entry in the driver structures to be assigned without having
>     an #ifdef xxx NULL for the case that OF is not enabled
>
>     Signed-off-by: Ben Dooks <ben-linux@fluff.org>
>     Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>
> Should we also depend on CONFIG_OF?

Few other drivers threw similar warnings and the suggestion was to
remove of_match_ptr(). Anyway both approaches look fine.

>
> >  drivers/net/dsa/microchip/ksz9477_i2c.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
> > index 99966514d444..c967a03a22c6 100644
> > --- a/drivers/net/dsa/microchip/ksz9477_i2c.c
> > +++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
> > @@ -118,7 +118,7 @@ MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
> >  static struct i2c_driver ksz9477_i2c_driver = {
> >       .driver = {
> >               .name   = "ksz9477-switch",
> > -             .of_match_table = of_match_ptr(ksz9477_dt_ids),
> > +             .of_match_table = ksz9477_dt_ids,
> >       },
> >       .probe  = ksz9477_i2c_probe,
> >       .remove = ksz9477_i2c_remove,
> > --
> > 2.25.1
> >
