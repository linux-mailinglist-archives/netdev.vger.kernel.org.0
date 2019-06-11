Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C41D3C82C
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 12:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405233AbfFKKIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 06:08:53 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45118 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405185AbfFKKIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 06:08:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id a14so17326528edv.12;
        Tue, 11 Jun 2019 03:08:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=upToNZmU1lMq7es+5zXvEQjyTF1NnvLf1/9ORQaZ1DE=;
        b=iCOSrKcUK+rli/OUyV1Fpo+eVbyGE8IUCkpVXPdJqMOV3jbckAVXXe/LNJ08+i85dt
         fgljXzkq+tNhQR1WuX+jv0gC5HXPKZVwhEsHH4ZVyv567GOhFi1LEvdgt0WITYQ6H2tt
         qt9hoI9VsxlxqdZLTypYTT/u1LEWyJEZYy0nVG8HC+4vMysJ30RHd4c3Lfufy4A0ddtQ
         BpDLdF5eeTVv4MjQMczE3ZWoQ99scUqlPKJjxko1nV7JPgaTvNnx5L1rAdCQEJdI366z
         mY3TJlfBxrvj0DUU/qZL7QKSLvZmLGlCrJWLEPWmyQtDxOywIKtDNB8V8BT0in3Lgpet
         0Z5g==
X-Gm-Message-State: APjAAAUjturf9kVSrohkHPTFHazvg4NrKCIZlFJeBZqqotoWBXH7VkH2
        SRhYfqZv6j6pV1dY2I2NAqzhSkV4so8=
X-Google-Smtp-Source: APXvYqxTc7uu07z4aidQ8odoAbUGZpihRowGfPQKyIP6B1ElMaLOiXVw0fUv2U0hCpYYEI8zPY3IOw==
X-Received: by 2002:aa7:c559:: with SMTP id s25mr7829344edr.117.1560247730528;
        Tue, 11 Jun 2019 03:08:50 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id o22sm2298198edc.37.2019.06.11.03.08.47
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 03:08:47 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id x17so12295897wrl.9;
        Tue, 11 Jun 2019 03:08:47 -0700 (PDT)
X-Received: by 2002:adf:fd01:: with SMTP id e1mr23640588wrr.167.1560247727247;
 Tue, 11 Jun 2019 03:08:47 -0700 (PDT)
MIME-Version: 1.0
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <af3a342a6cba1dda27763c13093a8fc060946c1e.1560158667.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <af3a342a6cba1dda27763c13093a8fc060946c1e.1560158667.git-series.maxime.ripard@bootlin.com>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Tue, 11 Jun 2019 18:08:34 +0800
X-Gmail-Original-Message-ID: <CAGb2v66vKPeyvw56ROR-B=5Bzi7GVby1CXCjgQ5hnuUdPWX0cg@mail.gmail.com>
Message-ID: <CAGb2v66vKPeyvw56ROR-B=5Bzi7GVby1CXCjgQ5hnuUdPWX0cg@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] ARM: dts: sunxi: Switch to the generic PHY properties
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

On Mon, Jun 10, 2019 at 5:26 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> The DWMAC specific properties to manage the PHY have been superseeded by
> the generic PHY properties. Let's move to it.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>
> ---
>
> This patch should go through arm-soc.
>
> Changes from v1:
>   - New patch
> ---
>  arch/arm/boot/dts/sun6i-a31-hummingbird.dts       |  6 +++---

Tested-by: Chen-Yu Tsai <wens@csie.org>
