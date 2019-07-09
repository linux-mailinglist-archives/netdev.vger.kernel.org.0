Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5DD62D6C
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 03:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfGIBcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 21:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbfGIBcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 21:32:24 -0400
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72F5221537;
        Tue,  9 Jul 2019 01:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562635943;
        bh=1nEB9DaQQGvQqSb9+kraJ2c4RLjffgEvXnpddtUDasA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=J8Vcj8FDOdTt8oSww3K2HHnjCA8KCyLGXQVSYb0/4/R+lkWwweVXJS9+CjdhHnH3c
         Li7+PczRjQWEutFh5EtPA+6ofmCOdPDQ2SFnoGCfpGOKAJ81QoHUDuD5AP3BA3GApC
         iSE5ORqfSHtegLqpIwTAaEB07ENb03YcsUmUNsUM=
Received: by mail-qt1-f169.google.com with SMTP id d17so18644185qtj.8;
        Mon, 08 Jul 2019 18:32:23 -0700 (PDT)
X-Gm-Message-State: APjAAAVMmGbqCSwfgCEFXghfX/JH7KNc9/VhL+5ZnbwFKuyn/sP/e1FQ
        4NrnNjnJTYth3TV+9ERlRIe30oPFEwXKGCH8GQ==
X-Google-Smtp-Source: APXvYqwb1wAjPpFfWA0crRufF6jYrA5s6sotYctEJVblBdQ4QiRnWCFDfGxSYiHma4Z26BSKnCyg6KDlsAlsA8esuXc=
X-Received: by 2002:ac8:36b9:: with SMTP id a54mr16759649qtc.300.1562635942713;
 Mon, 08 Jul 2019 18:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190706151900.14355-1-josua@solid-run.com> <20190706151900.14355-2-josua@solid-run.com>
In-Reply-To: <20190706151900.14355-2-josua@solid-run.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 8 Jul 2019 19:32:10 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJJA6=2b=VzDzS1ipOatpRuVBUmReYoOMf-9p39=jyF8Q@mail.gmail.com>
Message-ID: <CAL_JsqJJA6=2b=VzDzS1ipOatpRuVBUmReYoOMf-9p39=jyF8Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] dt-bindings: allow up to four clocks for orion-mdio
To:     josua@solid-run.com
Cc:     netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 6, 2019 at 9:31 AM <josua@solid-run.com> wrote:
>
> From: Josua Mayer <josua@solid-run.com>
>
> Armada 8040 needs four clocks to be enabled for MDIO accesses to work.
> Update the binding to allow the extra clock to be specified.
>
> Cc: stable@vger.kernel.org
> Fixes: 6d6a331f44a1 ("dt-bindings: allow up to three clocks for orion-mdio")
> Signed-off-by: Josua Mayer <josua@solid-run.com>
> ---
>  Documentation/devicetree/bindings/net/marvell-orion-mdio.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt b/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
> index 42cd81090a2c..3f3cfc1d8d4d 100644
> --- a/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
> +++ b/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
> @@ -16,7 +16,7 @@ Required properties:
>
>  Optional properties:
>  - interrupts: interrupt line number for the SMI error/done interrupt
> -- clocks: phandle for up to three required clocks for the MDIO instance
> +- clocks: phandle for up to four required clocks for the MDIO instance

This needs to enumerate exactly what the clocks are. Shouldn't there
be an additional clock-names value too?

Rob
