Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43A2432846
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 22:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhJRUSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 16:18:55 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:42954 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbhJRUSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 16:18:54 -0400
Received: by mail-oi1-f174.google.com with SMTP id g125so1402388oif.9;
        Mon, 18 Oct 2021 13:16:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B3ofZGSHkRjXt8sTVui29MqRkDDI8ENL5GudSngtntY=;
        b=rblQjeZHbAnIgAr0lHuvlrawSr4cvZLJ+3si6Y6UBz7PPXDWQbbm3Zd1yIgsdVW+SQ
         isYcNZiDPukCb8LIRNHnmWW0i5woSpgJhv6U+3j+9flo4uDOF2baqEIrSI2VYRE8JMDl
         vwEE6ktRD6ojEdUa5/WsBOMdSrkzP3Lm0zAj6fhvUlTdCI91IZUqf9yta65swMG1/JWa
         +oN02se3XW4KBFIggk6T2QiF+hcTDGqTpceB+EbwwWFLnabjTqEJ/nIRd5F8OBPYcW3i
         hJWGD9D6myPU/Lco04ui2mQLHVLLXQPKdGm0ClypApDRIfx1RbKBgQP6okaJBz4ayUhK
         LYVg==
X-Gm-Message-State: AOAM5327Slcq/5XWXm5rk9lWjA9PRzvZIjPEFRf989vTM6BwWs1QBcO/
        z/6w8mlnF2MZxY5osjZQ/w==
X-Google-Smtp-Source: ABdhPJwbAnZ8zZiDRoIazilmXevRmlwRyalpPgsfo50Hhks14QzNHMHyg0wLo1JxqSGRvH04XxSMmg==
X-Received: by 2002:a54:4f1d:: with SMTP id e29mr818543oiy.179.1634588202163;
        Mon, 18 Oct 2021 13:16:42 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id w93sm3183833otb.78.2021.10.18.13.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 13:16:41 -0700 (PDT)
Received: (nullmailer pid 2882938 invoked by uid 1000);
        Mon, 18 Oct 2021 20:16:40 -0000
Date:   Mon, 18 Oct 2021 15:16:40 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Greer <mgreer@animalcreek.com>, None@robh.at.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-nfc@lists.01.org,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 4/8] dt-bindings: nfc: st,st21nfca: convert to dtschema
Message-ID: <YW3WKMpCW11cBNCV@robh.at.kernel.org>
References: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
 <20211011073934.34340-5-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011073934.34340-5-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 09:39:30 +0200, Krzysztof Kozlowski wrote:
> Convert the ST ST21NFCA NFC controller to DT schema format.
> 
> Changes during bindings conversion:
> 1. Add a new required "interrupts" property, because it was missing in
>    the old bindings by mistake.
> 2. Drop the "clock-frequency" property during conversion because it is a
>    property of I2C bus controller, not I2C slave device.  It was also
>    never used by the driver.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../bindings/net/nfc/st,st21nfca.yaml         | 64 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/st21nfca.txt  | 37 -----------
>  2 files changed, 64 insertions(+), 37 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/st,st21nfca.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/st21nfca.txt
> 

Applied, thanks!
