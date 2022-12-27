Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1BF656931
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 10:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiL0JxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 04:53:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiL0Jw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 04:52:28 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBC3A465
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 01:52:16 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id b3so18969537lfv.2
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 01:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Wr97SYXbDVVyZVbytiLskD6+gchYHrxEC/WA01J5dA=;
        b=N5zZrCr5jGWU0PNc0ktwf74ghaOf/jNfXrUuqPOk+v+DzhKUAHoLFwcsXrzodnL7tQ
         cDBWqu7QlrbeuQSLhZ/0Z15Iao0JiSE7o1hMQu/NhQ+SEzCsifT0jWRx5BdChTBOTZIo
         wofxIhUW5v/oNhN8KsChmIEgqyGy8qQkGeJlQjrOPsh2UqlTI1z9drSb/cOQK8qrSB6Q
         oKQ56CBniGkDwLbMoMBOr85emDqhm6tRjKEvNz48rz0kYZPWe4S0WOeHLQp+rnfNto18
         m8OyyFJ3u9dvOfiLugeoZo2liVpuBQ/bOn2zY5aiBCdz/oP3ZjSdTU4ub3m7zx84Wmpw
         uyhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Wr97SYXbDVVyZVbytiLskD6+gchYHrxEC/WA01J5dA=;
        b=tAxJ63AVHtISYyeTkKECbImOnSLo7yLNDF1IEe61Sr2X2oJ7+ls4UlkEaGc9VPq5v8
         IeyclBMWKyETeeyjpDzaNNXtZFJXOpqN4lJKtr+6rnBGShToPBT6LdpxKZPE06lvNXyw
         nC5IpCT8i8qjp3pWO6LkggXYUmL4sysvR6ITeJUYFVDaKiacMkylLsbCp38cVsJ/TPHk
         qUaRRaoIxLVsO5kWya7GOvot67X4bMJJV/7BCoNavv90g/EBR65LQB3PVkXIJ4ZeIwNo
         58dltrstXnTajnfc98/ldSvQrKq7sE7kbsnx0iIKJVfhNJ4UUSMPoQCmlv84qSAMFw2d
         TUBA==
X-Gm-Message-State: AFqh2kofGQYd1Vler6e34gtnddU7Tu20+jAARk+Ej/tNxQXvgNbrFCZ9
        h/WCEh/Mq3oyLbL4lEOq7oVf05Ac4iT6lorb
X-Google-Smtp-Source: AMrXdXv0e2ffNVRfwokE/9RQbPQsXbBIx/hqMsDpgLFJrwc+icn7OJe/v3aXVR/9FghthYK1ObYaKA==
X-Received: by 2002:a05:6512:15a7:b0:4ae:8476:2df with SMTP id bp39-20020a05651215a700b004ae847602dfmr8295564lfb.10.1672134734752;
        Tue, 27 Dec 2022 01:52:14 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id h13-20020a05651211cd00b004a2511b8224sm2144989lfr.103.2022.12.27.01.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 01:52:14 -0800 (PST)
Message-ID: <c296cf6b-6c50-205d-d5f5-6095c0a6c523@linaro.org>
Date:   Tue, 27 Dec 2022 10:52:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 5/9] dt-bindings: net: motorcomm: add support for
 Motorcomm YT8531
Content-Language: en-US
To:     yanhong wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
 <20221216070632.11444-6-yanhong.wang@starfivetech.com>
 <994718d8-f3ee-af5e-bda7-f913f66597ce@linaro.org>
 <134a2ead-e272-c32e-b14f-a9e98c8924ac@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <134a2ead-e272-c32e-b14f-a9e98c8924ac@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/12/2022 10:38, yanhong wang wrote:
>>
>> This must be false. After referencing ethernet-phy this should be
>> unevaluatedProperties: false.
>>
>>
> 
> Thanks. Parts of this patch exist already, after discussion unanimity was achieved,
> i will remove the parts of YT8531 in the next version.

I don't understand what does it mean. You sent duplicated patch? If so,
please do not... you waste reviewers time.

Anyway this entire patch does not meet criteria for submission at all,
so please start over from example-schema.

Best regards,
Krzysztof

