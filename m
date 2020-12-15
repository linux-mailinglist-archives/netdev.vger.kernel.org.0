Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883482DB2BC
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731345AbgLORcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:32:53 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33685 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731332AbgLORcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:32:47 -0500
Received: by mail-ot1-f68.google.com with SMTP id b24so2659470otj.0;
        Tue, 15 Dec 2020 09:32:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5yaEryw6XNLMEgGskzSLFE6j4zs11TlaPsMd8R+3tYU=;
        b=KWfIZl4CfL/d4UDVs+7nmHv7gNpB+hPf5JN7yJuOj9nlhJqSl2fwB6AYbOarSGfCcS
         ChejoRaziYzyrJEgBk8XywZOfhmwH2wY75qxl5anNCVnbfOe7dZvJ4elBh0prSMXVaFa
         2uYuwSkwa11oil/xrJeZ6bvx16cJNE1cnzGYCmGGuq18erlj+znpflC8hHBcQnekk9qr
         gE+uj3GQZM75Ej9VPoOuXrkRrXFJT9FqncTpiBqaGDBU3U0EiAr04+5OGuJRPUe1BUkp
         k/y8lukhc1nxbsoa0ZB86FGNTlyDE3BcqZAHdEArGkKQiMCxb7u1oztVQlJeNvXLC6Gr
         OEUg==
X-Gm-Message-State: AOAM533beiNmlkVbk0UNImbe/uRogZ196lobhC+/Aks/pGregom6NMgx
        aa4oh0lIru/QTEO4xugtIw==
X-Google-Smtp-Source: ABdhPJz+DY6y44Ux4FcF2FQdoyK9exddTpaOa4EWcrlXxajMaOLwPQ8+7pZrd+v329TzX5euhJ8YfQ==
X-Received: by 2002:a05:6830:1e41:: with SMTP id e1mr24207426otj.143.1608053526489;
        Tue, 15 Dec 2020 09:32:06 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q4sm4825687ooo.1.2020.12.15.09.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 09:32:05 -0800 (PST)
Received: (nullmailer pid 4074363 invoked by uid 1000);
        Tue, 15 Dec 2020 17:32:04 -0000
Date:   Tue, 15 Dec 2020 11:32:04 -0600
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/25] dt-bindings: net: dwmac: Add Tx/Rx clock sources
Message-ID: <20201215173204.GA4072234@robh.at.kernel.org>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
 <20201214091616.13545-7-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214091616.13545-7-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 12:15:56PM +0300, Serge Semin wrote:
> Generic DW *MAC can be connected to an external Tramit and Receive clock

s/Tramit/Transmit/

> generators. Add the corresponding clocks description and clock-names to
> the generic bindings schema so new DW *MAC-based bindings wouldn't declare
> its own names of the same clocks.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml        | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index e1ebe5c8b1da..74820f491346 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -126,6 +126,18 @@ properties:
>            MCI, CSR and SMA interfaces run on this clock. If it's omitted,
>            the CSR interfaces are considered as synchronous to the system
>            clock domain.
> +      - description:
> +          GMAC Tx clock or so called Transmit clock. The clock is supplied
> +          by an external with respect to the DW MAC clock generator.
> +          The clock source and its frequency depends on the DW MAC xMII mode.
> +          In case if it's supplied by PHY/SerDes this property can be
> +          omitted.
> +      - description:
> +          GMAC Rx clock or so called Receive clock. The clock is supplied
> +          by an external with respect to the DW MAC clock generator.
> +          The clock source and its frequency depends on the DW MAC xMII mode.
> +          In case if it's supplied by PHY/SerDes or it's synchronous to
> +          the Tx clock this property can be omitted.
>        - description:
>            PTP reference clock. This clock is used for programming the
>            Timestamp Addend Register. If not passed then the system
> @@ -139,6 +151,8 @@ properties:
>        enum:
>          - stmmaceth
>          - pclk
> +        - tx
> +        - rx
>          - ptp_ref
>  
>    resets:
> -- 
> 2.29.2
> 
