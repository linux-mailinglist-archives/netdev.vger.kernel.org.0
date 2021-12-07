Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F9246BC63
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 14:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbhLGN0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 08:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbhLGN03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 08:26:29 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619B1C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 05:22:59 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id y13so56795314edd.13
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 05:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oc9Wkz5jgDY4o+8kSSOj5yd7iUL8Q398GikqMs1N9Oo=;
        b=c2oTKNqdHWO7TyDUtDuM7LfBVbr708WIPM/W28cgtEVkef7+8olB26UTj1mj46xx2l
         C0uWx6hIAdS9avoPCgDM28ZzbYbc+Uo9YCD45ZD91wbp6J3COPQeqtTJSnWmgxaPGXf2
         Ryd1HOZbkI4RSVfvObgU4FH9iE55xuug3qbU2HVwwJG2JiX6d7WPo3VwJWtgN1CLnxpx
         R0LYlQsdRu5MMVCcRBzQjNzpNMRkQNcJh5rtVRmmNX7tLQ9UliJqSH5BWbmh9vK6Hq6A
         wZWwCyClFMeiXx4u5v8vpyQzgw/R8b8EmxsFwCbGiiVM2Z9PmFIi80XzjE6Mrtok5Z4M
         RBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oc9Wkz5jgDY4o+8kSSOj5yd7iUL8Q398GikqMs1N9Oo=;
        b=1KWrHwpWAW434h33pAa/Dv1ds5Od1PsMQCUf3hynenzO90PijimMHhEz1uYeHosRAN
         MQL5SaidEP33BoGCKHxVE1SNGkX73FhFvExbn+tUnYwpm3GkXyP+nuoxP1x0TQXez8Jg
         CVqetY3P2DGy5SA0tduoW/WBsA8OO6yaT6iz3naXqzUB6LQKPSWw/Zuyk1zkX9esKmid
         SAIFwQEpka1m2Q+/FUt+fGn/D15eL6G3u9Gf0/l60kyxIOsOp7Um1o5gDSOHNDfAk/Zn
         QRxnzZRMxuOD+e7CK5r+YjROVs4kRgFqH9son+gOuv6pwog6aEkUjpLWglF06XNDSiOi
         Z0jQ==
X-Gm-Message-State: AOAM530QW8KiTX6S0bKK8zSYTU4SdDiz8ZSrIk4yKRS2VOlpsZUhjWqO
        VNk8hhmpo531Xhn7NB/jW8bYHg==
X-Google-Smtp-Source: ABdhPJxG6a7G1QjCI8ZYNDNSaO7GTNk8UYS0aPsh1KVXeQOK44Cc9MJ5v3kRLdBp6iWQDTDDX+Veuw==
X-Received: by 2002:a17:906:c14b:: with SMTP id dp11mr53094084ejc.294.1638883377970;
        Tue, 07 Dec 2021 05:22:57 -0800 (PST)
Received: from [192.168.2.218] (78-22-137-109.access.telenet.be. [78.22.137.109])
        by smtp.gmail.com with ESMTPSA id n16sm10159271edt.67.2021.12.07.05.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 05:22:57 -0800 (PST)
Message-ID: <f68a2913-779b-65b7-0dac-27a2c4521c42@mind.be>
Date:   Tue, 7 Dec 2021 14:22:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on
 internal PHY's"
Content-Language: en-US
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org
References: <E1muXm7-00EwJB-7n@rmk-PC.armlinux.org.uk>
From:   Maarten Zanders <maarten.zanders@mind.be>
In-Reply-To: <E1muXm7-00EwJB-7n@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/21 11:32, Russell King (Oracle) wrote:
> Maarten Zanders has confirmed that the issue he was addressing was for
> an 88E6250 switch, which does not have a PHY_DETECT bit in bit 12, but
> instead a link status bit. Therefore, mv88e6xxx_port_ppu_updates() does
> not report correctly.
...>    Yes, you're right, I'm targeting the 6250 family. And yes, your
>    suggestion would solve my case and is a better implementation for
>    the other devices (as far as I can see).

I confirm that this patch works on my hardware, which uses an 88E6071 
(88E6250 family).
