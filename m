Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D92BC58ADD
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 21:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfF0TRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 15:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbfF0TRx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 15:17:53 -0400
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4119B216E3;
        Thu, 27 Jun 2019 19:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561663073;
        bh=jVA4VB9s5NNy9GIAi2iskWf5Auj5Utva7w73gHJYNuA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ae4utuPSQV3RWm09jXUtYypQOUgcyxetwsNCrFA24+VnggTEpoFKEvr0UyFZmkJL7
         s6tzk/zlkcFOBr6INX6mshjna79/iSbjeSCbX3mHV36qVnXrlAJWLc+zy3nhGp2Npe
         pH18Ipb481m/RGHEM6joBPRqQ66+BtHmh6V6WpUY=
Received: by mail-qk1-f171.google.com with SMTP id m14so2724914qka.10;
        Thu, 27 Jun 2019 12:17:53 -0700 (PDT)
X-Gm-Message-State: APjAAAVIsb8IauMx5YZNX6ZzqwNmjhVCbucqKcOjp9WO0PumuXDrludc
        UvN1BycspAojJ1//j9p6BAcg7IWOgfy26VeiqQ==
X-Google-Smtp-Source: APXvYqwMe03fvIIa3Mb5qmrWDe/3LSiR1s/xQeMGkTRSxCRPlyYgVVQQnPRou7SUsvG7QpKsbJzlqXNsXyomtemEUa0=
X-Received: by 2002:a05:620a:1447:: with SMTP id i7mr5051184qkl.254.1561663072405;
 Thu, 27 Jun 2019 12:17:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.e80da8845680a45c2e07d5f17280fdba84555b8a.1561649505.git-series.maxime.ripard@bootlin.com>
 <20190627.102256.1839462093915893704.davem@davemloft.net>
In-Reply-To: <20190627.102256.1839462093915893704.davem@davemloft.net>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 27 Jun 2019 13:17:40 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJ9VtRv6QKuPO9kXst61ndG1UNBnx8qMkkv879GG7JTXg@mail.gmail.com>
Message-ID: <CAL_JsqJ9VtRv6QKuPO9kXst61ndG1UNBnx8qMkkv879GG7JTXg@mail.gmail.com>
Subject: Re: [PATCH v4 00/13] net: Add generic and Allwinner YAML bindings
To:     David Miller <davem@davemloft.net>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 11:22 AM David Miller <davem@davemloft.net> wrote:
>
> From: Maxime Ripard <maxime.ripard@bootlin.com>
> Date: Thu, 27 Jun 2019 17:31:42 +0200
>
> > This is an attempt at getting the main generic DT bindings for the ethernet
> > (and related) devices, and convert some DT bindings for the Allwinner DTs
> > to YAML as well.
> >
> > This should provide some DT validation coverage.
>
> I don't think this should go via my tree as it's all DT stuff.

That's fine. I can take it. There's one conflict with commit
79b647a0c0d5 ("dt-bindings: net: document new usxgmii phy mode"), but
that's easy enough to handle. Any other changes to the binding docs
will need to go thru me this cycle.

Rob
