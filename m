Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E443E6CC7A6
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 18:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbjC1QOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 12:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjC1QOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 12:14:02 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E811E054;
        Tue, 28 Mar 2023 09:14:00 -0700 (PDT)
Received: from [IPV6:2003:e9:d70f:381f:5e2f:3bee:d4cb:b76b] (p200300e9d70f381f5e2f3beed4cbb76b.dip0.t-ipconnect.de [IPv6:2003:e9:d70f:381f:5e2f:3bee:d4cb:b76b])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 21852C006B;
        Tue, 28 Mar 2023 18:13:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1680020036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HFMN6mUuYlhsG7aylfMw3Vp+mnIu1G529c1t4N/Sfdw=;
        b=GBK2ylDWhqNsIqksc0TxLHbl7294mSsrGhnxMD2iapNkDZuKX4RghYrDeZgR8bk6pjzUX4
        LCx+KoHHn2MxF3AOFc5SQ/HyiqRK0JFlqZpXsCzIBuM5L60JmFgy64zcBhLUWVS4KQk9mE
        zN+qskrudw8lvfSqsgW0AlP8M2wL8LaqrH0dt3JdLGADN/8LAyQiHisLioXHjSR6gl/qhi
        U3eqk2Kw9ky/a/qqzlyuCgjQGWeQ/7ezGdunoHwWiRbA/02m34mkgAdtZJfUthhd7CtZP1
        XmlV/adOLu57efxO2Qj81lFyhy0agMIBwKRPJQjko3n8k6G1NZlM0MI7rfpmAg==
Message-ID: <0538598d-9821-91d7-d327-68e025084b3c@datenfreihafen.org>
Date:   Tue, 28 Mar 2023 18:13:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 07/12] net: ieee802154: adf7242: drop of_match_ptr for ID
 table
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
 <20230311173303.262618-7-krzysztof.kozlowski@linaro.org>
 <20230328124859.12f3c329@xps-13>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230328124859.12f3c329@xps-13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 28.03.23 12:48, Miquel Raynal wrote:
> Hi Krzysztof,
> 
> krzysztof.kozlowski@linaro.org wrote on Sat, 11 Mar 2023 18:32:58 +0100:
> 
>> The driver will match mostly by DT table (even thought there is regular
>> ID table) so there is little benefit in of_match_ptr (this also allows
>> ACPI matching via PRP0001, even though it might not be relevant here).
>>
>>    drivers/net/ieee802154/adf7242.c:1322:34: error: ‘adf7242_of_match’ defined but not used [-Werror=unused-const-variable=]
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> I see Stefan already acked most of the ieee802154 patches, but I didn't
> got notified for this one, so in case:

The reason I did not ack the two patches for adf7242 is that Michael as 
driver maintainer ack'ed them already.

I only handled the ones where we have no active maintainer, as a fallback.

regards
Stefan Schmidt
