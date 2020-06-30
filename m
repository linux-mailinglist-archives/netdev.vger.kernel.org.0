Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A88E20EC0E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgF3DfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgF3DfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:35:15 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7DEC061755;
        Mon, 29 Jun 2020 20:35:15 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id f6so4833856pjq.5;
        Mon, 29 Jun 2020 20:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zXTJu9jT8dNH6yUHWppqC/x9/GobYCOn1TeUoW6Oe2g=;
        b=iWqkTxL71XRvSS4sU9MEVbqA0zX3uK25gZRe1sW9ZdLlE61oG0fvWpzgRwjcwfnaem
         WaxWZ99FgYDjEnRPhfzU+F3nInUIUTE4fhtgNg24sTypdCimPlOUBSsLt/ccMagoixS6
         CAykD0pAOZf3w8Snk6K9GUZXaaqSXFhnD1LLkFbD9TotXkovGM/NwLe4sF5zJi6OjsfX
         16hQlBDJr1hr/kgKa3oUu8gkgEq+JJHH7XWhkklfk/mVtxjo146pqMqq6BukMrlJuaLE
         m6J7sm2c5w73jB9GwcJoa06c/FrXW0+ySJGyaO0LEGXRp6V87ZE/HmJPjrTcxZsu7IqE
         YtBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zXTJu9jT8dNH6yUHWppqC/x9/GobYCOn1TeUoW6Oe2g=;
        b=Z5x+tgdb2RzWOXGjJCIRdrAGNVr69oBwCYOnOHHI7nA6itKH7V50bJMEmPINTz3xv8
         7ET50Q0r1snPSzQrdIEWYjMhTakLM6MkckIS808xJo4Q08DACXW+7/3kA2Vhy+64nmyN
         1hWT1fAmgFZnVt+fSs6//A/u5oPBeWoBdAYYV21wDbl7NNU54iELGqThdn6/JAuUBaRG
         4nSzaGK2C8uE2jYUPlO650x4WfRRwrmB2TTh90aEF2yn/9Ws3aAePAv3C77qKhm0htHC
         zU70sU6FgyIDY7I4Mik0z9d8EoeSc/VS5XtiFVmhfviTgYiNwPQ6lVsK9Yt6inhl0rMt
         HAPw==
X-Gm-Message-State: AOAM530qqFzicyDoBcW3w+wnTxDJps1DNh+ReZUrXa8ixlphoQ7DmIfz
        pFP8V+p+GmxsQQdn8JuyBRDGJYeg
X-Google-Smtp-Source: ABdhPJyuqES7YHE+dO2Q8QxVIJmIRCcLH32v79l4dg9XowoMVoc7ZffBzaLSjZusbAPAt/dJiMi3bA==
X-Received: by 2002:a17:90a:7409:: with SMTP id a9mr20442046pjg.107.1593488114205;
        Mon, 29 Jun 2020 20:35:14 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 125sm911379pff.130.2020.06.29.20.35.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 20:35:13 -0700 (PDT)
Subject: Re: [PATCH] of: of_mdio: count number of regitered phys
To:     Andrew Lunn <andrew@lunn.ch>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        frowand.list@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1593415596-9487-1-git-send-email-claudiu.beznea@microchip.com>
 <20200630004543.GB597495@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6b022bcc-a670-da1d-5f5a-bdf4af667652@gmail.com>
Date:   Mon, 29 Jun 2020 20:35:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200630004543.GB597495@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/2020 5:45 PM, Andrew Lunn wrote:
> On Mon, Jun 29, 2020 at 10:26:36AM +0300, Claudiu Beznea wrote:
>> In case of_mdiobus_register_phy()/of_mdiobus_register_device()
>> returns -ENODEV for all PHYs in device tree or for all scanned
>> PHYs there is a chance that of_mdiobus_register() to
>> return success code although no PHY devices were registered.
>> Add a counter that increments every time a PHY was registered
>> to avoid the above scenario.
> 
> Hi Claudiu
> 
> There is a danger here this will break something. Without this patch,
> an empty bus is O.K. But with this patch, a bus without a PHY is a
> problem.
> 
> Take for example FEC. It often comes in pairs. Each has an MDIO
> bus. But to save pins, there are some designs which place two PHYs on
> one bus, leaving the other empty. The driver unconditionally calls
> of_mdiobus_register() and if it returns an error, it will error out
> the probe. So i would not be too surprised if you get reports of
> missing interfaces with this patch.

Agreed, the potential for breakage here is too high especially given
this is fixing a hypothetical problem rather an an actual one. Even if
we were taking this from the angle of power management, runtime PM
should ensure that a MDIO bus with no slave, or no activity gets runtime
suspended.
-- 
Florian
