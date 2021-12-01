Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA5C4653B8
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351734AbhLARSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 12:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351657AbhLARS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 12:18:28 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6057C061574;
        Wed,  1 Dec 2021 09:15:06 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id l190so24298523pge.7;
        Wed, 01 Dec 2021 09:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hWswA44oaaS3jQ+owzgmDJn6tg2JS9UVUfN6QFbLpOM=;
        b=Qe0Zp2jhMjaxRsRzx8wghK8U3pvBo6xkXZ/4HNiIWLpZtP2MNaV/+Lf6Lrol1YY9yX
         5I/3bc0yA7iIaktmOgoRQcEhrXQGT6EmoosFkmCMfZfogZO7pL6PMnBbq0paR9+noAdK
         DnsO8Hxktvbb+qcCJqp7zwVl7cEMmEqu0OYFRzGSnWxO1aEZR1L0wGR3KisQcwpjTK6Z
         nK2s1vYSosOzVIa8MWxQjEhr+lqtPhsOYqiYDmPXm5fB3qcBI+nXF592usPqnLUuhCeU
         wlxTEne/ikbu8FdXK2mbs9aAm2RMQWFClPRu0Xkf9suTsLPzYY1Shf1LoDOtNsI5vxZz
         n68g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hWswA44oaaS3jQ+owzgmDJn6tg2JS9UVUfN6QFbLpOM=;
        b=Z5/ImyGbwaBJ1I5xZHEr0PVgrgl2v6GQr9MQjel3XazvvmYzAl1qjDDV9kBTcOUPeW
         DN6DuExEDA8rZ0d5/0DWKEoFd32KqvgTlCTjbWAK9DtVISEG5KKji9cz9RDr78Z2h7n1
         U1IJxuuzx7ERKqxJXmJgd/nFg4M/PX5jsn875ssc6GRvvlgH9z3PDR+zvy8szSyyxnUA
         X+GfNXcyecoFQ4WkblNPHMfmOPn1deVKv5sJFCaMadcswhDx0uSNodztVXSwjtYL8S1J
         7RYmBZC+HJyL6gaxAl4kv23WumgWbSNylMurbAvMZuROcHsGSpNGnYkVbK1skeL49YCy
         oj0Q==
X-Gm-Message-State: AOAM530HHd/+lXuDw+kZlBeqZgDmp5Xi3OV5eas8t3NrTPvqQCmLA/uu
        XX0PVSljfF5m7pu4AxsaMZH0YSD/hzA=
X-Google-Smtp-Source: ABdhPJxh2sINwTG6LLdLqHseVoYT6LEFTDf5+qEOnJuStVRFCFl6IHzV5RLtKiaZd3dnsdA2h4ansQ==
X-Received: by 2002:a05:6a00:1903:b0:47c:34c1:c6b6 with SMTP id y3-20020a056a00190300b0047c34c1c6b6mr7455572pfi.17.1638378906160;
        Wed, 01 Dec 2021 09:15:06 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o23sm370967pfp.209.2021.12.01.09.15.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 09:15:05 -0800 (PST)
Subject: Re: [PATCH net-next 3/7] dt-bindings: net: Document moca PHY
 interface
To:     Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com
References: <20211201041228.32444-1-f.fainelli@gmail.com>
 <20211201041228.32444-4-f.fainelli@gmail.com>
 <1638369202.233948.1684354.nullmailer@robh.at.kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <52926c88-a51d-d4e8-a6ab-7cf92e35c7ba@gmail.com>
Date:   Wed, 1 Dec 2021 09:15:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1638369202.233948.1684354.nullmailer@robh.at.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 6:33 AM, Rob Herring wrote:
> On Tue, 30 Nov 2021 20:12:24 -0800, Florian Fainelli wrote:
>> MoCA (Multimedia over Coaxial) is used by the internal GENET/MOCA cores
>> and will be needed in order to convert GENET to YAML in subsequent
>> changes.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
>>  1 file changed, 1 insertion(+)
>>
> 
> Running 'make dtbs_check' with the schema in this patch gives the
> following warnings. Consider if they are expected or the schema is
> incorrect. These may not be new warnings.
> 
> Note that it is not yet a requirement to have 0 warnings for dtbs_check.
> This will change in the future.
> 
> Full log is available here: https://patchwork.ozlabs.org/patch/1561996
> 
> 
> ethernet@0,2: fixed-link:speed:0:0: 2500 is not one of [10, 100, 1000]
> 	arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dt.yaml
> 	arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dt.yaml
> 	arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var1.dt.yaml
> 	arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dt.yaml
> 	arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var3-ads2.dt.yaml
> 	arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dt.yaml
> 	arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dt.yaml
> 	arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dt.yaml
> 
> ethernet@17020000: phy-handle: [[36], [37]] is too long
> 	arch/arm64/boot/dts/apm/apm-mustang.dt.yaml
> 
> ethernet@30000: fixed-link:speed:0:0: 2500 is not one of [10, 100, 1000]
> 	arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dt.yaml
> 	arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dt.yaml

These are all pre-existing warnings, but we should be documenting speed
2500 in ethernet-controller.yaml, so I will add a patch towards that end.

The one for apm-mustand.dts however I am not sure how to best resolve
since it looks like there was an intention to provide two Ethernet PHYs
and presumably have the firmware prune the one that is not in use. I
don't even know if that platform is supported mainline anymore.
-- 
Florian
