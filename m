Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675EA4E3AD1
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiCVIlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 04:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbiCVIlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:41:31 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F11725D8;
        Tue, 22 Mar 2022 01:40:04 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id p9so23824857wra.12;
        Tue, 22 Mar 2022 01:40:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=/Tfn3grWM8EBZ0IFyy5BUNygjofN0WZXFLyZhdj5fD8=;
        b=UlDPQna4CCdnJGBrEqI6B8NF4N/ps+D1GLXFLuXXlmtvEs5zpF2MdoIvIpAoofLeJU
         ZOKbOec2wgadltr6Qxs9Bw0nrxcduvkxlHaH1Vvv52+VNzvVbYmXtIxQWA6oaOk7RGFr
         sERxThNv90Ev5yaTWNhyfNU2oDhqyhV3PKWuiq/sHOtD52XQf4rL+pYRRlAOgQVgZ6DU
         eOVp/S1BrSS662yJTlpIzrhmQOaQE7AH5ztC8xUv2ncfWcK6yrwQLz5LKFAPc0Vo38X6
         oYVpeD6I9Ar4f7bCAmKKBf1b3lNq62eawlTJnM8MLdL9vKab0kz54DS0su+Cbjur5pq5
         mpvw==
X-Gm-Message-State: AOAM530r1O45zpM53iKwyh+LSkPDwKvpfbvxBeQQVIpUXZfmykDCVIn2
        YJYHELMAlVFb7HDhmB1tY9iGFEc7K7U=
X-Google-Smtp-Source: ABdhPJxkORCp7gIYkTNw3KV3bdX3kmbwKYImn33rbcbzHbL5oapUbtQ9rTY8znVVhU8GFn8NowZFyg==
X-Received: by 2002:a5d:4609:0:b0:203:e792:3add with SMTP id t9-20020a5d4609000000b00203e7923addmr21101655wrq.657.1647938402451;
        Tue, 22 Mar 2022 01:40:02 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.googlemail.com with ESMTPSA id i10-20020a0560001aca00b00203daf3759asm16563813wry.68.2022.03.22.01.40.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 01:40:01 -0700 (PDT)
Message-ID: <216b98d5-a254-4527-c569-9f3397811e70@kernel.org>
Date:   Tue, 22 Mar 2022 09:40:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v2 3/3] ARM: dts: aspeed: add reset properties into MDIO
 nodes
Content-Language: en-US
To:     Dylan Hung <dylan_hung@aspeedtech.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     BMC-SW <BMC-SW@aspeedtech.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220321095648.4760-1-dylan_hung@aspeedtech.com>
 <20220321095648.4760-4-dylan_hung@aspeedtech.com>
 <eefe6dd8-6542-a5c2-6bdf-2c3ffe06e06b@kernel.org>
 <HK0PR06MB2834CFADF087A439B06F87C29C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
In-Reply-To: <HK0PR06MB2834CFADF087A439B06F87C29C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/03/2022 03:32, Dylan Hung wrote:
>> -----Original Message-----
>> From: Krzysztof Kozlowski [mailto:krzk@kernel.org]
>> Sent: 2022年3月21日 11:53 PM
>> To: Dylan Hung <dylan_hung@aspeedtech.com>; robh+dt@kernel.org;
>> joel@jms.id.au; andrew@aj.id.au; andrew@lunn.ch; hkallweit1@gmail.com;
>> linux@armlinux.org.uk; davem@davemloft.net; kuba@kernel.org;
>> pabeni@redhat.com; p.zabel@pengutronix.de; devicetree@vger.kernel.org;
>> linux-arm-kernel@lists.infradead.org; linux-aspeed@lists.ozlabs.org;
>> linux-kernel@vger.kernel.org; netdev@vger.kernel.org
>> Cc: BMC-SW <BMC-SW@aspeedtech.com>; stable@vger.kernel.org
>> Subject: Re: [PATCH v2 3/3] ARM: dts: aspeed: add reset properties into MDIO
>> nodes
>>
>> On 21/03/2022 10:56, Dylan Hung wrote:
>>> Add reset control properties into MDIO nodes.  The 4 MDIO controllers in
>>> AST2600 SOC share one reset control bit SCU50[3].
>>>
>>> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
>>> Cc: stable@vger.kernel.org
>>
>> Please describe the bug being fixed. See stable-kernel-rules.
> 
> Thank you for your comment.
> The reset deassertion of the MDIO device was usually done by the bootloader (u-boot).
> However, one of our clients uses proprietary bootloader and doesn't deassert the MDIO
> reset so failed to access the HW in kernel driver.  The reset deassertion is missing in the
> kernel driver since it was created, should I add a BugFix for the first commit of this driver?
> Or would it be better if I remove " Cc: stable@vger.kernel.org"?

This rather looks like a missing feature, not a bug. Anyway any
description must be in commit message.


Best regards,
Krzysztof
