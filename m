Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2956D4AA2E3
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346016AbiBDWMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:12:03 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:40642 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241261AbiBDWMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:12:02 -0500
Received: by mail-oi1-f180.google.com with SMTP id q8so10135637oiw.7;
        Fri, 04 Feb 2022 14:12:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dzMRt27+2vZ9lhhwIAfcKkpOyX3qxt1HYwD/zFIRG94=;
        b=7iRKFYj6DpsV7SeFzCeq98EfqA+MhGFiCOULsv8xUlggdvSEzQjiYk2PTpygLaT6+g
         re3pzyNKovgf+X4Q15H1h2EcINrERzwwhw6tlUysBVM8z4mcBF43KLmCSIbzw/jsrgB6
         Xmz8y8ukFTBAPoP8ixL7nrYz2llx3JW/IysfuW6stMtX56hsHG9sgaaj92HRxuBExVKk
         zMoUyFr8wd/25CHEuzR8YRix2EtsmCq8bMDKZqWc1/Xyt0WuDy7Qjd+Zz4ug4ylc9dwr
         c4nZZLXwovDj+IEnqZ5ESrPF/z9H9obwiPIFjvRo8QQ1f3AX//dcEH0jac8HPB2+OklB
         3gAg==
X-Gm-Message-State: AOAM531HzP6JxqiebWveNxjag26tign/AiGfzH1up180lscDp1Za/UuN
        mJCT78+7xb7bQQ0SvIpcJ/t0LRG+eA==
X-Google-Smtp-Source: ABdhPJxcH2dzMaKW4bpCJiKR5cuCnvSkJiR/f39LsK134mXLcHKAiNSXG6FX38Yxos0H4l7vFqiQSg==
X-Received: by 2002:a05:6808:20a5:: with SMTP id s37mr557372oiw.30.1644012722052;
        Fri, 04 Feb 2022 14:12:02 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id t31sm1009104oaa.9.2022.02.04.14.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 14:12:00 -0800 (PST)
Received: (nullmailer pid 3272537 invoked by uid 1000);
        Fri, 04 Feb 2022 22:11:59 -0000
Date:   Fri, 4 Feb 2022 16:11:59 -0600
From:   Rob Herring <robh@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        Woojung.Huh@microchip.com, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org, olteanv@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, andrew@lunn.ch,
        robh+dt@kernel.org, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v7 net-next 01/10] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Message-ID: <Yf2krw1igf/qY3C/@robh.at.kernel.org>
References: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
 <20220204174500.72814-2-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204174500.72814-2-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Feb 2022 23:14:51 +0530, Prasanna Vengateshan wrote:
> Documentation in .yaml format and updates to the MAINTAINERS
> Also 'make dt_binding_check' is passed.
> 
> RGMII internal delay values for the mac is retrieved from
> rx-internal-delay-ps & tx-internal-delay-ps as per the feedback from
> v3 patch series.
> https://lore.kernel.org/netdev/20210802121550.gqgbipqdvp5x76ii@skbuf/
> 
> It supports only the delay value of 0ns and 2ns.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  .../bindings/net/dsa/microchip,lan937x.yaml   | 179 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 180 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
