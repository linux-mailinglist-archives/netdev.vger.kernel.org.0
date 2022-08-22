Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7D059BF01
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 13:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbiHVLzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 07:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbiHVLzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 07:55:20 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9FB1401B
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 04:55:19 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id l1so14375162lfk.8
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 04:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=+w8P0+jPioBvyQX26soRJFaC6+SGfdkq8j/+0JNC+e0=;
        b=AER/8rUkasnKGFksiHBr/K+aXL2clTOJNVuXg6OcUviHt2NDnY58m+ZqACS4ee9TRx
         qEtl1ldAOea6CByntkGtXvhggmwgKKAWTAt7CeL9daZlpMX3n4WGfal3KgCXlRc0yXvu
         3Ta9JCf3HOEFHhuwWQtHGEUfVTv0XXbFLGy5xhLzWgPps+pk69tl5cCpHYp+z8rLxTXO
         mIb19Eg7N/Hx0A5uFABlQGgAeDfbWfyEHbZhO8CTQ6e9kObzERAOTyl5IhrGCzp7F/X5
         6h7hUI9KtbUylHPJTxXY4ZG83ZhjjMAPw65m12NqeQhTQazdE/X7qf5gFyu64h6FWq6R
         GpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=+w8P0+jPioBvyQX26soRJFaC6+SGfdkq8j/+0JNC+e0=;
        b=RyRFlIiYkcxEmXIlr4aFLIvkqH+q7isytjnja8Jm6aF7LctE2MOY/Hg26sZ7pRSNVJ
         NKQ8pHUXWHK/ZG4vlnt3x7G2P8dGAGQSlooZ2TuyJTtU1kb8KiXLSnSCpokcUajvoUg6
         5DyrZNZTRMZXvPyE0bWI1sjJllIuMBGSkevGFGk6el2xz6WZyHC4sIfuoUnq/MXw9wDd
         slacjg2JS5qRx8pjqKgHI5HcCZ+aar09WDxiNDRPWJTvGZP1I49qbP268jyelN5MpTnF
         u1t6MsMkllXT0FZ1vlBhPRzWNytWVTquU3kFuQlpB84GqVio4W4XNszu2ovI8UGL9LNW
         /VFw==
X-Gm-Message-State: ACgBeo3yNnu5L6KOO9Lks3PhJ0vC0Jr3x2DpoG9eInetT3i+EMNJWtMR
        r5oBtrcbw+dp5WT0RbEAogf9XzOwaLQsNt4lclJPhQ==
X-Google-Smtp-Source: AA6agR4TgMFnxun6qmWiRUjIOb95MacJPMwE2CqoxsUC5JiAXN89Frr0O4gZNCNpcV8Qzc9RSnpV70qRhd8su2IRP6c=
X-Received: by 2002:a05:6512:239f:b0:491:cd95:f67d with SMTP id
 c31-20020a056512239f00b00491cd95f67dmr6606005lfv.184.1661169317655; Mon, 22
 Aug 2022 04:55:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220819221616.2107893-1-saravanak@google.com> <20220819221616.2107893-4-saravanak@google.com>
In-Reply-To: <20220819221616.2107893-4-saravanak@google.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 22 Aug 2022 13:54:41 +0200
Message-ID: <CAPDyKFqFKm4t=ccs82Mb8Qaa6N+KxyNabpceYHWF4W6n2D+jPg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] Revert "PM: domains: Delete usage of driver_deferred_probe_check_state()"
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Peng Fan <peng.fan@nxp.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Doug Anderson <dianders@chromium.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Tony Lindgren <tony@atomide.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Philippe Brucker <jpb@kernel.org>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux.dev,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Aug 2022 at 00:16, Saravana Kannan <saravanak@google.com> wrote:
>
> This reverts commit 5a46079a96451cfb15e4f5f01f73f7ba24ef851a.
>
> Quite a few issues have been reported [1][2][3][4][5][6] on the original
> commit. While about half of them have been fixed, I'll need to fix the rest
> before driver_deferred_probe_check_state() can be deleted. So, revert the
> deletion for now.
>
> [1] - https://lore.kernel.org/all/DU0PR04MB941735271F45C716342D0410886B9@DU0PR04MB9417.eurprd04.prod.outlook.com/
> [2] - https://lore.kernel.org/all/CM6REZS9Z8AC.2KCR9N3EFLNQR@otso/
> [3] - https://lore.kernel.org/all/CAD=FV=XYVwaXZxqUKAuM5c7NiVjFz5C6m6gAHSJ7rBXBF94_Tg@mail.gmail.com/
> [4] - https://lore.kernel.org/all/Yvpd2pwUJGp7R+YE@euler/
> [5] - https://lore.kernel.org/lkml/20220601070707.3946847-2-saravanak@google.com/
> [6] - https://lore.kernel.org/all/CA+G9fYt_cc5SiNv1Vbse=HYY_+uc+9OYPZuJ-x59bROSaLN6fw@mail.gmail.com/
>
> Fixes: 5a46079a9645 ("PM: domains: Delete usage of driver_deferred_probe_check_state()")
> Reported-by: Peng Fan <peng.fan@nxp.com>
> Reported-by: Luca Weiss <luca.weiss@fairphone.com>
> Reported-by: Doug Anderson <dianders@chromium.org>
> Reported-by: Colin Foster <colin.foster@in-advantage.com>
> Reported-by: Tony Lindgren <tony@atomide.com>
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Saravana Kannan <saravanak@google.com>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
>  drivers/base/power/domain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index 5a2e0232862e..55a10e6d4e2a 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -2733,7 +2733,7 @@ static int __genpd_dev_pm_attach(struct device *dev, struct device *base_dev,
>                 mutex_unlock(&gpd_list_lock);
>                 dev_dbg(dev, "%s() failed to find PM domain: %ld\n",
>                         __func__, PTR_ERR(pd));
> -               return -ENODEV;
> +               return driver_deferred_probe_check_state(base_dev);
>         }
>
>         dev_dbg(dev, "adding to PM domain %s\n", pd->name);
> --
> 2.37.1.595.g718a3a8f04-goog
>
