Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400A82AF192
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgKKNGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgKKNGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:06:44 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A37FC0613D1;
        Wed, 11 Nov 2020 05:06:44 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id a9so2060841lfh.2;
        Wed, 11 Nov 2020 05:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=82RRu0ROzYm5taPzq2lMWZPSnstixBkqQF5X1RxYego=;
        b=pcrIMq3o0TmMtnIRNs9t+1HKUABav1CurgNuFaFYakVEf+z580IjUws9F2xhMiDwQX
         sxsTSh3pZU0M7/AiQG1xqFCqR69wm+t4RX2VQEc55FRRbB/KMtDKfGZtifUZmNq7dDYF
         SMhoBX05Doo+F0pTepPpTw4QN5RRuLB40oV1rXdeyVwuYbCavF+ICADPwQ7oO8Oh1puX
         15Naxi4BuzqTFtLHwUTIn2g9Gc9XHrL04F4bGT+EVEGfcqCU5cokvPlZ1/yQvrMKn407
         6D2p4OJYeEUJYIyGsHhhM8q2ADnz3tJaw1HEk8hJo7Fa617e4oItQrlEQ6Cp5PLCgaZL
         KD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=82RRu0ROzYm5taPzq2lMWZPSnstixBkqQF5X1RxYego=;
        b=ZyXrIgul+e8lw+l1XZJToKt+AAin882gp+OaszU3HsVHy949hczOkoh3Kuv/D8Fqg7
         pHKECAnx2sFHiQxs7sq4RUd5n2z/c7DapdxbsIL4/HxvsylLAGDPd4r/jPph2iBxRatx
         65cWEcG/T27FmD5H5tS+e1aaqlE+pRpPon8z46IyPmug1+iCaLldMwdnpjXzM5BdgZ3+
         uGceWN39qbUDMWSBzlEP8nKuh5vDsvDdV0V0CZ9cvWWhXVmfYgAOY5Tw8kKR/asfZg2W
         aOxsspWg/vK8AQXoHbk6HI2gvuwn+OoKp9CRzrOt2KnJUjnWYSexnowhoaKjlkUxE3Su
         PWww==
X-Gm-Message-State: AOAM533P+mgU8o86Au7NxOxyWu7vb6lvB1xo6sDS2kERqZ66wvR/BwX2
        tBDucZZ9P/5KqbjwFrtNQus=
X-Google-Smtp-Source: ABdhPJxFMbJp8eNEkvkR9Sko+OH5lAZGUOWg8rrjbjnIfFbmWVvz6JsvCLZtOvrf3TnsNFdFOeqsTw==
X-Received: by 2002:ac2:51d9:: with SMTP id u25mr2937980lfm.52.1605100003102;
        Wed, 11 Nov 2020 05:06:43 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id b8sm230406ljo.68.2020.11.11.05.06.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 05:06:41 -0800 (PST)
Subject: Re: [PATCH 04/10] ARM: dts: BCM5301X: Add a default compatible for
 switch node
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-5-f.fainelli@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <af2d0f49-38a9-d7df-8848-40050a2d5c85@gmail.com>
Date:   Wed, 11 Nov 2020 14:06:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201110033113.31090-5-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.11.2020 04:31, Florian Fainelli wrote:
> Provide a default compatible string which is based on the 53010 SRAB
> compatible, this allows us to have sane defaults and silences the
> following warnings:
> 
> arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml:
> ethernet-switch@18007000: compatible: 'oneOf' conditional failed, one
> must be fixed:
>          ['brcm,bcm5301x-srab'] is too short
>          'brcm,bcm5325' was expected
>          'brcm,bcm53115' was expected
>          'brcm,bcm53125' was expected
>          'brcm,bcm53128' was expected
>          'brcm,bcm5365' was expected
>          'brcm,bcm5395' was expected
>          'brcm,bcm5389' was expected
>          'brcm,bcm5397' was expected
>          'brcm,bcm5398' was expected
>          'brcm,bcm11360-srab' was expected
>          'brcm,bcm5301x-srab' is not one of ['brcm,bcm53010-srab',
> 'brcm,bcm53011-srab', 'brcm,bcm53012-srab', 'brcm,bcm53018-srab',
> 'brcm,bcm53019-srab']
>          'brcm,bcm5301x-srab' is not one of ['brcm,bcm11404-srab',
> 'brcm,bcm11407-srab', 'brcm,bcm11409-srab', 'brcm,bcm58310-srab',
> 'brcm,bcm58311-srab', 'brcm,bcm58313-srab']
>          'brcm,bcm5301x-srab' is not one of ['brcm,bcm58522-srab',
> 'brcm,bcm58523-srab', 'brcm,bcm58525-srab', 'brcm,bcm58622-srab',
> 'brcm,bcm58623-srab', 'brcm,bcm58625-srab', 'brcm,bcm88312-srab']
>          'brcm,bcm5301x-srab' is not one of ['brcm,bcm3384-switch',
> 'brcm,bcm6328-switch', 'brcm,bcm6368-switch']
>          From schema:
> Documentation/devicetree/bindings/net/dsa/b53.yaml
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>   arch/arm/boot/dts/bcm5301x.dtsi | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
> index ee23c0841699..807580dd89f5 100644
> --- a/arch/arm/boot/dts/bcm5301x.dtsi
> +++ b/arch/arm/boot/dts/bcm5301x.dtsi
> @@ -483,7 +483,7 @@ thermal: thermal@1800c2c0 {
>   	};
>   
>   	srab: ethernet-switch@18007000 {
> -		compatible = "brcm,bcm5301x-srab";
> +		compatible = "brcm,bcm53010-srab", "brcm,bcm5301x-srab";

I've never seen Northstar device with BCM53010, see below list.


*** BCM47081 ***

Buffalo WZR-600DHP2
[    1.816948] b53_common: found switch: BCM53011, rev 2

Luxul XWR-1200 V1
[    2.602445] b53_common: found switch: BCM53011, rev 5

TP-LINK Archer C5 V2
[    0.606353] b53_common: found switch: BCM53011, rev 5


*** BCM4708 ***

Buffalo WZR-1750DHP
[    1.961584] b53_common: found switch: BCM53011, rev 2

Netgear R6250 V1
[    2.445594] b53_common: found switch: BCM53011, rev 2

SmartRG SR400ac
[    4.258116] b53_common: found switch: BCM53011, rev 5


*** BCM4709 ***

TP-LINK Archer C9 V1
[    0.640041] b53_common: found switch: BCM53012, rev 5


*** BCM47094 ***

D-Link DIR-885L
[    1.373423] b53_common: found switch: BCM53012, rev 0

Luxul XWR-3150 V1
[    5.893989] b53_common: found switch: BCM53012, rev 0

Luxul XAP-1610 V1
[    0.761285] b53_common: found switch: BCM53012, rev 0
