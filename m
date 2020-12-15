Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C0B2DB2AE
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbgLORdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:33:10 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46659 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731346AbgLORc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:32:58 -0500
Received: by mail-ot1-f68.google.com with SMTP id w3so20139147otp.13;
        Tue, 15 Dec 2020 09:32:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vRpREWWrDSibjIKmFfLj7IBAo/4P0w9FVJMb1Oijnck=;
        b=FJIwF6zygKL97uoX4vSZigZThVQaf1dzPpdpUO8koJIrqqahZVfApaYqw2Rl9wNO5F
         qg088Pd4+fCfwATr0ccUnffT4N0G6CajPzXAQhWAml+0Wn707WJLjR23f/i0papq9iX/
         jONmC5IiZ52KlWcN7fH5YRFdnoKdciJifFLuWX8M1OEaYLtIsyj//S1SGQzbFfHUU98q
         lVXm1W5vcE4/QpKroACxDKijY8Dd7V+lQbZ1dtEtie1m+kvKguUh+U/mCwyBYu+hTc5A
         2JU8tzvlVjl0fWa+qe6HBm+Jp7SMq2go/ovThtE8OGB4bcExjKmkMx13icF2oKYKgqaa
         Iw0g==
X-Gm-Message-State: AOAM532AMB43XdiCVvvLzXCr+vxv9zSZbSA+nzJu3qYpDI8abUAuOiDa
        Eb8PqXw+TecdjHyvSjkPrA==
X-Google-Smtp-Source: ABdhPJz9svCsyXrZEFs5n8HwMpo8KxwFw8IcHeoxaSibrjcLEv2+XL7MNmEGZ3jylX9nYH8tDpgofw==
X-Received: by 2002:a9d:3e2:: with SMTP id f89mr18966048otf.278.1608053537462;
        Tue, 15 Dec 2020 09:32:17 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id d13sm559416oti.74.2020.12.15.09.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 09:32:15 -0800 (PST)
Received: (nullmailer pid 4074677 invoked by uid 1000);
        Tue, 15 Dec 2020 17:32:14 -0000
Date:   Tue, 15 Dec 2020 11:32:14 -0600
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Joao Pinto <jpinto@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        devicetree@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Johan Hovold <johan@kernel.org>, netdev@vger.kernel.org,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Lars Persson <larper@axis.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>
Subject: Re: [PATCH 06/25] dt-bindings: net: dwmac: Add Tx/Rx clock sources
Message-ID: <20201215173214.GA4074624@robh.at.kernel.org>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
 <20201214091616.13545-7-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214091616.13545-7-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 12:15:56 +0300, Serge Semin wrote:
> Generic DW *MAC can be connected to an external Tramit and Receive clock
> generators. Add the corresponding clocks description and clock-names to
> the generic bindings schema so new DW *MAC-based bindings wouldn't declare
> its own names of the same clocks.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml        | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
