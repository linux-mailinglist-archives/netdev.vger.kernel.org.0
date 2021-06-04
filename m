Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C2839BD77
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFDQqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:46:18 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:50897 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhFDQqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 12:46:18 -0400
Received: by mail-pj1-f51.google.com with SMTP id i22so5901159pju.0;
        Fri, 04 Jun 2021 09:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q/lW+cvfow4eUwJhwGA4ALMndt92irIdtpZvGIsvdR8=;
        b=mYRqG2cbKJq/qQpEPGHzswC4C9mZ6xVE2WF/RxiJQhhdaGhP35lNZWijbyk3FURUIl
         P3fyUmPTcXftIOK89CByHcOU0Q/FU0XCRAXLtajYgZPOTakBgO4zXT5Gjl9K6B2cdClH
         ckNv9iCPdBo/hvmxnKn2aIzEOYS7ldUxN5QBuGR7Aa3Ib9WTFEhEluoYMMu6pM+5RFeI
         JCFHOSd4+6VnQ9CR7iYVVoIVO6OlgIhYgrR2QzYGzWfKXtINFL4FrFnAImIbgbRg3ZmB
         IWhtPxjXvXkRlIdnPu5sQiMeTihOHpEIkPDEDVsnkhKb5IWOX2TnzucW7etWYLrNv+c2
         jsfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q/lW+cvfow4eUwJhwGA4ALMndt92irIdtpZvGIsvdR8=;
        b=MObaLdq6kjIDTk5qAY7fW2tDEf4e8H5RUrwi4AvW9fM8sni7ZOzUhfJHaNuxrWftbN
         NwuMaz2wcRKnL9/JMuOvB2XL5GO6662nGjPxFpe/NVBu8OZUgwGOtKO/OxoPKf24ASG9
         CV6EcZr3xnonQ13NyKX8oK8Wo8Hq64sKiqD6eYBSo60SQ+pP6LURIbZZtV4K5pIBIIJm
         E/TwYjm25mvRc/dRGcJ3A6wbanXD9qtXsdtQ2yyLHPcMLwvFUA8T6TkOfW96B7RJj5eV
         q1duvooEDRLFX3bb+nPIhio3O0r4nV8fc6tijOf4vpPivuMISJfm3AfUVdekkUWVnAHu
         sMsw==
X-Gm-Message-State: AOAM532XeaB/ONBX0YkNzzjSjx7aBM4CGVDPsEw2nA3jaPRuRJnA/1QA
        xttRy+FMYJz/FRkfA42r8LA=
X-Google-Smtp-Source: ABdhPJxNjWVvuAvrhizjWqdWjsNNClhFrPCk6J6ETB2P4gNKDOlmps2EmQKHvK1r/gGIsdLlYG+xgg==
X-Received: by 2002:a17:902:cec3:b029:10d:22fa:183c with SMTP id d3-20020a170902cec3b029010d22fa183cmr5234564plg.53.1622824999980;
        Fri, 04 Jun 2021 09:43:19 -0700 (PDT)
Received: from [10.230.24.159] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id p65sm2166202pfb.62.2021.06.04.09.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 09:43:19 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 1/4] net: phy: introduce
 PHY_INTERFACE_MODE_REVRMII
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210604140151.2885611-1-olteanv@gmail.com>
 <20210604140151.2885611-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <60ff376d-9f28-52fb-8d6d-5e3966258de6@gmail.com>
Date:   Fri, 4 Jun 2021 09:43:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210604140151.2885611-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2021 7:01 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The "reverse RMII" protocol name is a personal invention, derived from
> "reverse MII".
> 
> Just like MII, RMII is an asymmetric protocol in that a PHY behaves
> differently than a MAC. In the case of RMII, for example:
> - the 50 MHz clock signals are either driven by the MAC or by an
>   external oscillator (but never by the PHY).
> - the PHY can transmit extra in-band control symbols via RXD[1:0] which
>   the MAC is supposed to understand, but a PHY isn't.
> 
> The "reverse MII" protocol is not standardized either, except for this
> web document:
> https://www.eetimes.com/reverse-media-independent-interface-revmii-block-architecture/#
> 
> In short, it means that the Ethernet controller speaks the 4-bit data
> parallel protocol from the perspective of a PHY (it acts like a PHY).
> This might mean that it implements clause 22 compatible registers,
> although that is optional - the important bit is that its pins can be
> connected to an MII MAC and it will 'just work'.
> 
> In this discussion thread:
> https://lore.kernel.org/netdev/20210201214515.cx6ivvme2tlquge2@skbuf/
> 
> we agreed that it would be an abuse of terms to use the "RevMII" name
> for anything than the 4-bit parallel MII protocol. But since all the
> same concepts can be applied to the 2-bit Reduced MII protocol as well,
> here we are introducing a "Reverse RMII" protocol. This means: "behave
> like an RMII PHY".
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
