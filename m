Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08E2C3BC68
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388814AbfFJTF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388544AbfFJTF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 15:05:29 -0400
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87CF42085A;
        Mon, 10 Jun 2019 19:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560193528;
        bh=cOW8s/VNjz5sOUaoGt0xllYK4pDMxQHNLdqEQWRROOU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YRBv6Qib4JrcChVXt7vJGBYCBimV0Z81MvXdciZgBKZRyeokB4P+LP1knHVGXNKuq
         YZ/NL5olKHnzo2vNBnuPHWdh0dkYqO4oUA4uOYoKEXDtJzHv15Chy8sSi0HIF45R6C
         ORjwtB0APFirgLUa+bGp1fz5QPiPnIVuSv+yR6NU=
Received: by mail-qt1-f180.google.com with SMTP id i34so11680357qta.6;
        Mon, 10 Jun 2019 12:05:28 -0700 (PDT)
X-Gm-Message-State: APjAAAXYn0Wsy9q1+f/TW+L4tSdcmXF/5vSBiLEiDxT93q5IPdelWj1s
        jV3XEVzABZ44PaxlTh5Hd6bfqS8Gt2BCiP1lyQ==
X-Google-Smtp-Source: APXvYqzNFAFskotptWmZSp0y4dGXTAqiAx1e+KFLMaVcOIEt50adCoQmksEswgcUSdBQTvIorzTZl1RZS8CHwOD4XHs=
X-Received: by 2002:a0c:b786:: with SMTP id l6mr33361222qve.148.1560193527816;
 Mon, 10 Jun 2019 12:05:27 -0700 (PDT)
MIME-Version: 1.0
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <b5c46cff5b59d021634be143cf559c597f0a0e1f.1560158667.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <b5c46cff5b59d021634be143cf559c597f0a0e1f.1560158667.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 10 Jun 2019 13:05:16 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+0DY8aZ0Gz_x+_QObJhuym7eMAf_OO7fQGiW==U4uPzQ@mail.gmail.com>
Message-ID: <CAL_Jsq+0DY8aZ0Gz_x+_QObJhuym7eMAf_OO7fQGiW==U4uPzQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] dt-bindings: net: Add a YAML schemas for the
 generic PHY options
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
> The networking PHYs have a number of available device tree properties that
> can be used in their device tree node. Add a YAML schemas for those.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>
> ---
>
> Changes from v1:
>   - Add missing compatible options
>   - add missing phy speeds
>   - Fix the maintainers entry
>   - Add a custom select clause to make it validate all phy nodes, and not
>     just the ones with a compatible
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 179 +++++++++-
>  Documentation/devicetree/bindings/net/phy.txt           |  80 +----
>  2 files changed, 180 insertions(+), 79 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/ethernet-phy.yaml

Reviewed-by: Rob Herring <robh@kernel.org>
