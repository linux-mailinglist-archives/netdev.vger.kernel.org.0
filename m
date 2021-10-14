Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA16842D04C
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 04:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhJNCVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 22:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNCVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 22:21:37 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04D0C061570;
        Wed, 13 Oct 2021 19:19:32 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id l7so4245653qkk.0;
        Wed, 13 Oct 2021 19:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9bVClgIo/Rv4oIFZBJzM+cqCED+S4PcbmqzekG3DiuE=;
        b=VoTNdcpXW/d4yyVN3mB5QBO1+A9b3TZGkND7+6ODuyuVmjBUDcdh2VXxucF8URRtxN
         lexO6UP5LYPnxgX6JrYRPWQgpctRgtfFoTMm+7Na5HxZW2pqwF9BO/FjsFJcpGgncGIs
         5lnAj3WaRlFqYEbwM2zzWxnz6/jXkLm3S6T0exOKwXM+IzJK4Mrsr6G8bTgeGj/U33T4
         FZN12Flcj4IRChhF0qPcnaYf8uYB4KNim9HW/dDmfjKA1tTaE/ApWlH2apGhzkcM2AyP
         RqM7zftHy8yL+W55nJUhhnvMxyhJnj5HzWTznmIYhKhNxLyWhfAo8FDQZK8ctOLpkNmh
         w5OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9bVClgIo/Rv4oIFZBJzM+cqCED+S4PcbmqzekG3DiuE=;
        b=s/Q3Glop6W+SLRgy82Z+UPOb1Q8DFQiuWFa5d/ej9a++q9Yns0prL/G7ytclQYeoS3
         qSMwxmVWElfjERxXKGv+EF8+8qQEQI7P1atBvtgZNQKQecJ5U2pfh7moSEIw+CDnnzTL
         XaGBbmNFkEJ5Jh+acdVJT5S4UlAv7n/s9VquCcAlXBs5Vpjpd+3OKQWj/I4kiOP563u7
         txS5MzlF7KkpcYJ+0Rx1i/Hce6yvePt2W/2eY25Gw7B8agtqqv7PlaD6I5RJbdkjAms5
         XphoE5FO2YWwwx1dQMSCWYow2h+w8hlWkrDaGkXD2AgcczmoxuIIifO6rvOY8MvbHrg9
         yVwQ==
X-Gm-Message-State: AOAM532eQg29q1iKpRkGaGUqlNstJ2QOBznOY1RDcK+U8FiSlJnZIFmk
        Ji2X64k+l2RV3pmhrDkZIfw=
X-Google-Smtp-Source: ABdhPJxX5f9/kP6KlnDXzsddSnFsTfyBvVay0nzwqGYYICSmy0nSx1nL7cOrQUGnXdBYiApvlCOC6g==
X-Received: by 2002:a37:a444:: with SMTP id n65mr2490225qke.408.1634177971932;
        Wed, 13 Oct 2021 19:19:31 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:c875:f7ef:73a9:7098? ([2600:1700:dfe0:49f0:c875:f7ef:73a9:7098])
        by smtp.gmail.com with ESMTPSA id l3sm800392qkj.110.2021.10.13.19.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 19:19:31 -0700 (PDT)
Message-ID: <69ccdad2-abbf-b05f-128b-dfdda6797f38@gmail.com>
Date:   Wed, 13 Oct 2021 19:19:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 net-next 4/6] net: dsa: tag_rtl8_4: add realtek 8 byte
 protocol 4 tag
Content-Language: en-US
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211013145040.886956-1-alvin@pqrs.dk>
 <20211013145040.886956-5-alvin@pqrs.dk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211013145040.886956-5-alvin@pqrs.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/2021 7:50 AM, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> This commit implements a basic version of the 8 byte tag protocol used
> in the Realtek RTL8365MB-VC unmanaged switch, which carries with it a
> protocol version of 0x04.
> 
> The implementation itself only handles the parsing of the EtherType
> value and Realtek protocol version, together with the source or
> destination port fields. The rest is left unimplemented for now.
> 
> The tag format is described in a confidential document provided to my
> company by Realtek Semiconductor Corp. Permission has been granted by
> the vendor to publish this driver based on that material, together with
> an extract from the document describing the tag format and its fields.
> It is hoped that this will help future implementors who do not have
> access to the material but who wish to extend the functionality of
> drivers for chips which use this protocol.
> 
> In addition, two possible values of the REASON field are specified,
> based on experiments on my end. Realtek does not specify what value this
> field can take.
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
