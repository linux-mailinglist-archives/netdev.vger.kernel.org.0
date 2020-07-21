Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F2B2275D2
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgGUCmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:42:36 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:41827 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgGUCmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:42:35 -0400
Received: by mail-il1-f194.google.com with SMTP id q3so15107318ilt.8;
        Mon, 20 Jul 2020 19:42:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a37UVIcr3tFTjvos+1XDI3vyeJL0TUxOErOODhturYQ=;
        b=qKqeAo/ni4hlVbUxXfk5SHB3ryIkx1fCZykCPOINnWAPu3axe0TUUJIM1nc7t6fVwr
         6v9+564334dnwsALgK1ZfXF4XmCrFbwE+gU1vcEPAGYtsS9x9+V1wfytrRSNA52vGdfm
         ehbxmnr69hEMRQMept2H+XkGejKf7KwqwWHgDm4V+xIVqx/t5HuTZMsMqYY1RqgJhcvg
         QZgtbImn5mXDVzGdlbrxgWfWInITPkEB1jGDCmxrRNvdUArdOXUP5K1o7ByWRCeFk6sO
         +PBY31CumJh4k7A4kNPW53Mu7e0WzvZN5Bi44vyAbmNeOvklRyODyARbh06X0xE616a3
         TvGQ==
X-Gm-Message-State: AOAM533AMgH6m44kCxih7gSVk9ZfiGh6d1GZfNrEEozLlyhf4jVU1KPK
        wjJxkrAdFGjtoRS48z3PPA==
X-Google-Smtp-Source: ABdhPJwG8kX/q1434RzLt+ZA/7HsPclvXJIOgxPK5H8X536km51g25555NKw2Ltyw6fPW2ta3HlnXg==
X-Received: by 2002:a92:cd48:: with SMTP id v8mr27621396ilq.114.1595299354086;
        Mon, 20 Jul 2020 19:42:34 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id r124sm9538209iod.40.2020.07.20.19.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:42:33 -0700 (PDT)
Received: (nullmailer pid 3433663 invoked by uid 1000);
        Tue, 21 Jul 2020 02:42:31 -0000
Date:   Mon, 20 Jul 2020 20:42:31 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, linux-pm@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Zhang Rui <rui.zhang@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/20] dt-bindings: thermal: rcar-gen3-thermal: Add
 r8a774e1 support
Message-ID: <20200721024231.GA3433616@bogus>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594811350-14066-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 12:08:52 +0100, Lad Prabhakar wrote:
> Document RZ/G2H (R8A774E1) SoC bindings.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/thermal/rcar-gen3-thermal.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
