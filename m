Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47F979FA1
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 05:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbfG3DvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 23:51:19 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39023 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbfG3DvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 23:51:19 -0400
Received: by mail-ed1-f66.google.com with SMTP id m10so61243054edv.6;
        Mon, 29 Jul 2019 20:51:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ISIVHu+AuwTJR7JUopUzw4hbupo9+MlQhSrhmHZcakc=;
        b=mjCvzCwYjoNfSRf79L0q+3XhvyHcELbBIiq8ojPPFnELxPsDpPRWOHDz/h8uBZkKQk
         vCgBkYErFg/teI9wogMZViHlmtVDWTGcvN1zSNFIrNdiJdG52JxtGS2TtCQbd1CtL61B
         Fze0+CHBRbrJ11u8efmJx+5uJtz+PV+6Dxc8I70hFEDJcKwPUmg596P8F17GwbNDUECw
         vU5InALnaQ1KVevjYVRBOMNolGVyAHnZOo1A6eWeig5VcnzOEqHmprVcxerAXzdpY23S
         OHqQjb95Ue5cKqQwczRTpS/Rbgy+YRlX735BwWAKACv+7KjkF11T0lyzYBspHsAHVPE2
         efgA==
X-Gm-Message-State: APjAAAU3gn5R9+YwjMS+JU/FsDtrXv8U3Iej0hrtj6G3CDIkIsRbgPzI
        5D2+0cEtjgiFzKmfjqpcc/bBBfg4ggo=
X-Google-Smtp-Source: APXvYqzVmwPw+PGL8mztXM3XoQo7QOEsiRXeys2bWe+rC6V2xLTGbGa31fXEGithUPJtfNBS44yXNA==
X-Received: by 2002:a50:9822:: with SMTP id g31mr96968624edb.175.1564458676455;
        Mon, 29 Jul 2019 20:51:16 -0700 (PDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com. [209.85.221.50])
        by smtp.gmail.com with ESMTPSA id y3sm15393006edr.27.2019.07.29.20.51.15
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 20:51:16 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id r1so64061049wrl.7;
        Mon, 29 Jul 2019 20:51:15 -0700 (PDT)
X-Received: by 2002:adf:e941:: with SMTP id m1mr37011261wrn.279.1564458675544;
 Mon, 29 Jul 2019 20:51:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.e80da8845680a45c2e07d5f17280fdba84555b8a.1561649505.git-series.maxime.ripard@bootlin.com>
 <a1a33392c64c71099021fb49cc811a30790d40a8.1561649505.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <a1a33392c64c71099021fb49cc811a30790d40a8.1561649505.git-series.maxime.ripard@bootlin.com>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Tue, 30 Jul 2019 11:51:02 +0800
X-Gmail-Original-Message-ID: <CAGb2v67u3pvS1veHTHVPySK1YGJYwGzPF7-iziefsbWRNZNyrg@mail.gmail.com>
Message-ID: <CAGb2v67u3pvS1veHTHVPySK1YGJYwGzPF7-iziefsbWRNZNyrg@mail.gmail.com>
Subject: Re: [PATCH v4 13/13] ARM: dts: sunxi: Switch from phy to phy-handle
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
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

On Thu, Jun 27, 2019 at 11:32 PM Maxime Ripard
<maxime.ripard@bootlin.com> wrote:
>
> The phy device tree property has been deprecated in favor of phy-handle,
> let's replace it.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

This patch breaks Ethernet on all my dwmac-sunxi, i.e. old GMAC, boards, with
the following error messages:

    sun7i-dwmac 1c50000.ethernet eth0: no phy at addr -1
    sun7i-dwmac 1c50000.ethernet eth0: stmmac_open: Cannot attach to
PHY (error: -19)

Reverting this patch fixes it.

It also breaks the A10/A10s, but that's probably because the sun4i-emac
driver doesn't recognize the "phy-handle" property.

ChenYu
