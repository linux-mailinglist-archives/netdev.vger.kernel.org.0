Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0CD42854C
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 04:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhJKCsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 22:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbhJKCsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 22:48:35 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE228C061745;
        Sun, 10 Oct 2021 19:46:35 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id u20-20020a9d7214000000b0054e170300adso19822145otj.13;
        Sun, 10 Oct 2021 19:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=w5gliKQWh26o2A1MzD6Ch0xfVSe1iKqgoS2ROQq+H+k=;
        b=Rw0MXrLvXfl8H8M22mmo4aFcbKV83vX2MD4OU4zrbzhRyKFRSPrpL2ZANMWy/2KWJa
         secFHYCYWEp2WJCToqSZwD4CGfF9as/rqH3RRMAftTt6ShDaDL0VisswIBPmGXQMHBNd
         XmlNmedksz098bV1hzDEAop0RqD1jK1GRQfJczROG3PU6+PCM8zTlr6j8yhxQv3sBju6
         AJzhK2s6ZQHBdKXd0+OkPXgiPmqyY9kEWj/ijWcRBNuiCgZyAryd6+vbMI8e/4nTtSFo
         W1nrAg078gWH4KGJ37CoLkKVYQaPKJHjoiBZ2h69uZ9j3g4Jm29he+4AFN3t4ozUb2jO
         Xm/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w5gliKQWh26o2A1MzD6Ch0xfVSe1iKqgoS2ROQq+H+k=;
        b=BaOFZEe7RMH+QfVa3vYzS7VKcTzzK8/Izv8bOs6mChoy26qZ2zd4sPXDwb+/owkBVT
         +9+uaZDe3nvvlw3Mv07H0E6aipwjJh/5Zw7CUKbYLMVDCNjXoJC8Jbb+MuBVxFeY0Us+
         5owZrAP/50AvC8/jrwBq+PJEMFnUVfDMTTPUJ/midS81xAvUw5tyhItLmr7VjZ6mi3h8
         0PrqD+GitL/frv4PF/rq/UnxsgLEbqmot770IxGOTJiNgP4ntolZqnmeNidfjs6R662j
         j/xcdR7Kit+y2k0+N8loitqYicARQ8HX5H+lrH6CrOwPpKcb9BziFNlMFF4eEOjkK7IP
         XjBw==
X-Gm-Message-State: AOAM533/muaN1jXhRI8Cu8AQ+Y4YlWy5K3XuBrPMOPX7n6RV4lX+Wo7K
        wySmIMP9wrHjKFGfS93PSAM=
X-Google-Smtp-Source: ABdhPJzQ9/0s8U2cYB5CHXYWn6C0jZMl6IoJeW+zsejUY7tTNA/rg89xqGxvlr5sSugt/Gk26MMApQ==
X-Received: by 2002:a05:6830:4488:: with SMTP id r8mr18792166otv.274.1633920395308;
        Sun, 10 Oct 2021 19:46:35 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:3cb6:937e:609b:a590? ([2600:1700:dfe0:49f0:3cb6:937e:609b:a590])
        by smtp.gmail.com with ESMTPSA id e76sm1480234ote.15.2021.10.10.19.46.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 19:46:34 -0700 (PDT)
Message-ID: <af433545-b5ce-053e-d381-ad11506a82e1@gmail.com>
Date:   Sun, 10 Oct 2021 19:46:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [net-next PATCH v5 08/14] net: dsa: qca8k: add explicit SGMII PLL
 enable
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211011013024.569-1-ansuelsmth@gmail.com>
 <20211011013024.569-9-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211011013024.569-9-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> Support enabling PLL on the SGMII CPU port. Some device require this
> special configuration or no traffic is transmitted and the switch
> doesn't work at all. A dedicated binding is added to the CPU node
> port to apply the correct reg on mac config.
> Fail to correctly configure sgmii with qca8327 switch and warn if pll is
> used on qca8337 with a revision greater than 1.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
