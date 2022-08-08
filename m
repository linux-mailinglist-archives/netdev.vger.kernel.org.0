Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D630C58CF30
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 22:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244380AbiHHUdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 16:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbiHHUdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 16:33:31 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41A01A83A;
        Mon,  8 Aug 2022 13:33:29 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 278KWajI072002;
        Mon, 8 Aug 2022 15:32:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1659990756;
        bh=j3Nmwmal0EHbQAnBU2mKhZhZUG6c7/jIXdidgYaJCjI=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=nLfMUYcdwQejFjTQVirISxIlVuIlpA6qi6fknwrYFaO57wzDzoHfc7lH+A9l/Gc81
         tzEqHvZ0K2YzyjYIbhw6956StF3X5x9Ieew9ltJ109Z3fioyszLHOY3bvLHanwmhPV
         YRIN5x2FBfkqVTke8ZXc8ZVC/rg4bfCm+xBaUtNA=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 278KWaGT028739
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 8 Aug 2022 15:32:36 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 8
 Aug 2022 15:32:35 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 8 Aug 2022 15:32:35 -0500
Received: from [10.250.34.173] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 278KWYhm041268;
        Mon, 8 Aug 2022 15:32:34 -0500
Message-ID: <8b577a8e-26e3-c9db-dae1-7d74fc3334ad@ti.com>
Date:   Mon, 8 Aug 2022 15:32:34 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5/5] dt-bindings: Drop Dan Murphy
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pavel Machek <pavel@ucw.cz>,
        Tim Harvey <tharvey@gateworks.com>,
        Robert Jones <rjones@gateworks.com>,
        Lee Jones <lee@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, <linux-hwmon@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-leds@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <alsa-devel@alsa-project.org>
References: <20220808104712.54315-1-krzysztof.kozlowski@linaro.org>
 <20220808104712.54315-6-krzysztof.kozlowski@linaro.org>
 <43b3c497-97fd-29aa-a07b-bcd6413802c4@linaro.org>
 <6ae15e00-36a4-09a8-112e-553ed8c5f4da@ti.com> <YvFtJRJHToDrfpkN@lunn.ch>
From:   Andrew Davis <afd@ti.com>
In-Reply-To: <YvFtJRJHToDrfpkN@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/22 3:08 PM, Andrew Lunn wrote:
>> Either way, I have several of these parts and can support these. Feel free
>> to replace Dan's email with my email if that works better.
> 
> Please could you submit a patch to MAINTAINERS replacing Dan's name
> with your. I see lots of bounces from PHY driver patches because the
> get_maintainers script returns his address.
> 


I'm not seeing his name in the latest MAINTAINERS, seem they all got
dropped in 57a9006240b2. Maybe the script returns his address based
on commit signing. Not sure what the current solution to that would be,
maybe .get_maintainer.ignore?

Andrew


> Thanks
> 	Andrew
