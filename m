Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2231E0395
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 00:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388371AbgEXWFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 18:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387850AbgEXWFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 18:05:12 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC95C061A0E;
        Sun, 24 May 2020 15:05:11 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g12so14252203wrw.1;
        Sun, 24 May 2020 15:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3WPDX47yX5mukN7XjjJJumJ7dmH44paobovXuGph9n8=;
        b=tfooXd2FWuhN7uLYVtHSkzhYvhu9/Qb9dcs5exdkDJt+m3eb9yzJMeqkgGlKKFSxtT
         Lucwqgf/yU8qMPMZlVAbwLyDH9WoX4vNN54naSELI9XguWyPlqyQI82n89ogJAwqAMfw
         yloI0N+lJX/clOuxxQvlJcI+p1qfg8NprlrprI/bvXAF5rgDCu5rlvfPOtXen4IDqiht
         nbC8FO+8IU1GhloKJBYuNUK+8cL/BV8KdmDEcTteIsFg/XUQWRgxOgm5s+Q3+4vPqkEu
         LHtX7+YaMjekTVXjPTU5qiaKFc7KRyKLzCewhhRhK8tTv9OFtR8KfDtW/KGP1QizXjL7
         bfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3WPDX47yX5mukN7XjjJJumJ7dmH44paobovXuGph9n8=;
        b=Yl4dbPPZrr8THWsX+n1MxFsETAvC5cOswF9E8NAPPUaabHX2ScZ1v6G0czKWNY5K1Q
         yzbGPiut6yycDglL3wC3crHIgBb7j1IwwVxAvlRtLeC3HwjQGo7NpV2B79jNpf46hKoo
         g2ZC12TqvcSu+AIEoabPRojbla0ofXUj844YGQqeeU55cCsXBLl78Nqef29/J9WsZ4Gz
         tpnsOCC0s1CoVByNIOV02N0z+UPGhTlEX28HY8PrwSfDvqNvMP6A4jWoGv3X1m6ZCg0L
         Q10ryNFezV0dld/DUmDPlxs4nuP7i9ap7EU3mEh/zpUBhAO0jhkccARbapShrVtl1AnQ
         ItsQ==
X-Gm-Message-State: AOAM530xyaRVvt9GJ4/NAsk1YkZmdCm5k8N+dqy4JvpuuaTMNttaagsi
        CBZV2Xbxl8FAGxp5ouC7cn7YLS18
X-Google-Smtp-Source: ABdhPJxZk7d4WuVelJ2261aiOJBAQDkN+XnHYGmHRqNV/ukEvINZg8skvToF73mtCuFov/EkplYmIw==
X-Received: by 2002:adf:df03:: with SMTP id y3mr4707157wrl.376.1590357909253;
        Sun, 24 May 2020 15:05:09 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id j190sm16722255wmb.33.2020.05.24.15.05.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2020 15:05:08 -0700 (PDT)
Subject: Re: [PATCH v3 1/8] dt-bindings: net: meson-dwmac: Add the
 amlogic,rx-delay-ns property
To:     Pavel Machek <pavel@ucw.cz>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     robh+dt@kernel.org, andrew@lunn.ch,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
 <20200512211103.530674-2-martin.blumenstingl@googlemail.com>
 <20200524212843.GF1192@bug>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d3f596d7-fb7f-5da7-4406-b5c0e9e9dc3f@gmail.com>
Date:   Sun, 24 May 2020 15:05:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200524212843.GF1192@bug>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2020 2:28 PM, Pavel Machek wrote:
> On Tue 2020-05-12 23:10:56, Martin Blumenstingl wrote:
>> The PRG_ETHERNET registers on Meson8b and newer SoCs can add an RX
>> delay. Add a property with the known supported values so it can be
>> configured according to the board layout.
>>
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> ---
>>  .../bindings/net/amlogic,meson-dwmac.yaml           | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
>> index ae91aa9d8616..66074314e57a 100644
>> --- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
>> +++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
>> @@ -67,6 +67,19 @@ allOf:
>>              PHY and MAC are adding a delay).
>>              Any configuration is ignored when the phy-mode is set to "rmii".
>>  
>> +        amlogic,rx-delay-ns:
>> +          enum:
> 
> Is it likely other MACs will need rx-delay property, too? Should we get rid of the amlogic,
> prefix?

Yes, there are several MAC bindings that already define a delay property:

Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml:
     allwinner,rx-delay-ps:
Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml:
     allwinner,rx-delay-ps:
Documentation/devicetree/bindings/net/apm-xgene-enet.txt:- rx-delay:
Delay value for RGMII bridge RX clock.
Documentation/devicetree/bindings/net/apm-xgene-enet.txt:       rx-delay
= <2>;
Documentation/devicetree/bindings/net/cavium-pip.txt:- rx-delay: Delay
value for RGMII receive clock. Optional. Disabled if 0.
Documentation/devicetree/bindings/net/mediatek-dwmac.txt:-
mediatek,rx-delay-ps: RX clock delay macro value. Default is 0.
Documentation/devicetree/bindings/net/mediatek-dwmac.txt:
mediatek,rx-delay-ps = <1530>;

standardizing on rx-delay-ps and tx-delay-ps would make sense since that
is the lowest resolution and the property would be correctly named with
an unit in the name.
-- 
Florian
