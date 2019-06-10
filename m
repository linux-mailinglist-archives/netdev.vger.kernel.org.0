Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC2C3BC9C
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389391AbfFJTOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:14:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389290AbfFJTOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 15:14:47 -0400
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 925DD2145D;
        Mon, 10 Jun 2019 19:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560194086;
        bh=zvtM6TRxQjb/B1By4vuMsY7iObTb+Li2j3Tm+EvMLdo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TGlvZMcs/FJpXPZCkptFWpPvdL4s72PHG+viHtIY82RSCS/V5RCocn4wfZwXIgujI
         sowVcaU00ECHorIr5JdcGq26ydS5zvsdRkRDlUn+XLT3JHClr90NpofFLySUwdr6aI
         OxKGI1ESby/+f2ZqpwP0N024U/F3j4pqKEkd678Q=
Received: by mail-qt1-f172.google.com with SMTP id j19so11688026qtr.12;
        Mon, 10 Jun 2019 12:14:46 -0700 (PDT)
X-Gm-Message-State: APjAAAUb74FhDDGhRTVZJbjboINh2HS1DgNxQIH/hlUu3MaqxEjdJvyZ
        5d8u3YGZH5ftKAETxAuVk8tHq/WUGsH5XW5s+Q==
X-Google-Smtp-Source: APXvYqzIM+MxrgW6H75JwOV7MZ+VIoxyIthyHEe9OmuqLCsypZeNSEVjW4Npk9sHZUa367vpismVBunOWLVPPaSnDrU=
X-Received: by 2002:aed:3fb0:: with SMTP id s45mr7686909qth.136.1560194085879;
 Mon, 10 Jun 2019 12:14:45 -0700 (PDT)
MIME-Version: 1.0
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <9fbf4e8507b7acf4840db82d9c9d910483784b2e.1560158667.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <9fbf4e8507b7acf4840db82d9c9d910483784b2e.1560158667.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 10 Jun 2019 13:14:34 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+1KWBH7vJ9sBD4CztCxx9jZBzzBPGCYKpWDthjVJ6-pg@mail.gmail.com>
Message-ID: <CAL_Jsq+1KWBH7vJ9sBD4CztCxx9jZBzzBPGCYKpWDthjVJ6-pg@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] dt-bindings: net: sun7i-gmac: Convert the
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

On Mon, Jun 10, 2019 at 3:26 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> Switch our Allwinner A20 GMAC controller binding to a YAML schema to enable
> the DT validation. Since that controller is based on a Synopsys IP, let's
> add the validation to that schemas with a bunch of conditionals.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>
> ---
>
> Changes from v1:
>   - Add a file of its own
> ---
>  Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.txt  | 27 ---------------------------
>  Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml               |  3 +++
>  3 files changed, 69 insertions(+), 27 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml

Reviewed-by: Rob Herring <robh@kernel.org>
