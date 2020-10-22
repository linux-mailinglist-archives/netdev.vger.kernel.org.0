Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17182958A7
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 08:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504581AbgJVGzs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 02:55:48 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33012 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411545AbgJVGzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 02:55:47 -0400
Received: by mail-ed1-f67.google.com with SMTP id w23so673889edl.0;
        Wed, 21 Oct 2020 23:55:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wMeB1zJzZMK8x7XA1QSAy+WdSIpZ6mUMkpBppzeyvnw=;
        b=YUB39IHhYcaI2qkgIOOKfF/XmPoHGFfS0TeVQ5CYM8KIr46Hlm6BYTmEPtnTVBBOrf
         469ysRGQNWLHxg8rIUW1IeGJqTlAjNz2HvPvi2IR5C3t9/YhO9/h5Hx/1ylKO159eTCr
         4b4fBYw8GzF8SZdauEty6jU6JheOV7S910v2N/jowVaI98dguhBd1Ash0Abm6wMhgQ4P
         SHmy01vlio0jOOpGVpmsS1JNZki5Nwdp2YJDo335mquEmwCe2XmAwaQ+B04yMylEJdo2
         ujecThgzXFV2/GJWkDRou9vq6DBDohQwgz+KF6whTYG7lvNpdBT3GegKCCRFhRbJCxEd
         N4eg==
X-Gm-Message-State: AOAM530Y8/lwqUkAA/eOTLhjrtNVz5a8k8EG5d8szMXRFyChO+5z/4OE
        8FtrIPF1v22yHJQaH1YQBvM=
X-Google-Smtp-Source: ABdhPJygfj7Hlq2E4HbV0n7CfCdPnc4i/J7eKS1StJBSG5I6GXjoEvLuS0tOu+gGxnqqzYGmz4+Zqg==
X-Received: by 2002:aa7:c98f:: with SMTP id c15mr973061edt.200.1603349746176;
        Wed, 21 Oct 2020 23:55:46 -0700 (PDT)
Received: from kozik-lap ([194.230.155.171])
        by smtp.googlemail.com with ESMTPSA id e7sm303568ejm.4.2020.10.21.23.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 23:55:45 -0700 (PDT)
Date:   Thu, 22 Oct 2020 08:55:42 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3 2/5] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Message-ID: <20201022065542.GB3829@kozik-lap>
References: <20201021214910.20001-1-l.stelmach@samsung.com>
 <CGME20201021214933eucas1p152c8fc594793aca56a1cbf008f8415a4@eucas1p1.samsung.com>
 <20201021214910.20001-3-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201021214910.20001-3-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 11:49:07PM +0200, Łukasz Stelmach wrote:
> Add bindings for AX88796C SPI Ethernet Adapter.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  .../bindings/net/asix,ax88796c.yaml           | 69 +++++++++++++++++++
>  1 file changed, 69 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c.yaml
> 

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
