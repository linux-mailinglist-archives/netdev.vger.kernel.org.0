Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FDE6E0F5E
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbjDMN54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjDMN5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:57:55 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05801734;
        Thu, 13 Apr 2023 06:57:54 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id m18so15003180plx.5;
        Thu, 13 Apr 2023 06:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681394274; x=1683986274;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uvk874B56zkcSlWZBp0kUIwZTJmDy1uqT394brTEYCM=;
        b=oc5qL1xWXVWlzN60Y0LlbujBbR80RJ7HYwsAniFUa7Gcqggv1+reISFXH+SSN6pQ3p
         a7eiLsMacn3M1YqGne/Dyzrz/cSntp4ImefVONZzSttT3ugdLzCbIXQsuyibmQQfaTGl
         jNkcQfm/mwyyc0j1w4275ImGTgkF+F+NSJHTVe8seEvi66scaYAijUiBkFHyV8dbgaFo
         gE0FzE/8jtS2rTsNz9Be0t1U7OCFzos6tidnn4GOEVYwkDeT8NhcdRha+qtTEBlgGFG0
         F9ogiBKiojMbcyGlJQwdN+zb5uhPhiT9ANjs8Y73rcq2XI1Mnh0JPoAAhcx5tUONCQhM
         9wIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681394274; x=1683986274;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uvk874B56zkcSlWZBp0kUIwZTJmDy1uqT394brTEYCM=;
        b=X6yPiHqUvTLtsaSABq04xxQjoVXwYNfhIl8ZCsmIxLn9Cg4t9PZHSpWdu5/75AUejC
         icfawWqbnuT+y7O91TEmidb5m97B/o6P1ssmIWpkl2OjvoplRGOLn/wQG04Lx5FD02hs
         qlcaRPQTgwchP4Dtjyf27CZ9K+faJ8HILZfHPKU/eQRhdpb3yZXJH+E19nNxG7LW2EB9
         D3L+hImsNUj4AFap4PannjeBzsNGZEYs9UpDQczK1FqQXWXn9hdg2X4LOX0H6iEmzckm
         wye2txGiyXVJyMdamjH2ik5RwHYpA78v/ePjx4240j4OKQRskZjLZJiYYQK0qG8Dgts5
         QHPA==
X-Gm-Message-State: AAQBX9e2xkbh6Eu3hmxsuOd2/JIQQ9vNGcInnsWbN3xFrX2G9ctrkrNU
        fnIWHIBRcbNC8p+x1sCpPeI=
X-Google-Smtp-Source: AKy350Yu0Hy9vj5CNIGW20x7IfGM9iZMMbMBJUU1eS3qS6NCecx0LNah2qcJR/p4VF1WEineV14S+Q==
X-Received: by 2002:a17:902:d4ce:b0:1a6:81ac:c34d with SMTP id o14-20020a170902d4ce00b001a681acc34dmr2280223plg.28.1681394274243;
        Thu, 13 Apr 2023 06:57:54 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id jd14-20020a170903260e00b001a1a9a639c2sm1515927plb.134.2023.04.13.06.57.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 06:57:53 -0700 (PDT)
Message-ID: <202ae4b9-8995-474a-1282-876078e15e47@gmail.com>
Date:   Thu, 13 Apr 2023 06:57:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next PATCH v6 06/16] net: phy: phy_device: Call into the PHY
 driver to set LED brightness
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-7-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230327141031.11904-7-ansuelsmth@gmail.com>
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



On 3/27/2023 7:10 AM, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Linux LEDs can be software controlled via the brightness file in /sys.
> LED drivers need to implement a brightness_set function which the core
> will call. Implement an intermediary in phy_device, which will call
> into the phy driver if it implements the necessary function.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

> +	int (*led_brightness_set)(struct phy_device *dev,
> +				  u32 index, enum led_brightness value);

I think I would have made this an u8, 4 billion LEDs, man, that's a lot!
-- 
Florian
