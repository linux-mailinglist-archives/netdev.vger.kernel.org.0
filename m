Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701012DF872
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 05:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgLUE4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 23:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgLUE4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 23:56:37 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3057BC061282;
        Sun, 20 Dec 2020 20:55:57 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id u203so7796756ybb.2;
        Sun, 20 Dec 2020 20:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KwY0XM1SVHhLT86f5kDOR74nVjv5wsomeVmy0QseN00=;
        b=r2uHQpM04f8kPEOvDlqzxdjnEKx1FbM0mqQqP1+SwGCKXLxreb6RNnLUGf56RkrmMb
         m2fEyfAKClnG+LlMEsiP5sdt/X7Uk9E/DfmUl90FosP30lAGt8Qgz/58l3XEiHyjrPqF
         9Sa9vGYHZnTZfZzFvr2eIi6QNfbact15AHwRtmNMPoOeS8DVuGeZxyYPhqputkLOvqQD
         OCbT7geS11HGeGDI0A/7B9VXQXbKHpuqiNz+9tlFIud34rL3ocBEdRr/1UUNkYgCz4gw
         P7HsGe+5ezOzCjnBw9Ce6nA5vqlQ7fhNqDnWLuu+QDQ6+Y+Q+tTE8qIumjrbyF9nNmbf
         Cj8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KwY0XM1SVHhLT86f5kDOR74nVjv5wsomeVmy0QseN00=;
        b=Bc7Wp13qwtMeJFwKKMJq9oTCOp1miTw5EDJthIAhMtZTkb/44juvxF+VwTH09fMrEl
         I3P7WP1yFhdHwaBw4NUOqXskaQs4vg9iCdCR9GfmuWvCBnOHBX4roalqddvcQrt1AWbK
         oulfdxh/BxhHq9WymfiRehPMH1DK58RRhQ9N7YvCt0M0ByCTT62ZTxRnt2PAGSsHgVCK
         L75RCOTAw1tFklnWMZ7PYJpzctbK2J97mQw4wN8FSOArah3C8CKVS66203uIdBsO0IIU
         9qdSUSYjVTgMZhPPRoUTQSxzFiWW+2xQw/pjDPW5FaGGjI/jsjwDvujirio04xAXLqLJ
         f7JQ==
X-Gm-Message-State: AOAM531tjgHi3BiJ0fGV1CT8YnKgVb58y8Hc/XhogbV3giwHmzJTtWx/
        WPLFIMrVTR8ybxxwD+MHaMRudIrO9vI=
X-Google-Smtp-Source: ABdhPJwsnX8rAsJLiC1Jc2yjYvb8qkwNddD2Bf8O9iasIyRLa7dYEvkpjkv4h6iPPtK3AcpIOGt+YA==
X-Received: by 2002:a4a:98e7:: with SMTP id b36mr9942038ooj.3.1608512342825;
        Sun, 20 Dec 2020 16:59:02 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:40bc:324a:3c8a:8077? ([2600:1700:dfe0:49f0:40bc:324a:3c8a:8077])
        by smtp.gmail.com with ESMTPSA id i24sm3437034oot.42.2020.12.20.16.59.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Dec 2020 16:59:01 -0800 (PST)
