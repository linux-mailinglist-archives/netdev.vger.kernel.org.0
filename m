Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDDF66AB37
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 12:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjANLjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 06:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjANLjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 06:39:46 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CEF3A9E;
        Sat, 14 Jan 2023 03:39:44 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 207so1814315pfv.5;
        Sat, 14 Jan 2023 03:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FJvgwP2yhKq5HRMv+nGTGGcOYvJiL+zhxVk6tWVvWYs=;
        b=gbq+otLy1KBkkCrGFkFCqFwOhcIuV4PULSfpPUszRaHQr/f+pUidKShev/xBAHgtHU
         yLhonT8wUsEuVEV0CZy2CauJhNr3UvlMsAU5gOmgENToKuNcxPCVMT6nHCQIQ+0NZ3L+
         sL/uV7R/azABne/VgB632a8L0J7dq1d2LHJQBKyGiV1Qz6HIDodyCdwl7XrASNyrtWgs
         vEQOavb3x1DDYh4unwD83x71J1ns2a7MKnLWKUrVzMLnHMug15owLyL10K73tT5yYuM/
         q+OG5C8CMLB227KG++3NRP/l4MQSnLi/rJsRRwN0umyIQKK+X+9mDL6JzwwVjQNugh++
         9e4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FJvgwP2yhKq5HRMv+nGTGGcOYvJiL+zhxVk6tWVvWYs=;
        b=iP7kQZxHW0KZTh1/tAZQ3YsUskM6/40r6QsIvc0AJ2XQAkU4OBlTrqdHjBJdGkfAZo
         dicH+gsS47iwZaVWMOACTNfbdqOWuMs8R8LLmZz0MiuLohnqJlMvVt8yCjoEtDITOqak
         HpSf+spwQTKLw9QA1U7qURDB/zSZ9djA4bJn9vWxdtVFf68knIO7ClPNmom11e7Qa+85
         17xfd5UkdzleGldHebtd0wGKExZq9umr+gkq6qtWa6isl4Xxi2iYcYSvwKrp72LknRku
         bmq/B5dBgeGIz7fPz9EMA8SKQgzdBX5eUvmBv4CBbafZYPMz9KPi+PXrRb6hTJc2pNo2
         KdBA==
X-Gm-Message-State: AFqh2kp7KAQtGjPiuWbgTbHJWkV8Tf6B7/jE57KFVP+bwIWiy49tyJQI
        9kibgllwGeE/15MZrDpPF0sk/sCZDpLHAlu4AOE=
X-Google-Smtp-Source: AMrXdXuG4YlWidLin5pPzaupNzmOUxneWxv+FS2QYfh/LEJq9SXxtq8AhqG2++3ACqChh2B8EHBBrzXi9F+llg4AffI=
X-Received: by 2002:a63:154c:0:b0:4ad:7773:fd02 with SMTP id
 12-20020a63154c000000b004ad7773fd02mr1636466pgv.603.1673696384290; Sat, 14
 Jan 2023 03:39:44 -0800 (PST)
MIME-Version: 1.0
References: <20230113142718.3038265-1-o.rempel@pengutronix.de> <20230113142718.3038265-9-o.rempel@pengutronix.de>
In-Reply-To: <20230113142718.3038265-9-o.rempel@pengutronix.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sat, 14 Jan 2023 08:39:27 -0300
Message-ID: <CAOMZO5C8SSVZF8z2HngxG-d59aa=CmAQRThxkC3xaR695uKFSA@mail.gmail.com>
Subject: Re: [PATCH v1 08/20] ARM: dts: imx6dl-plybas: configure ethernet
 reference clock parent
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Abel Vesa <abelvesa@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        kernel@pengutronix.de, NXP Linux Team <linux-imx@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
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

Hi Oleksij,

On Fri, Jan 13, 2023 at 11:27 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> Configure Ethernet reference clock parent in an obvious way instead of
> using cryptic ptp way.

Could you please improve the commit log?

The "obvious way" is not obvious for people that don't have the board
schematics.

I like better the way you described the 20/20 patch:

"On this board the PHY is the ref clock provider. So, configure ethernet
reference clock as input."

Please use this format globally in the series, as it becomes clear who
is providing the ref clock.

Thanks
