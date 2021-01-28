Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD162307D33
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 18:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhA1R5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 12:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbhA1R4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 12:56:43 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE16AC061573;
        Thu, 28 Jan 2021 09:56:02 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id e9so4787198pjj.0;
        Thu, 28 Jan 2021 09:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XEAhNwvhOy99YG1NPFKUS0rOYXIOOpBLQOD+m3w1f3c=;
        b=cTKFrwF8XORNURr07WVV1buCxgftdPZ2g046SmCit40a6/gym7UHvMHlXvASA03q3y
         Qo79EEtb+tm32WkNTOSikvztvJyIi8IZNLdZsabCnhBPPsrINsWDOIF89v+uhhMA3BSO
         sUG8PDT15rHHB8/HitXLtU3WX9/OjODE0YOyk0MtTw++SakPVK5jU7OcXFBAtFkmh6eB
         w3u4NOg3k4Btlk0dzbvgy3o/pE/F4XL9hl6qbLqx0LJSMNVkzkwbarwqP/7HDYbplpyp
         og0OQ1wrseH3QWHuMLfDVCkwQt1iqRhfN5hLzSQkP/4aNi9AR9XZwBsdAKzd9VazqZ6W
         YClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XEAhNwvhOy99YG1NPFKUS0rOYXIOOpBLQOD+m3w1f3c=;
        b=kO5Kjj/ST19Pps+pW1kc/TVGkC5u53pkykDuWaihA11oWKVbHSjv71p05+wWGX4brf
         8kyUlr3BC66MmHG0odwEygz9b/p5yu2JVo47Zhmz70cs9MAyhDZuXksr1Le+0hJB5so6
         h1oJvD1cEePmZJ9C+2V44K57YNT4LrGmz34JTv4sgKC4jJCQQN9u1ce+qFPQsUiPcKto
         32M6UZXIqWl2oW8Ti1mTEd/r192eWd3ysbkpMtKq/HdDbdVfo6emUYdrL92KmmePiNOJ
         mCZQ2O1LTMfI4rMOE9mJQ1ZgvdqO5JTOxq0UliTwqGJ0Hv7gjWDq9sAclZruSg67CEnP
         fsYQ==
X-Gm-Message-State: AOAM533dy1za8N7oPhqNP/dhfvDewGioynUijKtxY3ONbnBYdB45zqKN
        llaHdSfKLy7OfvClXYYfPNnIRqFZpW8=
X-Google-Smtp-Source: ABdhPJwmQtSHrncQmDN0brZmJwNqS7zB9/EvCs4Rde0QeTTpLpah/rtc14hf+okpYDi+SYAb9W5L7w==
X-Received: by 2002:a17:90a:df0c:: with SMTP id gp12mr532293pjb.3.1611856561972;
        Thu, 28 Jan 2021 09:56:01 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p13sm5857736pju.20.2021.01.28.09.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:56:01 -0800 (PST)
Subject: Re: [PATCH net-next 0/8] net: dsa: microchip: DSA driver support for
 LAN937x switch
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        andrew@lunn.ch, olteanv@gmail.com, netdev@vger.kernel.org,
        robh+dt@kernel.org
Cc:     kuba@kernel.org, vivien.didelot@gmail.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bb729a8b-0ea1-e05d-f410-ed049e793d04@gmail.com>
Date:   Thu, 28 Jan 2021 09:55:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2021 10:41 PM, Prasanna Vengateshan wrote:
> LAN937x is a Multi-Port 100BASE-T1 Ethernet Physical Layer switch 
> compliant with the IEEE 802.3bw-2015 specification. The device 
> provides 100 Mbit/s transmit and receive capability over a single
> Unshielded Twisted Pair (UTP) cable. LAN937x is successive revision
> of KSZ series switch. This series of patches provide the DSA driver 
> support for Microchip LAN937X switch and it configures through 
> SPI interface.
> 
> This driver shares some of the functions from KSZ common
> layer.
> 
> The LAN937x switch series family consists of following SKUs:
> LAN9370:
>   - 4 T1 Phys
>   - 1 RGMII port
> LAN9371:
>   - 3 T1 Phys & 1 TX Phy
>   - 2 RGMII ports
> LAN9372:
>   - 5 T1 Phys & 1 TX Phy
>   - 2 RGMII ports
> LAN9373:
>   - 5 T1 Phys
>   - 2 RGMII & 1 SGMII port
> LAN9374:
>   - 6 T1 Phys
>   - 2 RGMII ports
> 
> More support will be added at a later stage.

It is great to see a new switch from Microchip being submitted for
review. One thing that has bothered me as a DSA maintainer before though
is that we have seen Microchip contribute new DSA drivers which are
always welcome, however the maintenance and bug fixing of these drivers
was spotty, thus leading to external contributors to take on the tasks
of fixing bugs. Do you have a stronger commitment now to stay involved
with reviewing/fixing bugs affecting Microchip DSA drivers and to a
larger extent the framework itself?

Could you also feed back to your hardware organization to settle on a
tag format that is not a snowflake? Almost *every* switch you have has a
different tagging format, this is absurd. All other vendors in tree have
been able to settle on at most 2 or 3 different tagging formats over
their switching product life span (for some vendors this dates back 20
years ago).

I will provide a more detailed review later on.

> 
> Prasanna Vengateshan (8):
>   dt-bindings: net: dsa: dt bindings for microchip lan937x
>   net: dsa: microchip: add tag handling for Microchip LAN937x
>   net: dsa: microchip: add DSA support for microchip lan937x
>   net: dsa: microchip: add support for phylink management
>   net: dsa: microchip: add support for ethtool port counters
>   net: dsa: microchip: add support for port mirror operations
>   net: dsa: microchip: add support for fdb and mdb management
>   net: dsa: microchip: add support for vlan operations
> 
>  .../bindings/net/dsa/microchip,lan937x.yaml   |  115 ++
>  MAINTAINERS                                   |    1 +
>  drivers/net/dsa/microchip/Kconfig             |   12 +
>  drivers/net/dsa/microchip/Makefile            |    5 +
>  drivers/net/dsa/microchip/ksz_common.h        |    1 +
>  drivers/net/dsa/microchip/lan937x_dev.c       |  895 ++++++++++++++
>  drivers/net/dsa/microchip/lan937x_dev.h       |   79 ++
>  drivers/net/dsa/microchip/lan937x_main.c      | 1037 +++++++++++++++++
>  drivers/net/dsa/microchip/lan937x_reg.h       |  955 +++++++++++++++
>  drivers/net/dsa/microchip/lan937x_spi.c       |  104 ++
>  include/net/dsa.h                             |    2 +
>  net/dsa/Kconfig                               |    4 +-
>  net/dsa/tag_ksz.c                             |   74 ++
>  13 files changed, 3282 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
>  create mode 100644 drivers/net/dsa/microchip/lan937x_dev.c
>  create mode 100644 drivers/net/dsa/microchip/lan937x_dev.h
>  create mode 100644 drivers/net/dsa/microchip/lan937x_main.c
>  create mode 100644 drivers/net/dsa/microchip/lan937x_reg.h
>  create mode 100644 drivers/net/dsa/microchip/lan937x_spi.c
> 

-- 
Florian
