Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEB12275DB
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgGUCmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:42:51 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:45372 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgGUCmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:42:50 -0400
Received: by mail-il1-f193.google.com with SMTP id o3so15091098ilo.12;
        Mon, 20 Jul 2020 19:42:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=myabMmmeniqWFhEcG9x9KGWd+XEvTHv6sw7DQlXMgY8=;
        b=a+Nep5Kcyu4tq6hqZJ7FU9gOmEbaxWwwwTTwE/oXHxu1KHC8ASXzxIlPpUOC4INPTh
         6xd5ktGGPOzEKGMJ+i0RqHBsfl8bi8jfkBDZlE2QrtqXOJQbpphyfZXbTGalBZKXaH6g
         tkJ7wZVlySaFUvYEWMttpFQ1/A9cgzHCs+KI3ZaD0YOwAELqoBoJNuUTSvIgNmvuz4dh
         36WG930/uCeZxzpJRsmCJIWQOvDyIRMoQ3i/qF0XGhCJ9QyI2AGjC+JCmdd6D5HIj0t/
         BvGcibO1uqXAJtARccTgt7k+OiVhmXZiV4euOaC3T33cw1lSZ9viU+Ds8IGwAc/51AY+
         ZTzg==
X-Gm-Message-State: AOAM530oikiishyWm6PfPnb3Wm4ykjDzTPXbFUUB2TPRGyEDkLvcUAJD
        JbO+JaclKwc6N1kDcsC/ZQ==
X-Google-Smtp-Source: ABdhPJxwvlQ6lIpHvRGc2Uik3aoi96mVQa34+JzBQ7DbKI45pBw+PBrV7mCxVcIqjHYFDj2c9aQNsA==
X-Received: by 2002:a92:cb03:: with SMTP id s3mr26633458ilo.1.1595299368775;
        Mon, 20 Jul 2020 19:42:48 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id w7sm7841314iov.1.2020.07.20.19.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:42:48 -0700 (PDT)
Received: (nullmailer pid 3434091 invoked by uid 1000);
        Tue, 21 Jul 2020 02:42:46 -0000
Date:   Mon, 20 Jul 2020 20:42:46 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-renesas-soc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Damm <magnus.damm@gmail.com>, linux-i2c@vger.kernel.org,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        linux-can@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [PATCH 05/20] dt-bindings: timer: renesas,cmt: Document r8a774e1
 CMT support
Message-ID: <20200721024246.GA3434045@bogus>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-6-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594811350-14066-6-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 12:08:55 +0100, Lad Prabhakar wrote:
> Document SoC specific bindings for RZ/G2H (r8a774e1) SoC.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/timer/renesas,cmt.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
