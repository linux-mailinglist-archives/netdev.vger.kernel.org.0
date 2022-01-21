Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72FF49657E
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 20:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiAUTSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 14:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiAUTSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 14:18:14 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5893FC06173B;
        Fri, 21 Jan 2022 11:18:14 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u11so9458531plh.13;
        Fri, 21 Jan 2022 11:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gblw6HEANG08vvNT8wnSyaFRKCt3AspyDbQwbl/SDoE=;
        b=hImo7KNcZMSWOfPhS143lxAQpOcVVn1ltc5DeFq7lYXgRxieUCQTH8QQQhbwKjP2OE
         xX/49rUGKff3Els1IG3ArplCt8DfNGiLwtfl3IMW47LoBnkeQxq4MAxoHdEG4pk3pgDs
         H8E72EQIpszcRTd0DUVAANvGSNUZG6yhMQuFtpDiil9NyxtDkLOSvrk1uoa/I2YiOc2e
         ACuqAoLYo9LrCVWlhAZMHMslewp94cw41Jm2WflrI79y5xekbXVpDf3aJIHaZM5PODgi
         RjSVNSD8paiVgtu8+H2FULcIp8OYGyYTJOYG2yC0Ti8+jcYrGqNeV9LIgPaY/NQr5ARP
         nSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gblw6HEANG08vvNT8wnSyaFRKCt3AspyDbQwbl/SDoE=;
        b=yrWqv6RjrX5edovC+NCFjEFcmwTcQmRxTl3iA89qCNvAteEFOteqU/yTxtH0GEo9QA
         1qTQFMCUIdPZt9r1qjOus7ULXSSY8Rw47F8+EB8jd98eNsHttC27Ormof6ovTc7wdJB2
         KiRMYlOGH8fQVnQpFnyFp5tGg9e1sdqFIlRuRLystvZ/HgmMAZnjcsAzl//n4yPfKAr/
         wrfN/zYPGnNfAXdUpFCWkIyFaOmi7eHOl4OJlmVTS3ZH05RCyY1OBc3UegUqXlesMsVX
         73f9nYy4b0qcUH4daQk27YhoR5MNPGFqsw2McfdiVe/YOUe0w2YcoreLUESVhFJlLkFq
         E4Qg==
X-Gm-Message-State: AOAM533y5gjg5vit5Xq4f0oc+hEfMSMNBdy0pPYII9bAe5o++SuaLKPA
        ZzlY9+vbksG1aQ/5NqPTT9s=
X-Google-Smtp-Source: ABdhPJxGjRYibGbPqIrwFNV9Pkake/QfuLqGN9VS1suJFou8fh9Qha8BWKg6kaJI4WTodqbc4/wSfg==
X-Received: by 2002:a17:90b:4a42:: with SMTP id lb2mr2186771pjb.46.1642792693791;
        Fri, 21 Jan 2022 11:18:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z10sm8030718pfh.77.2022.01.21.11.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jan 2022 11:18:13 -0800 (PST)
Subject: Re: [PATCH devicetree v3] dt-bindings: phy: Add `tx-p2p-microvolt`
 property binding
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
References: <20220119131117.30245-1-kabel@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <74566284-ff3f-8e69-5b7d-d8ede75b78ad@gmail.com>
Date:   Fri, 21 Jan 2022 11:18:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220119131117.30245-1-kabel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/22 5:11 AM, Marek Behún wrote:
> Common PHYs and network PCSes often have the possibility to specify
> peak-to-peak voltage on the differential pair - the default voltage
> sometimes needs to be changed for a particular board.
> 
> Add properties `tx-p2p-microvolt` and `tx-p2p-microvolt-names` for this
> purpose. The second property is needed to specify the mode for the
> corresponding voltage in the `tx-p2p-microvolt` property, if the voltage
> is to be used only for speficic mode. More voltage-mode pairs can be
> specified.
> 
> Example usage with only one voltage (it will be used for all supported
> PHY modes, the `tx-p2p-microvolt-names` property is not needed in this
> case):
> 
>   tx-p2p-microvolt = <915000>;
> 
> Example usage with voltages for multiple modes:
> 
>   tx-p2p-microvolt = <915000>, <1100000>, <1200000>;
>   tx-p2p-microvolt-names = "2500base-x", "usb", "pcie";
> 
> Add these properties into a separate file phy/transmit-amplitude.yaml,
> which should be referenced by any binding that uses it.

p2p commonly means peer to peer which incidentally could be confusing,
can you spell out the property entire:

tx-peaktopeak-microvolt or:

tx-pk2pk-microvolt for a more compact name maybe?
-- 
Florian
