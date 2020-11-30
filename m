Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8ED2C90A8
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgK3WJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730465AbgK3WJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:09:22 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BDDC0613D2;
        Mon, 30 Nov 2020 14:08:42 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id t8so11318860pfg.8;
        Mon, 30 Nov 2020 14:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xZCS3thJSCTmAU4E2QGlbaIFDJgTs1PVCHGBDr+Z+EI=;
        b=sXvV8U0G4R+bISH2vOYUlqcTpLCADYh44b3CSnGUiW/ybrPvDdRWxoiO+Kiw/1IEy/
         LgaziGLD5T6my0AhQwkPzQqg06PDtCsSKSAwoStBx+Ue44gqmu3lWcrK9Y/OpRSDrU4Y
         vNIYEzz+xraYn+8Qye3UVuP/IGf5m/PY3VDLMMNNGMDmyvvJlIIDooV4AbzxhvLcdwx+
         HjHzzVP/py6XWjKj3zunBUO+Onj3sl0iZMB/k+M7HAMUCY7xMcGKHd29qzMOcuMkUoGg
         RXp8ce2AStqaWQPIqCL6bXhUMU1z2TE+1pMV/VDLEJogwK6CPeM/F9AdttDQqFrDfZS/
         BrZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xZCS3thJSCTmAU4E2QGlbaIFDJgTs1PVCHGBDr+Z+EI=;
        b=uFZEbqLr/P4zg5BdJLL76o1E1i9uc5IDEDGTgLt2dzgubverOR6wgrpvE9pkxTP4jl
         bgxA81nlhpmMBOgHCAytx30QElR/NjNxKjGKMWCp/5V6JBPOFJKVke4M5L2XDFjy+Hsw
         pe7cpkKjFXiUsu9D/caMrFcdoXLxbnvRgRjWae/GIJx7Ixlo11fY47upIvio3mQ7C9P+
         QUJ5BGXJ0GqFK4QSZbi51ygUH0pbA3PnXddo0N9Nl7W2C0caBkFZxSIMn6UCZ1AvvhlE
         XqLrDPuVAK5LDrV1R/VCi03rjzmIAmVGsNlkRTMD832bdSP6j1olwddg2shiVcPbWPMI
         HQjw==
X-Gm-Message-State: AOAM5338WacmSXGMywd8A5CES37B9l/AQDC4+w4uldlOIb4j5rUm8JTC
        CmW16kGgZ9FkP+AvcWxXh6il6VaRDm0=
X-Google-Smtp-Source: ABdhPJywS52ha2hvYTmqUSFIEEePNTV8txTswiQK9aJlLcu3pEM90zTq21dPdeNPT5o8I0YtBpbZ3A==
X-Received: by 2002:a63:c64:: with SMTP id 36mr19836040pgm.255.1606774121691;
        Mon, 30 Nov 2020 14:08:41 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z9sm452872pji.48.2020.11.30.14.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 14:08:40 -0800 (PST)
Subject: Re: [PATCH v2 1/3] dt-bindings: net: fsl-fec add mdc/mdio bitbang
 option
To:     Andrew Lunn <andrew@lunn.ch>,
        Adrien Grassein <adrien.grassein@gmail.com>
Cc:     fugang.duan@nxp.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201128225425.19300-1-adrien.grassein@gmail.com>
 <20201129220000.16550-1-adrien.grassein@gmail.com>
 <20201129224113.GS2234159@lunn.ch>
 <CABkfQAFcSNMeYEepsx0Z6tuaif-dQhE2YBMK54t1hikAvzdASg@mail.gmail.com>
 <20201129230416.GT2234159@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bb81c90c-d79e-d944-e35e-305da23d9e58@gmail.com>
Date:   Mon, 30 Nov 2020 14:08:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201129230416.GT2234159@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/29/2020 3:04 PM, Andrew Lunn wrote:
> On Sun, Nov 29, 2020 at 11:51:43PM +0100, Adrien Grassein wrote:
>> Hi Andrew,
>>
>> Please find my answers below.
>>
>> Le dim. 29 nov. 2020 à 23:41, Andrew Lunn <andrew@lunn.ch> a écrit :
>>
>>     On Sun, Nov 29, 2020 at 10:59:58PM +0100, Adrien Grassein wrote:
>>     > Add dt-bindings explanation for the two new gpios
>>     > (mdio and mdc) used for bitbanging.
>>
>>     Hi Adrien
>>
>>     What is missing is an explanation of why!
>>
>> I'm sorry, it's my first upstreaming attempt.
> 
> Hi Adrien
> 
> Please take a look at
> 
> https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html
> 
> It is normal to have a patch 0/X which explains the big picture.
> 
> Then the commit message for each patch should explain why you are
> doing something. That is much more important than what you are doing,
> i can see that from the patch itself.
> 
>> I am currently upstreaming the "Nitrogen 8m Mini board" that seems to not use a
>> "normal" mdio bus but a "bitbanged" one with the fsl fec driver.
> 
> Any idea why?
> 
> Anyway, you should not replicate code, don't copy bitbanging code into
> the FEC. Just use the existing bit-banger MDIO bus master driver.

Right there should be no need for you to modify the FEC driver at all,
there is an existing generic bitbanged MDIO bus driver here:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/mdio/mdio-gpio.c

with its binding here:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/net/mdio-gpio.txt

so all you should need to do is make sure that you place a
"virtual,mdio-gpio" node, declare the PHY devices that are present on
that bus, and have your FEC nodes point to those PHY devices with an
appropriate 'phy-handle' property.
-- 
Florian