Subject: Re: [RFC PATCH v2 0/8] Adding the Sparx5 Switch Driver
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6645f038-7101-67e4-0843-35125f74597a@gmail.com>
Date:   Sun, 20 Dec 2020 16:58:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201217075134.919699-1-steen.hegelund@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2020 11:51 PM, Steen Hegelund wrote:
> This series provides the Microchip Sparx5 Switch Driver
> 
> The Sparx5 Carrier Ethernet and Industrial switch family delivers 64
> Ethernet ports and up to 200 Gbps of switching bandwidth.
> 
> It provides a rich set of Ethernet switching features such as hierarchical
> QoS, hardware-based OAM  and service activation testing, protection
> switching, IEEE 1588, and Synchronous Ethernet.
> 
> Using provider bridging (Q-in-Q) and MPLS/MPLS-TP technology, it delivers
> MEF CE
> 2.0 Ethernet virtual connections (EVCs) and features advanced TCAM
>   classification in both ingress and egress.
> 
> Per-EVC features include advanced L3-aware classification, a rich set of
> statistics, OAM for end-to-end performance monitoring, and dual-rate
> policing and shaping.
> 
> Time sensitive networking (TSN) is supported through a comprehensive set of
> features including frame preemption, cut-through, frame replication and
> elimination for reliability, enhanced scheduling: credit-based shaping,
> time-aware shaping, cyclic queuing, and forwarding, and per-stream policing
> and filtering.
> 
> Together with IEEE 1588 and IEEE 802.1AS support, this guarantees
> low-latency deterministic networking for Fronthaul, Carrier, and Industrial
> Ethernet.
> 
> The Sparx5 switch family consists of following SKUs:
> 
> - VSC7546 Sparx5-64 up to 64 Gbps of bandwidth with the following primary
>   port configurations:
>   - 6 *10G
>   - 16 * 2.5G + 2 * 10G
>   - 24 * 1G + 4 * 10G
> 
> - VSC7549 Sparx5-90 up to 90 Gbps of bandwidth with the following primary
>   port configurations:
>   - 9 * 10G
>   - 16 * 2.5G + 4 * 10G
>   - 48 * 1G + 4 * 10G
> 
> - VSC7552 Sparx5-128 up to 128 Gbps of bandwidth with the following primary
>   port configurations:
>   - 12 * 10G
>   - 16 * 2.5G + 8 * 10G
>   - 48 * 1G + 8 * 10G
> 
> - VSC7556 Sparx5-160 up to 160 Gbps of bandwidth with the following primary
>   port configurations:
>   - 16 * 10G
>   - 10 * 10G + 2 * 25G
>   - 16 * 2.5G + 10 * 10G
>   - 48 * 1G + 10 * 10G
> 
> - VSC7558 Sparx5-200 up to 200 Gbps of bandwidth with the following primary
>   port configurations:
>   - 20 * 10G
>   - 8 * 25G
> 
> In addition, the device supports one 10/100/1000/2500/5000 Mbps
> SGMII/SerDes node processor interface (NPI) Ethernet port.
> 
> The Sparx5 support is developed on the PCB134 and PCB135 evaluation boards.
> 
> - PCB134 main networking features:
>   - 12x SFP+ front 10G module slots (connected to Sparx5 through SFI).
>   - 8x SFP28 front 25G module slots (connected to Sparx5 through SFI high
>     speed).
>   - Optional, one additional 10/100/1000BASE-T (RJ45) Ethernet port
>     (on-board VSC8211 PHY connected to Sparx5 through SGMII).
> 
> - PCB135 main networking features:
>   - 48x1G (10/100/1000M) RJ45 front ports using 12xVSC8514 QuadPHY’s each
>     connected to VSC7558 through QSGMII.
>   - 4x10G (1G/2.5G/5G/10G) RJ45 front ports using the AQR407 10G QuadPHY
>     each port connects to VSC7558 through SFI.
>   - 4x SFP28 25G module slots on back connected to VSC7558 through SFI high
>     speed.
>   - Optional, one additional 1G (10/100/1000M) RJ45 port using an on-board
>     VSC8211 PHY, which can be connected to VSC7558 NPI port through SGMII
>     using a loopback add-on PCB)
> 
> This series provides support for:
>   - SFPs and DAC cables via PHYLINK with a number of 5G, 10G and 25G
>     devices and media types.
>   - Port module configuration for 10M to 25G speeds with SGMII, QSGMII,
>     1000BASEX, 2500BASEX and 10GBASER as appropriate for these modes.
>   - SerDes configuration via the Sparx5 SerDes driver (see below).
>   - Host mode providing register based injection and extraction.
>   - Switch mode providing MAC/VLAN table learning and Layer2 switching
>     offloaded to the Sparx5 switch.
>   - STP state, VLAN support, host/bridge port mode, Forwarding DB, and
>     configuration and statistics via ethtool.
> 
> More support will be added at a later stage.
> 
> The Sparx5 Switch chip register model can be browsed here:
> Link: https://microchip-ung.github.io/sparx-5_reginfo/reginfo_sparx-5.html

Out of curiosity, what tool was used to generate the register
information page? It looks really neat and well organized.
-- 
Florian
