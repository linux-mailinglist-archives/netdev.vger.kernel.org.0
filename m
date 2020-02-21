Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB6516816A
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 16:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgBUPX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 10:23:27 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35049 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgBUPX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 10:23:26 -0500
Received: by mail-oi1-f196.google.com with SMTP id b18so1916501oie.2;
        Fri, 21 Feb 2020 07:23:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gTGq4yWgJFhGViZ4fBiXU+ZAKZhYnnp0hu1ty+BdHro=;
        b=Y8WwJEIyz37oZEmo04gfk1wOsEAdjw/qEhMeZViefKY3VD95CtK35RFQzLQHZyAZNT
         ClX8AeqD7yhRR1IEZcrOQ+oO64uatq6tulKl2fkctz1Iy9itVZem6TVuHI/tzN5a/gIZ
         uBgn1OdAoji8QN/Z5/E5CVe7qCF0B9mF3usIPpVbb9+hgAou9pVCTwYGaFa+LOBFyh/s
         HAKhcQ9it1nMSi+l1C5RdTrTPOgbnTqxdEIjJ/DvtVUkAu5mA9SV8lLdUZDTNIuUlwuU
         OklYj/If9c0TyULnpNEVRogBN7Nu/ojmGM2kspiBaB4UroN+m8KTEc+Lk1x9U8kDCRcE
         DMUQ==
X-Gm-Message-State: APjAAAUcgKpz/O5lUvKSYxWjYYbdRtif/yyCaIJQKUMHwyX1JAsEuMBP
        TMFRE6rABmIs4xgY5+idEW1d//w=
X-Google-Smtp-Source: APXvYqwIL/Ef3nIGebbSsg4aoz2UkM9iIu6S2SYfpyWp9RVPHnG6sMz57whuohiAgwNuQK/hxmBpvw==
X-Received: by 2002:a05:6808:64d:: with SMTP id z13mr2422401oih.104.1582298605660;
        Fri, 21 Feb 2020 07:23:25 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id e21sm994272oib.16.2020.02.21.07.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 07:23:24 -0800 (PST)
Received: (nullmailer pid 30615 invoked by uid 1000);
        Fri, 21 Feb 2020 15:23:23 -0000
Date:   Fri, 21 Feb 2020 09:23:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] Documentation: devictree: Add ipq806x mdio
 bindings
Message-ID: <20200221152323.GA29820@bogus>
References: <20200220232624.7001-1-ansuelsmth@gmail.com>
 <20200220232624.7001-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220232624.7001-2-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Feb 2020 00:26:22 +0100, Ansuel Smith wrote:
> Add documentations for ipq806x mdio driver.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  .../bindings/net/qcom,ipq8064-mdio.yaml       | 55 +++++++++++++++++++
>  1 file changed, 55 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

Documentation/devicetree/bindings/display/simple-framebuffer.example.dts:21.16-37.11: Warning (chosen_node_is_root): /example-0/chosen: chosen node must be at root node
Error: Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.example.dts:23.28-29 syntax error
FATAL ERROR: Unable to parse input tree
scripts/Makefile.lib:300: recipe for target 'Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.example.dt.yaml' failed
make[1]: *** [Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.example.dt.yaml] Error 1
Makefile:1263: recipe for target 'dt_binding_check' failed
make: *** [dt_binding_check] Error 2

See https://patchwork.ozlabs.org/patch/1241711
Please check and re-submit.
