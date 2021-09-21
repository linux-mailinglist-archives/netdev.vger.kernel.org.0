Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6091A413C0A
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 23:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbhIUVK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 17:10:58 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:42819 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbhIUVK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 17:10:56 -0400
Received: by mail-oi1-f174.google.com with SMTP id x124so1105436oix.9;
        Tue, 21 Sep 2021 14:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iUEJN9LI7ZUf4DkkdwNHp5jZikiF3n0DaJFJVSMRf1Q=;
        b=ozcY3s6LHfomknzFoL7yH9eHMR5JRWTdtbv2rUXg8xe7TTcldWXIn/wFiLgNOe5BdU
         FAPUi3IpU3YcsLCOcb/5JZ9LuGr9ku2Mv8uCrlpwuFUFctY9v6nu5Eqhz1g6vLn6O0BL
         c+uyu7bprfKO5emc2DrzKBMFwvTDSHkPTEAJHg90CyveQQ7EDVThPE4OSkaKTwGM96Au
         W3+dAHxk+k1BDYd4HjRG37vcM/RCW7NZi0NikAKA+juD/QxgY0cXixSES4+6DwL5igde
         vLP8OZNkKbScsXIUshtTpxRtrzQVoQ1IFYfAkQXFM+cdsbERyWDtjkkM17B46j3qVaRQ
         nn7Q==
X-Gm-Message-State: AOAM5300+xweTBC8lusWfKwlU0PXpEVOExM9er78vEjpud70BTGTJhzQ
        qHfBK1TZybOZ5CIUy8DbAA==
X-Google-Smtp-Source: ABdhPJw8ruhguKQ+izbnSXb2KBujCQjD+IVfNJwsr/OndGaFcg8Lkl4J8hq+AAf1uln3DxG4v3NATA==
X-Received: by 2002:a54:4d88:: with SMTP id y8mr5197290oix.154.1632258567681;
        Tue, 21 Sep 2021 14:09:27 -0700 (PDT)
Received: from robh.at.kernel.org (rrcs-192-154-179-36.sw.biz.rr.com. [192.154.179.36])
        by smtp.gmail.com with ESMTPSA id r64sm44778oib.14.2021.09.21.14.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 14:09:27 -0700 (PDT)
Received: (nullmailer pid 3329042 invoked by uid 1000);
        Tue, 21 Sep 2021 21:09:26 -0000
Date:   Tue, 21 Sep 2021 16:09:26 -0500
From:   Rob Herring <robh@kernel.org>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        jimmy.shen@vertexcom.com, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC 2/3] dt-bindings: net: add Vertexcom MSE102x support
Message-ID: <YUpKBt3ewF2c3rQZ@robh.at.kernel.org>
References: <20210914151717.12232-1-stefan.wahren@i2se.com>
 <20210914151717.12232-3-stefan.wahren@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914151717.12232-3-stefan.wahren@i2se.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Sep 2021 17:17:16 +0200, Stefan Wahren wrote:
> Add devicetree binding for the Vertexcom MSE102x Homeplug GreenPHY chip
> as SPI device.
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>  .../bindings/net/vertexcom-mse102x.yaml       | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
