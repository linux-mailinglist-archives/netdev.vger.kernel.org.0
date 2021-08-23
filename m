Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49043F4860
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 12:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbhHWKOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 06:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbhHWKOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 06:14:37 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E2FC061575;
        Mon, 23 Aug 2021 03:13:55 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l7-20020a1c2507000000b002e6be5d86b3so10344085wml.3;
        Mon, 23 Aug 2021 03:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OAxK2KdBzNvaNwZfXA57e6cEAoY65yX8S0S6MTAgEjc=;
        b=b8CiuKj3QsBJFUsLglvvBWdf3ayT6erQTvKIsAuBPBOxFs2BE+N1iz7BRsXz8E7jXV
         FG5ADsopmgXoobJa3ohB/OMijsxMT2SgtfMvHvvOibHB1e3ICGEdel6J4KiQ86SHlg3Z
         yqqAGC11bIaF8QPVS9ZARj90VH6KtqsRDUvyHMxT5MGqdKcEfQ8a44VmJ2ZLKQc4ZqdY
         y7PglP1615+bVljliehmWpKeYhkrBHDQnvBBGBzRBeTJPcaT3PO40D/V85QvgBFredY5
         mT4ucw4T6GkBvtAOVbHSIIvurZj0MSgpqEhZhQ6eXIYSjmtDHiX+DDcmdO16xzACWYt1
         Xj2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OAxK2KdBzNvaNwZfXA57e6cEAoY65yX8S0S6MTAgEjc=;
        b=YbQbvwm3vU3LFWDbLHrzIbFrrPkWu/hE2G15Yl9218iOCw2b3rLeIR1z21tlBsmjSk
         eupdZlVj/4WLB98hIfGhZ4eEI0/qopEd970aTPqdEsLg68oF/ACiem65O5AKAaMNMe1l
         2Qn42wr52st2TOoaqfR/9Hy8LoovhO3WsSrn2sPKtQ5yE65nJi95v/6iEoqq8qrRAn1a
         KDeWKZvj7FMwV9h+MUiFXi/lLsqs6OlUwetmksguB8rWe0PpS4NLTc6nvTY2MuZ4Hufi
         kCqpUwZ9YqnHKV8AlCC3te0zP/kM6i8lnfJEiNHPmUVU8jn88XVebFSHkWFbEAEhGgXE
         eJsA==
X-Gm-Message-State: AOAM531ckpikfikPHUU2ehF1BOsgvYbXpz+seaUAcVOeEOVp2DKZ3zkg
        JzDOSTpVkAKnb2a6sxqklu0=
X-Google-Smtp-Source: ABdhPJzHmNOwxOGgKhQIpsA8MM5feiclzYV7bQCw7wBADKZ0n/vfRiezLFD5PEPlUTPKPlyI8yT0yQ==
X-Received: by 2002:a05:600c:22d2:: with SMTP id 18mr15266087wmg.117.1629713633917;
        Mon, 23 Aug 2021 03:13:53 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:8192:e700:d8d0:123c:2bc1:6888? (2a01cb058192e700d8d0123c2bc16888.ipv6.abo.wanadoo.fr. [2a01:cb05:8192:e700:d8d0:123c:2bc1:6888])
        by smtp.gmail.com with UTF8SMTPSA id h6sm14334522wmq.5.2021.08.23.03.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 03:13:53 -0700 (PDT)
Message-ID: <21f8b516-8b85-e65f-1f11-bebd7bdf3b96@gmail.com>
Date:   Mon, 23 Aug 2021 12:13:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [RFC PATCH net-next 5/5] net: phy: realtek: add support for
 RTL8365MB-VC internal PHYs
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
Cc:     mir@bang-olufsen.dk,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-6-alvin@pqrs.dk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210822193145.1312668-6-alvin@pqrs.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/22/2021 9:31 PM, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> The RTL8365MB-VC ethernet switch controller has 4 internal PHYs for its
> user-facing ports. All that is needed is to let the PHY driver core
> pick up the IRQ made available by the switch driver.
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
