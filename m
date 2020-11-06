Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750382A9E32
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 20:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgKFTlV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Nov 2020 14:41:21 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40434 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727356AbgKFTlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 14:41:20 -0500
Received: by mail-ed1-f68.google.com with SMTP id p93so2429598edd.7;
        Fri, 06 Nov 2020 11:41:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9IRW4DA1TwILAlIYYceJA/7ciuzQ0l6aR+g7b//DWDQ=;
        b=ZWwaPTFE85fRaNqv01fi8vEl6GSRE1iG6JhqFrw9m1OWZ4ZPEko5Yam7GsxjG9SWMq
         I/x42oaEVBlYbokyIcv5Ap3QZvywPCzUeDGddobNUuKq7ugsa2RdggV+Vyx8e+ptOw4f
         TEBs+BP6DpYbcfBb4igqk79GSlrNr5QUsvyZ5vvMzqgpcaScuXdXSCTx8sFj6KRTo1jx
         5BG6iUtb5nf+VMPHltIjw7UjsAZWJGwwUVnTFo794icmvYiMskCrVbelhRkSE62+6yhk
         XRY3pYJI9eRp0MV5Xv17jNpeuz1Z8b7sMtcsm74bO1p5J1s2s6B8XFGWkiOYta4n3lHL
         iDGw==
X-Gm-Message-State: AOAM532sD+4/gz1d3skswC0zz1pXTT4/oU953XaEnA9Uqlhp2WSnh6p9
        nQcNmUdXinky9RswoNb6ggU=
X-Google-Smtp-Source: ABdhPJwiGyC3gWh8eObl2op5BlCCSbuYTWiXUtF+TjJmb7zsVdVQq2CwdB3E4BRR7ATrfnaux70rYA==
X-Received: by 2002:a50:e3ca:: with SMTP id c10mr3651823edm.222.1604691677522;
        Fri, 06 Nov 2020 11:41:17 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id a9sm1749586eds.50.2020.11.06.11.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 11:41:16 -0800 (PST)
Date:   Fri, 6 Nov 2020 20:41:14 +0100
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
Subject: Re: [PATCH v5 2/5] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Message-ID: <20201106194114.GC329187@kozik-lap>
References: <20201103151536.26472-1-l.stelmach@samsung.com>
 <CGME20201103151539eucas1p234b5fe43c6f26272560a7d2ac791202f@eucas1p2.samsung.com>
 <20201103151536.26472-3-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201103151536.26472-3-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 04:15:33PM +0100, Łukasz Stelmach wrote:
> Add bindings for AX88796C SPI Ethernet Adapter.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  .../bindings/net/asix,ax88796c.yaml           | 73 +++++++++++++++++++
>  1 file changed, 73 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c.yaml
> 

I assume bindings will go with the driver to the net. I applied only
ARM-specific bits.
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
