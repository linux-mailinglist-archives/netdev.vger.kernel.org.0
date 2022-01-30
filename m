Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3A34A37E5
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 18:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355735AbiA3Rfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 12:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355732AbiA3Rfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 12:35:43 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AE3C061714;
        Sun, 30 Jan 2022 09:35:42 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id d187so10830533pfa.10;
        Sun, 30 Jan 2022 09:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CzSjPpfTopj6ntF5tKbbTI4PqBmUQrwkOXKtWWFpnX0=;
        b=GNv1cYfjv36lkUDfimT6iNIcygcJjl46Vg4MJDOy07VkD5iJPBrgJdXTIIypmyQ7jP
         puZK/Y6bnECQt0p5VSHp0qe/+Ikv5MDCy6i4xj60DKi7GufSfLBrIGzWiCpFYFD+lX/4
         /sbcMtiEnSAHoknfu8/HlhRJuKrD+WRG7o139PIsj/5zhhNQIjWB88IdNMnN8WEAl+oX
         cFyn+Ml3r3RImtQ3V+wgg79uWvI7iHwwc/Aw9q989q3cEQ1y+xRaLdsbjNQbUEgv6uvn
         gc6uuNk7VMluoFKEvfkbBEs+e6VZUbnhWBK8YHyNW3p6yVAn7JFwFcISizcwEvy5iG74
         BVgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CzSjPpfTopj6ntF5tKbbTI4PqBmUQrwkOXKtWWFpnX0=;
        b=BvIJWwvH1NEvu80cnp+PfqqRTO3Ykhrps451OZhFHuSjA5ZsQnngUTtB+KUxJyYvAr
         9qPfwK3MLKB3VstnI0nYwjecuryec5Wyld0o7BU+Hhg+q3QpDfN7JikHI3iX5OKLWERP
         BuSnbRT1jEAoKySUv8LKNHyT7KtRqMWBPutu7H85Y9c5SgRM2PKTzmWh+g/yjFgTgZLx
         aOHrwmihDNoH3Bbn1pOBhMfJFLt9fOD/InRnNAwA+bFMbEW0N4/5bH+kmliCLIXP80ub
         vPq0OgX1eyR92CnfCBe3euQ/YdnHRz2gIOY9Y5dCJxwJ26JQZPO1wFoADxngSU5mhDC+
         UjQg==
X-Gm-Message-State: AOAM531ap6Pk/vjLDeHZ05Qh7ogRcfZATQQZRtCMR5Ge4e9laM2t9t6y
        KfRkG1KhUkvuvC/HNwpA2DL++TujWwU=
X-Google-Smtp-Source: ABdhPJy9WCDkrOuxpztYSfqjVRveMtMxJUREGGT8k/8UPsbnd4j734PXNmqhIA8n7n+O02Kxk8UyLQ==
X-Received: by 2002:a63:6c83:: with SMTP id h125mr1096510pgc.342.1643564142358;
        Sun, 30 Jan 2022 09:35:42 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:31be:19f8:e4b4:84c8? ([2600:8802:b00:4a48:31be:19f8:e4b4:84c8])
        by smtp.gmail.com with ESMTPSA id w12sm27221063pgj.40.2022.01.30.09.35.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Jan 2022 09:35:41 -0800 (PST)
Message-ID: <a9571486-1efd-49a7-aa26-c582d493ead6@gmail.com>
Date:   Sun, 30 Jan 2022 09:35:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML
 schema
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Rob Herring <robh@kernel.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20211228072645.32341-1-luizluca@gmail.com>
 <Ydx4+o5TsWZkZd45@robh.at.kernel.org>
 <CAJq09z4G40ttsTHXtOywjyusNLSjt_BQ9D78PhwSodJr=4p6OA@mail.gmail.com>
 <7d6231f1-a45d-f53e-77d9-3e8425996662@arinc9.com>
 <CAJq09z7n_RZpsZS+RNpdzzYzhiogHfWmfpOF5CJCLBL6gurS_Q@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAJq09z7n_RZpsZS+RNpdzzYzhiogHfWmfpOF5CJCLBL6gurS_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/29/2022 12:52 PM, Luiz Angelo Daros de Luca wrote:
>> Why not turn realtek-smi.yaml into realtek.yaml which would also contain
>> information for the mdio interface? The things different with using MDIO
>> are that we don't use the [mdc,mdio,reset]-gpios properties and don't
>> handle the PHYs to the DSA ports. Couldn't you present these differences
>> on a single YAML file?
> 
> Hello, Arinç
> 
> realtek-mdio is an mdio driver with a couple of less properties. They
> do share a lot of stuff. But I don't know if I can fit the schema
> validation into a single file.
> YAML files are not simply documentation. They are used to validate DTS
> files. But that's still off-topic. Let's finish SMI version first and
> then discuss
> if the MDIO version should be standalone or merged with SMI.

Your YAML file can cover both types of electrical bus, what you are 
defining is the layout and the properties of the Ethernet switch Device 
Tree node which is exactly the same whether the switch is the children 
of a SPI controller or the children of a MDIO bus controller. If there 
are properties that only apply to SPI or MDIO, you can make use of 
conditionals within the YAML file to enforce those. Having a single 
binding file would be very helpful to make sure all eggs are in the same 
basket.
-- 
Florian
