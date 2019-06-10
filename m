Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E12E3BC6E
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388841AbfFJTGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388544AbfFJTGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 15:06:08 -0400
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4682086A;
        Mon, 10 Jun 2019 19:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560193567;
        bh=lFanuHHBuVtWmR4kNCQeWkLeEoh91z4m5hAe5ZQ4DbU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=malhWk+aXGmFn7xlbapoaYjAsgdVnmFbzkgSvGw0kc+GIQJrOplOwNsMHPji8gIzL
         dSSjOwoaDHOK2hUN7pN5pqmYOIZ8ZTayZAst9xcPOz2gJ41J9s7/ZObABpcRBXNTXP
         Fauk2eleAbfyMWXdGZn0KuOXVaNS0khxSXsxHViQ=
Received: by mail-qk1-f176.google.com with SMTP id i125so6123380qkd.6;
        Mon, 10 Jun 2019 12:06:07 -0700 (PDT)
X-Gm-Message-State: APjAAAU69yYDyGrPQS+rVmSnAUW/kw5wUy90nForHldCtp0va3KrKFqi
        Bde33okz2TB59Oawjqke7+RxW7mbs54iGn1ZjQ==
X-Google-Smtp-Source: APXvYqyqk00u+A1I2mS4USQPJYej70C5KhglxD5XOZevDO5oC+8Y4Q68pL8HBKtqIMa/xiZnnWfM+2EIi1Wpb/mCRBA=
X-Received: by 2002:ae9:f801:: with SMTP id x1mr14400814qkh.151.1560193567005;
 Mon, 10 Jun 2019 12:06:07 -0700 (PDT)
MIME-Version: 1.0
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <19f160b6edf5a11171cea249305b7458c96a7187.1560158667.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <19f160b6edf5a11171cea249305b7458c96a7187.1560158667.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 10 Jun 2019 13:05:55 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJtzBwx57_EHwCrSpiFwve8ec2osK0ZXc_cMzD+5dW7FQ@mail.gmail.com>
Message-ID: <CAL_JsqJtzBwx57_EHwCrSpiFwve8ec2osK0ZXc_cMzD+5dW7FQ@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] dt-bindings: net: phy: The interrupt property is
 not mandatory
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
> Unlike what was initially claimed in the PHY binding, the interrupt
> property of a PHY can be omitted, and the OS will turn to polling instead.
>
> Document that.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 1 -
>  1 file changed, 1 deletion(-)

Reviewed-by: Rob Herring <robh@kernel.org>
