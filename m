Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AEC67EE6E
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjA0TlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbjA0TlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:41:07 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51BB8015A;
        Fri, 27 Jan 2023 11:40:30 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id e8so4974676qts.1;
        Fri, 27 Jan 2023 11:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1erBTYhV8CLOdjFlt+330xi7w9otwJlBGu7FDXFCEgM=;
        b=DjJwpFA+4n72TtuoYc1J71/qUwOawvpKWIo3nRuX2LNpASGzu0Z+YnBpbn9vVGs9UE
         dVWkE1lkUmbZdVLOtqJlQYeokWWhgS2njHAsKQyUBFHyYe6STyJNnVdXttJbIC8Kz0RZ
         kuWRDqBQYPJcK3Y6w4etndkAiPm9xDovXoYxcdhELr86brvh7t21RhjurJGNdXCfOobb
         5ntNDAuq5fvW6h79G45FjFqBahx9599Dy+ordAdigw6Q5sIvY3UzWvNN0EFizImIiOas
         hNusXPw7hqLH3awf5tzfCEKOz3qGRfcrQizgp/aL+QJ56yrS7H4YHH/bcGLHBjoBtL8U
         dsFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1erBTYhV8CLOdjFlt+330xi7w9otwJlBGu7FDXFCEgM=;
        b=ps6IknOwzHOqFKmEyO2jDvjCBxTgXnxwjRUTeBDb/Vd2RbgmVnoJ29todlXnpZxr0t
         oRxi/F+Rlnr0Jt2/wZM5gHfviyKb/h6vf2yoih43qaZmZ15WfWVCzHSAAhrPq/JwRT8/
         H0B3zWC5ZR1MRGKCPbFMj+P/3RajNXukJ13NVfz+UqnRhhN0CHyUdDAhyGs+hxST3orX
         irRUQjxK+8vy55avgiTMTTpWCciYRgA1BJUv9JnYirXtsDnz5qMnkQK2HlvHnKHA7Reh
         E1GEV0pKnVgdNeXg8pnPK/JsiWQhAjS/lWMsevK7hZX8yUiuQI42qoVDI0+PfjD/5rPL
         ETPQ==
X-Gm-Message-State: AO0yUKXgnUxoa9Af8vRdC8gHmDa6PrLjRbixM21OZVwbSeBzyu+iOniX
        bsxvd5kI4RxSJslc9P30t/s=
X-Google-Smtp-Source: AK7set+xTl6RpO4hqG8Oj/y44JtdMiMbw5oaahiZdyru40LsGMmtY6aRhLEGehR0/CLWbCefKSOIAg==
X-Received: by 2002:ac8:5ace:0:b0:3b6:8bc3:a09c with SMTP id d14-20020ac85ace000000b003b68bc3a09cmr59446qtd.25.1674848361775;
        Fri, 27 Jan 2023 11:39:21 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 3-20020ac856e3000000b0039cd4d87aacsm3213303qtu.15.2023.01.27.11.39.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 11:39:21 -0800 (PST)
Message-ID: <472892c6-11b3-b3eb-a859-f1086c9c4d93@gmail.com>
Date:   Fri, 27 Jan 2023 11:39:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v5 net-next 05/13] net: mscc: ocelot: expose
 vsc7514_regmap definition
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
 <20230127193559.1001051-6-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230127193559.1001051-6-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2023 11:35 AM, Colin Foster wrote:
> The VSC7514 target regmap is identical for ones shared with similar
> hardware, specifically the VSC7512. Share this resource, and change the
> name to match the pattern of other exported resources.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
