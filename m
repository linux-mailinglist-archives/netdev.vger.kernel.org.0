Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6D2254B2C
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 18:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgH0Qwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 12:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgH0Qwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 12:52:42 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D9BC061264;
        Thu, 27 Aug 2020 09:52:41 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id u6so3339511ybf.1;
        Thu, 27 Aug 2020 09:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v+eVxBfBAprEoX5lLsx5hIWnMBJGynUOeo5uh014b8M=;
        b=ExhD/2mNuu7QZdIY5cch/qOJMBWfnT4mnJMCA4ivXYVpIesCxQrVTOct6XrITaUdqW
         zI0D1zbSlVZENk+1rZwlfnZHnygNc+D8lg+Ea4hNY2GbpmmnCSmlD/28uI1V1SdBlXau
         Omd8VC0AVp+dRJ96EWawlmPCep3Yah+/Wt8J1OQlw8JS1cSalpCf6RSRx4NvjJ4UyFYJ
         9CFaro1gpjQLQZ7ozt2kz/rnFrRUHkczgBtK/LvMC5EDcm9f0vyg4qvlVTyv5vLEr+K8
         PDQkA8WXJP5C3Fqx63+KDiV2NZOrrzkYU13nBUs+9OkxCfov/ysC4COJW9vo8SYii+Jx
         RMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v+eVxBfBAprEoX5lLsx5hIWnMBJGynUOeo5uh014b8M=;
        b=eeNYfbITkoNabZAgVXrpF6HkTfrdS+38eL9Zyp5WkjoX4ED2tESIi8Gc4WY6YJ5gRw
         bNURWxuoOYCCzvVs94WFYL687/kJzo885X1HbYwmby8COA06wRp7WfTkX/pOwVqK9GlM
         lE0OjXFTHsVpTGcZWnXt24pZLxx4XNdTSqFvVbrpfqCI0gQxT+YKGcJUkzotMVn9GyB2
         tdRXViAjd4oJC6GZXfQxp1mf2OFpD7NcTP7aKlKG38LSMq04QDxJJP9WJKUqVsLTiD0D
         X5gOfuLZ4vVq0oxB0PZcpXglBbpjE9tbE+KsoW2GDWXa0nOf/TK3+PM2XxTv3Y+g+Dar
         pAWg==
X-Gm-Message-State: AOAM533Wdo3KsQJleUqJrgxQ4S2JOq/TxP/4qpgeThqkx4EH28gpKdyE
        1aKz8VctPvPVTj9gM9S9WfvpfzNPORwOmUHulyw=
X-Google-Smtp-Source: ABdhPJzWnbAjrzxUkZhdpNb2pCrtHNzhLuZPuwpgMSMn67x3fMFvwz8SPKnNKf4Cg4KNXX+P3L0zcQWqDZA/oMNp76c=
X-Received: by 2002:a25:8149:: with SMTP id j9mr31166464ybm.214.1598547161204;
 Thu, 27 Aug 2020 09:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Thu, 27 Aug 2020 17:52:15 +0100
Message-ID: <CA+V-a8vwhtTWjaoXkfMBjKx90WkcoejD5ryPkXnQNEbtgnJGXQ@mail.gmail.com>
Subject: Re: [PATCH 02/20] dt-bindings: thermal: rcar-gen3-thermal: Add
 r8a774e1 support
To:     Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zhang,Daniel,Amit,

On Wed, Jul 15, 2020 at 12:09 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
>
> Document RZ/G2H (R8A774E1) SoC bindings.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/thermal/rcar-gen3-thermal.yaml | 1 +
>  1 file changed, 1 insertion(+)
>
Gentle ping.

Cheers,
Prabhakar
