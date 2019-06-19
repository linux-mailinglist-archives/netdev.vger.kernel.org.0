Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232584BB27
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbfFSOTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbfFSOTY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 10:19:24 -0400
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAD1C21783;
        Wed, 19 Jun 2019 14:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560953963;
        bh=n8TEMp5NfQkh8hO6ix5AyOImy509Oc/VLYfShgqtBWw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TQQzzcQOVDYujYjhiqpIrjGpja5ysim7xreIt+TN34F1ZsHgv6nHPk3OxP8icYFAD
         /4yV+c0m9zEmrqiyzOdAUMc8E7d/L6CCS4/dHHDBrcQ9Hyseb+KJGWqm294Lm1AlYO
         Zk7JA9zUGhIitAcrZj+D9Vw2m2VCiTZf1p9uTW7A=
Received: by mail-qk1-f169.google.com with SMTP id s22so10982474qkj.12;
        Wed, 19 Jun 2019 07:19:23 -0700 (PDT)
X-Gm-Message-State: APjAAAUKwRMURxiQ9HJOEfc+10xcBBN9baDj2tnS578iP55B9wUy1ikS
        0A80wIkgAp3nqom+Nk70RaFwIzYHEaofOVSnBg==
X-Google-Smtp-Source: APXvYqz30or7ej65/SsSJs4x/X0k8P1S6woBKs9hS49G7m6m1H5U7iWLwPFZp3nxyKc4KLu6ce8JHx53OeFWyc6rypc=
X-Received: by 2002:a05:620a:13d1:: with SMTP id g17mr45012878qkl.121.1560953963047;
 Wed, 19 Jun 2019 07:19:23 -0700 (PDT)
MIME-Version: 1.0
References: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
 <36bc43471d12502b3b49169ca16cf1f5de415f95.1560937626.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <36bc43471d12502b3b49169ca16cf1f5de415f95.1560937626.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 19 Jun 2019 08:19:11 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+thwOWdfu8Wa2=VeHNHbcUDtAzYEisntY=txnKriG2BA@mail.gmail.com>
Message-ID: <CAL_Jsq+thwOWdfu8Wa2=VeHNHbcUDtAzYEisntY=txnKriG2BA@mail.gmail.com>
Subject: Re: [PATCH v3 07/16] dt-bindings: net: sun4i-mdio: Convert the
 binding to a schemas
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 3:48 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> Switch our Allwinner A10 MDIO controller binding to a YAML schema to enable
> the DT validation.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>
> ---
>
> Changes from v2:
>   - Add the generic MDIO YAML schema
>
> Changes from v1:
>   - Add a select statement with the deprecated compatible, and remove it
>     from the valid compatibles
> ---
>  Documentation/devicetree/bindings/net/allwinner,sun4i-a10-mdio.yaml | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  Documentation/devicetree/bindings/net/allwinner,sun4i-mdio.txt      | 27 ---------------------------
>  2 files changed, 70 insertions(+), 27 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/allwinner,sun4i-a10-mdio.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/allwinner,sun4i-mdio.txt

Reviewed-by: Rob Herring <robh@kernel.org>
