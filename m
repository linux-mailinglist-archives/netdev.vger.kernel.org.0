Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9559A43283A
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 22:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhJRUSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 16:18:22 -0400
Received: from mail-oi1-f181.google.com ([209.85.167.181]:33490 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhJRUSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 16:18:21 -0400
Received: by mail-oi1-f181.google.com with SMTP id q129so1515349oib.0;
        Mon, 18 Oct 2021 13:16:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NRo22LFo/WXvedJBwhm1RlOO9t9Om9VBjDtWCnYL+pQ=;
        b=XgZfHmgvh6a3HiAVyfbP6Cp9Pwr8qh9fCYp+quT6JrqJpoEb0Fn3FZCVx6r8XqiemR
         wNKZ6xYmFXiY/EyXwYjDASo/Z4yHCrQL9eZBOFBSEmULLmITUDREHPWeJozSlpdJoryH
         dEel998xzeZRc1WPZHFdCTgDyzPtvnGGar4hGNad/KpSMw9vlik/dwAov8C0VETUAHx1
         cTR4A+0vnytfZI4d+sZlpbwViOpRO8eTvdAPvTXJ4R28X0caDQ/0M9XZhKPhGBj/MzEg
         IDTCTx89Ba9pHh4y6eCUF7sVO8pZ8iLQWNtCqAHzowtnT1Omvw2WUSHS9zuIC2g7VorN
         aGoQ==
X-Gm-Message-State: AOAM530zBUSMClo2nVV9jjgVowUNwtunylEkXLMmD4jcZBJOZ/uXeJCe
        ALMtaHREQQogZ43ZoLrvRg==
X-Google-Smtp-Source: ABdhPJza4vh1hi6FMnfaqBaUMGHH9v5mGdCwWTiURZwYkPO8rkG7Rj2fbGDDZWHLtB5Aji3j0xYFzA==
X-Received: by 2002:aca:5d07:: with SMTP id r7mr852788oib.138.1634588170027;
        Mon, 18 Oct 2021 13:16:10 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bk8sm2667606oib.57.2021.10.18.13.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 13:16:09 -0700 (PDT)
Received: (nullmailer pid 2881627 invoked by uid 1000);
        Mon, 18 Oct 2021 20:16:08 -0000
Date:   Mon, 18 Oct 2021 15:16:08 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, netdev@vger.kernel.org,
        None@robh.at.kernel.org,
        Charles Gorand <charles.gorand@effinnov.com>,
        linux-nfc@lists.01.org
Subject: Re: [PATCH v2 1/8] dt-bindings: nfc: nxp,nci: convert to dtschema
Message-ID: <YW3WCOqrSi5H5emB@robh.at.kernel.org>
References: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
 <20211011073934.34340-2-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011073934.34340-2-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 09:39:27 +0200, Krzysztof Kozlowski wrote:
> Convert the NXP NCI NFC controller to DT schema format.
> 
> Drop the "clock-frequency" property during conversion because it is a
> property of I2C bus controller, not I2C slave device.  It was also never
> used by the driver.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../devicetree/bindings/net/nfc/nxp,nci.yaml  | 57 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/nxp-nci.txt   | 33 -----------
>  MAINTAINERS                                   |  1 +
>  3 files changed, 58 insertions(+), 33 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
> 

Applied, thanks!
