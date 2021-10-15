Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCEE42F8D4
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 18:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241674AbhJOQzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 12:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237376AbhJOQzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 12:55:16 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC51C061570;
        Fri, 15 Oct 2021 09:53:10 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so3113413pjd.1;
        Fri, 15 Oct 2021 09:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y06AwVPF9wGy7ZjJQhPVlMY5dCrjrZo4wsT35dSuuis=;
        b=NTPb1Um5q8+eNvi484E+2Kxe5mpBncQXzmMJw9YUwHMruk6AW0hljl/FCcsJI4QXY1
         fzUp1pzFM4BK/qzCrq3KUDuXFbFRiQ+zY+Yhcyjw0QZRrvCICjS64MWwoNqs5p/4aNJC
         JVQAPbdrSnqkA35NwtF/EcGNvbp8e4AM0Pap6dyfu1WDTZjWP8biyW0MSROpopSkVKsG
         uAmzqevm7NjB1Ge3SB1fg3QJ3DOdw+XNu0UvUDOzjJdcHZgUDXr+4YG5pZRw0n+qIJtc
         /qnbekVzhe4gbBXOjc8lM6rq7OUy7avyatEzTnY1vM4k5nMl9G2jMLJjS7kprL5nlu1n
         76fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y06AwVPF9wGy7ZjJQhPVlMY5dCrjrZo4wsT35dSuuis=;
        b=T+YdFgAFtTH4kVUPgIDjAQn0RvggUbM1p+iUILlYXLaPT7hXhxwEy0371WPMNqhYCx
         dsPUkggd4af1CCxMAn02ICUicjBc8AYEejhNx4tYCv1weaLPPz7HpVQdS9IK+qtIMaPj
         F5CwFwKYW7DdR0VH1Qxe4IdMGmY2UjqZIoxf0i418J9LutbIiwAwyaaxxxEvytAB/Evd
         Zb+eBLYL0X2gEUrtAIQYJXIvw1pcz5JArhmOho2Ku2Lib1caCh/0St8IuMJMM3d1YcZ2
         r/wRkA2hFEA2G9lwocHJ7a1FuQl4mhl9N7/y/fq4IyckqISPtTGyFBPXCim6NFK2MtrZ
         ghVA==
X-Gm-Message-State: AOAM532U7yldnFHixGSPzTeGqK6dnHgoUcjFGzL3IZ9rr3CnfbKSWIAB
        EAiErh7trBo89iA4j/RAdTQ=
X-Google-Smtp-Source: ABdhPJwSBunU680FFsxAdzwM9PMw6szem6EvS9KaFeAMQixeIFY1x1N7ckNXeLuzhM/Z1ruycr5zwQ==
X-Received: by 2002:a17:90a:b391:: with SMTP id e17mr29179998pjr.137.1634316789907;
        Fri, 15 Oct 2021 09:53:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i5sm5115933pgo.36.2021.10.15.09.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 09:53:09 -0700 (PDT)
Subject: Re: [PATCH net-next 5/6] dt-bindings: net: dsa: sja1105: add
 {rx,tx}-internal-delay-ps
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
 <20211013222313.3767605-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a3f21c49-7d35-393d-9d2f-d1bad9201bc5@gmail.com>
Date:   Fri, 15 Oct 2021 09:53:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211013222313.3767605-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 3:23 PM, Vladimir Oltean wrote:
> Add a schema validator to nxp,sja1105.yaml and to dsa.yaml for explicit
> MAC-level RGMII delays. These properties must be per port and must be
> present only for a phy-mode that represents RGMII.
> 
> We tell dsa.yaml that these port properties might be present, we also
> define their valid values for SJA1105. We create a common definition for
> the RX and TX valid range, since it's quite a mouthful.
> 
> We also modify the example to include the explicit RGMII delay properties.
> On the fixed-link ports (in the example, port 4), having these explicit
> delays is actually mandatory, since with the new behavior, the driver
> shouts that it is interpreting what delays to apply based on phy-mode.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Even if you need to make yamllint happy
-- 
Florian
