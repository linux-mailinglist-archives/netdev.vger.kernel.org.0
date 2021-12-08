Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741E046DC76
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbhLHTwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:52:24 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:46757 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbhLHTwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:52:24 -0500
Received: by mail-oi1-f180.google.com with SMTP id s139so5462650oie.13;
        Wed, 08 Dec 2021 11:48:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DNKlr97kRI/6nhVOG+e5Z+GHjIHEGKClnCRcCNNbhUE=;
        b=ey2vuob1C+2pW5E6Rvce9YTKCQWyxoG+82kH8VdLm637fWN79s/ysUDlYRsbImmi/n
         lNpV9NEDcquNo+iwCH8siJcawHRg9gOyZMByw53Wsq6AoOxNybix+/EaGIGf20ItpyMv
         XrkTLo/GhnVXvEPVTXCzh14qvcrsY8Cx803n2Om5QlPo8fslaCIeG6jUK5pA88uvvikA
         Hh+MzsaIL5ZSOvEVydiOezLNxArBYp2fal/1lhzI+NqhOiZnBNY25larNYepWM3bfYhB
         XN75i3NjsWSRUFmdDmH2mAAEotRN3Dw/eAU3Jm5TSoFkIeahKR2rxaSyyWtdJUZUgO3n
         aIdQ==
X-Gm-Message-State: AOAM5334k9dLIsll6ZmlfSUUprbwchJ+NGwPmKYuuETCR5Vh79ZtQiTv
        OpSNbKZk8JEO3NvSSQp5Lw==
X-Google-Smtp-Source: ABdhPJzeZNFK0Xcs0RsDaTj/9muqeY/qMWnlugx62E78/SPVgs6XDFlLG9YMlKxL4JWye14Zc2q3eQ==
X-Received: by 2002:a05:6808:13d5:: with SMTP id d21mr1446267oiw.175.1638992931717;
        Wed, 08 Dec 2021 11:48:51 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id g24sm642533oti.19.2021.12.08.11.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:48:51 -0800 (PST)
Received: (nullmailer pid 256083 invoked by uid 1000);
        Wed, 08 Dec 2021 19:48:49 -0000
Date:   Wed, 8 Dec 2021 13:48:49 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vinod Koul <vkoul@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Scott Branden <sbranden@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>, linux-kernel@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        Ray Jui <rjui@broadcom.com>
Subject: Re: [PATCH v3 7/8] dt-bindings: phy: Convert Northstar 2 PCIe PHY to
 YAML
Message-ID: <YbEMIQVVr0rod4c+@robh.at.kernel.org>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
 <20211206180049.2086907-8-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206180049.2086907-8-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 06 Dec 2021 10:00:48 -0800, Florian Fainelli wrote:
> Convert the Broadcom Northstar 2 PCIe PHY Device Tree binding to YAML
> and rename it accordingly in the process since it had nothing to do with
> a MDIO mux on the PCI(e) bus. This is a pre-requisite to updating
> another binding file to YAML.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../bindings/phy/brcm,mdio-mux-bus-pci.txt    | 27 ------------
>  .../bindings/phy/brcm,ns2-pcie-phy.yaml       | 41 +++++++++++++++++++
>  2 files changed, 41 insertions(+), 27 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/phy/brcm,mdio-mux-bus-pci.txt
>  create mode 100644 Documentation/devicetree/bindings/phy/brcm,ns2-pcie-phy.yaml
> 

Applied, thanks!
