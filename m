Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D73A67EE6A
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjA0Tk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjA0Tkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:40:43 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68B379CB3;
        Fri, 27 Jan 2023 11:39:58 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id o5so4936121qtr.11;
        Fri, 27 Jan 2023 11:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wmRUjydLjfJ9f1t3wlnU3sTT4LspNLFXBwlUbd50Ym8=;
        b=Akxf7W1LhIqDJPrDYm2phAD+wy/E6FQB0OH7N1teYJPkRp/doUpzslyecl+wRtc2pB
         Dq/liu3c1PcmYg51dUYF+plaXPYEEP3TYgQXD7RJscozO28Icam68cYOTIrm7Y7vQBGd
         SBBf2+qmewQSOxCTvoIS+tKejp8C9499/y4pFc0AlVgF/q935FtrFQ9C4FPoxo4emOnb
         X00LJ0VYQ1JOQk1QrhSMfTESC5uDKIjtvOfNMioHqU9cE4C31WfWbr0aEuGUMdytcanu
         xyzZdz4gMCWDl1w2lRZSI0MaqqLlBPrZC3DRUU0xUEp7tYJwlDwZLMjIcEmUQVwZESOV
         mV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wmRUjydLjfJ9f1t3wlnU3sTT4LspNLFXBwlUbd50Ym8=;
        b=DB54PMourykj6MQEIgJFfrf3e+/NbSNA5onsywaF1mNL+/7b7MQArV4oaBMtRxXfKs
         To7nX88JQ3NWXmBrPzp0ucGK3Xf3aca5eRIcR+mCezGT/cnN34TmOP9WWn6hNDTwDmK/
         JZzwARsaU6mJd7gvoc7papIDCm/zN90d1EbU3Bg7ble80coR3qySl0QbumoZIEm5ye/o
         S6JtAZWDrCz95maWHTdZWBlUqXlxlGszg9JtgvLlO5t5qT9XyMZ5mK9hDrGd92PuwDvp
         tHAKTra+sezaQ+ALHcNZ9Opa9WqeT6tlV8zIkIzG3KBnLMACQAtddkOAWlg1tvQ3mMG7
         xAHg==
X-Gm-Message-State: AO0yUKV1xVkGhxKQ04X35tRqgKWQJCA8zGlceLkcj6Co7JvW/EVrtG3a
        Yqs6opkTpNUArjAHaDm1k3A=
X-Google-Smtp-Source: AK7set8o0un9IMcN3ZScMd6xeVwBvBHO+j0OKDfh7+P6IjJja+ZiX1dFoeYWixiv9zM2iMtFAvjGzw==
X-Received: by 2002:a05:622a:1ba8:b0:3b7:ed01:8728 with SMTP id bp40-20020a05622a1ba800b003b7ed018728mr147578qtb.12.1674848343833;
        Fri, 27 Jan 2023 11:39:03 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id o25-20020ac84299000000b003b8238114d9sm1499511qtl.12.2023.01.27.11.39.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 11:39:02 -0800 (PST)
Message-ID: <a4b9b0ca-5e85-3de6-0ecb-862aa2062f4f@gmail.com>
Date:   Fri, 27 Jan 2023 11:38:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v5 net-next 04/13] net: mscc: ocelot: expose ocelot_reset
 routine
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
 <20230127193559.1001051-5-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230127193559.1001051-5-colin.foster@in-advantage.com>
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
> Resetting the switch core is the same whether it is done internally or
> externally. Move this routine to the ocelot library so it can be used by
> other drivers.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
