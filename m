Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFC22DF846
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 05:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbgLUEdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 23:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgLUEdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 23:33:17 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509FCC061282;
        Sun, 20 Dec 2020 20:32:37 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id d203so10150366oia.0;
        Sun, 20 Dec 2020 20:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P86s/Ha/YvukIzig8L/uizkoYP89m06boY/wkDECHHw=;
        b=qOxLTtdg1Z9QHkgcaXkZ31LgxTn/+u9RG79CoNwHYX264vgSdR75IJtYocIrlcs1qw
         jqRWVK+tFvtBMg9Sxc4CYczd0QKo8kch9O6ciOwGL+fF2hqLG18oFLf3pgPf5eMQxb5N
         CZ4FQjBCkFqswZYpN0WomiQxPnm9U7/7rTZdSrF79RB6DMDnMC26ehE3xkTJSNoKA/Fb
         b/a+WCSw4s/AEDNcn/NsAhbUJz+0ORnDX9mXpXbm8Zi7QQJrh2A23+5J3GM3xkCoYYMz
         SR60bzDEN3keqoOhQ4r447zbB3ojyHXI1TjtLb8nkiF7YZ+DGL2krzf+U6H3Pgf22gR2
         Lctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P86s/Ha/YvukIzig8L/uizkoYP89m06boY/wkDECHHw=;
        b=QMbF2fm8JL2i4LZujdZCZg11FUuj/2uBIen23uakKAHlpJBkr+Caw17Ckzm6Ma3CtW
         JkYYSlG735CcDNCtm9knIXHDDac8jUSmHvIIdt0psRMwzyQUePMS9mL/4T51bsk7/a9l
         TnkZ3PVX3VJDwnkttVQE+K4UdHTeTBe0QhCjrHkvtm9cRDWzgFAQakk5EbVUaluL1SkO
         +35dm9mT6+wRO/pLmwfCbAxhKZddHsq1jQPy6p8FxOtVRtJh7Jzcs67t3f7+PfKJWbz3
         CoqS4gt2hF+Q1hi3RpSnpCW/I+OLYyos+5o03S8Gkbx9CoQHXfr/9JOvxci59ww3SfNT
         0s+Q==
X-Gm-Message-State: AOAM5317wSwo8ZujlDiIb4cpUNr9S1Ti8KIN8RJTOp0p1iNO4RSgkCmM
        axucWX0jZqttXviDPgQWjsvg77UbW/o=
X-Google-Smtp-Source: ABdhPJw1zpoMHRGk7WJ+p+wUTq3IkshPUpsTuIgwkywDeX1/T+HctdEPY1dkEdp3AeR3YrOLeb1o3Q==
X-Received: by 2002:aca:c582:: with SMTP id v124mr7470118oif.115.1608512140155;
        Sun, 20 Dec 2020 16:55:40 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:40bc:324a:3c8a:8077? ([2600:1700:dfe0:49f0:40bc:324a:3c8a:8077])
        by smtp.gmail.com with ESMTPSA id u141sm3262831oie.46.2020.12.20.16.55.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Dec 2020 16:55:38 -0800 (PST)
Subject: Re: [RFC PATCH v2 1/8] dt-bindings: net: sparx5: Add sparx5-switch
 bindings
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-2-steen.hegelund@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bd696641-49f1-6411-ef7d-68bf243c8cba@gmail.com>
Date:   Sun, 20 Dec 2020 16:55:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201217075134.919699-2-steen.hegelund@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2020 11:51 PM, Steen Hegelund wrote:
> Document the Sparx5 switch device driver bindings
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> ---

[snip]

> +          max-speed:
> +            maxItems: 1
> +            description: Bandwidth allocated to this port
> +
> +          phys:
> +            description: phandle of a Ethernet Serdes PHY
> +
> +          phy-handle:
> +            description: phandle of a Ethernet PHY
> +
> +          phy-mode:
> +            description: Interface between the serdes and the phy

Can you specify this pertains to the Serdes and Ethernet PHY?
-- 
Florian
