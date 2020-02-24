Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0495816AF56
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgBXSjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:39:06 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34539 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbgBXSjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 13:39:05 -0500
Received: by mail-ot1-f67.google.com with SMTP id j16so9677530otl.1;
        Mon, 24 Feb 2020 10:39:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0sVqCGBrCoIT/RQRzW+a44Y2fkx7Y80/0sbQlmjQqQE=;
        b=TPUBQjR9sLlt8sAyvSEwrVNR1NsARotF3/WFjVbwZMdMLMT7kj+dHzCWHm4v7NgUDe
         /D0JhxiiGx+Wk3U4JUCYVGB79zqXjGWO6yZBY47whKmmX7scteQqRhzEiMstCxbkt68T
         GZUWpIa6Xcun7scX9IJAWaTsT9pkOtIKXJ6LnoiAh5U6jvOp3IgEiOsGQEsxfA7e2nsC
         xfca6ojlOJVHb++vaykvJhwyw1NX5Ec4U0AdDpQ1X+CzCeWt8Z2k67hiAjdaFuLcNoHT
         16U1GhnVGGUZdw4lDD/8BmSaAxDFt+V9+wc02gO7BCxrp61+daGojQBpva6ffSmF29tX
         KPqA==
X-Gm-Message-State: APjAAAUQ0gZs//Tc66+HgNQyamwMUrw+xhQJDHHKQ+m64ObT8H3EfYiR
        GZB+GNH1FiOw1nkQ32IGHA==
X-Google-Smtp-Source: APXvYqzo3boxjKAHif5705port4MZXNIX6PQpgO8wbr7VzV/NCax4EHVkwb3NqqPpOiIqNTnJAQ9aQ==
X-Received: by 2002:a9d:6196:: with SMTP id g22mr42337766otk.204.1582569543834;
        Mon, 24 Feb 2020 10:39:03 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q5sm4326203oia.21.2020.02.24.10.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 10:39:03 -0800 (PST)
Received: (nullmailer pid 1908 invoked by uid 1000);
        Mon, 24 Feb 2020 18:39:02 -0000
Date:   Mon, 24 Feb 2020 12:39:02 -0600
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
Subject: Re: [PATCH v6 2/2] Documentation: devictree: Add ipq806x mdio
 bindings
Message-ID: <20200224183902.GA1379@bogus>
References: <20200222161629.1862-1-ansuelsmth@gmail.com>
 <20200222161629.1862-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200222161629.1862-2-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Feb 2020 17:16:27 +0100, Ansuel Smith wrote:
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

See https://patchwork.ozlabs.org/patch/1242533
Please check and re-submit.
