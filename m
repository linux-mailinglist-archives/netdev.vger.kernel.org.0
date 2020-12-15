Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326E72DB25B
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgLORP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:15:58 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34641 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgLORPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:15:38 -0500
Received: by mail-oi1-f196.google.com with SMTP id s75so24137849oih.1;
        Tue, 15 Dec 2020 09:15:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WDL2cS7hdWKtIpZ/KjKtPA2ntVpYBO+MI/yCzfxd848=;
        b=mh3ZS0ZvoCCRBTPs3ZCtMIga2E2QSO1JTWOqy/BTz5nG9q2TaJvTpV+5fWtt8JYlSO
         cNjLagBTXIxX4Ou0s7zOS8kpy1U3kP389TyfU7yId9cuf90zwGOK9BOfEmNQJBh+jHur
         7jjrJoZCQpL/E+0fCrBUBrlvgzM5htj66x/BC7Hb/M3UfB8O6zSQj5WJ0vZiwQ5UbBcW
         1OG4g0ulE1WW8Ovm0136PJlwi7470nJYIe/rCz/QWjdRiyzkqC8KBch9Oe+ZVttjpySD
         Kti0XE5gXfjv4EyA49KoHH66lPS4NC1Owmg898El6qp+jI3kZ39zGd48/AOB9UEubKv6
         DiYA==
X-Gm-Message-State: AOAM531QDvV00/Gqey5AUf8JAxSUjCSTTSjWw3FsovSV9QR0nFShuIDf
        Du3yxEXr5t0+VwaEvZrzxA==
X-Google-Smtp-Source: ABdhPJy5ALCdnBZecNdmijYEkMRQkwEv45r5BSaNA3d1OUSxcKJf8YTYoZjuJnrGo+aUm6BW1kfecQ==
X-Received: by 2002:aca:48c4:: with SMTP id v187mr13808805oia.37.1608052497495;
        Tue, 15 Dec 2020 09:14:57 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id c204sm4755034oob.44.2020.12.15.09.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 09:14:56 -0800 (PST)
Received: (nullmailer pid 4047644 invoked by uid 1000);
        Tue, 15 Dec 2020 17:14:55 -0000
Date:   Tue, 15 Dec 2020 11:14:55 -0600
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Jose Abreu <joabreu@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        devicetree@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        linux-stm32@st-md-mailman.stormreply.com,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>
Subject: Re: [PATCH 02/25] dt-bindings: net: dwmac: Extend number of PBL
 values
Message-ID: <20201215171455.GA4047592@robh.at.kernel.org>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
 <20201214091616.13545-3-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214091616.13545-3-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 12:15:52 +0300, Serge Semin wrote:
> In accordance with [1] the permitted PBL values can be set as one of
> [1, 2, 4, 8, 16, 32]. The rest of the values results in undefined
> behavior. At the same time some of the permitted values can be also
> invalid depending on the controller FIFOs size and the data bus width.
> Seeing due to having too many variables all the possible PBL property
> constraints can't be implemented in the bindings schema, let's extend
> the set of permitted PBL values to be as much as the configuration
> register supports leaving the undefined behaviour cases for developers
> to handle.
> 
> [1] DesignWare Cores Ethernet MAC Universal Databook, Revision 3.73a,
>     October 2013, p. 380.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
