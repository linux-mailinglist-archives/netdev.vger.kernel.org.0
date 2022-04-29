Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863FF5150AD
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 18:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379015AbiD2QZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbiD2QZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:25:45 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0857D115C;
        Fri, 29 Apr 2022 09:22:24 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y14so7316209pfe.10;
        Fri, 29 Apr 2022 09:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XSTCE5w7yy68SjWNVsRpb2HvHJSUSz9+mARNoZLyTIk=;
        b=kb2lbNEfSrq3tTDDVvzTWGuOQynzrkRx0M4SsbyOx4vGhPukRPzOQmeEFEFRCBPtbw
         jRYUOA6gkBxvJNJ0wdMYEi5KeLjUqEnY+kQDjTuNOoCeoFb2LTzU3hjUCWAuHaJnUAM5
         +laHoLS39VrFcVzE3X4qkG6KT2X+hfQeXkY+SRRCXPW3F+neYlQcg+I5XQvVeA6mk6pw
         kO8bIMQetGLUL7VWVnUcN9H7woupG1O3SXRVZbLbidv+l3gQFmrkPgfFD5h0SxUdHznz
         5s2n0G31vU0UO7Nz5ZIwE0selfJuLDPfEbkjZ8EBjpISm1DhvyyU9yCy+EFGIT1lzKjU
         JOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XSTCE5w7yy68SjWNVsRpb2HvHJSUSz9+mARNoZLyTIk=;
        b=LGF9v2QSurzm8Jatf7sQ+vACC2Cs9TDPWocM7arxah0uCHDZrMFp7OLFeK+RYL+5Gf
         /IWJiOR4bWFo4rDaDHxgWEWNI7x+cljVVIqXQ1gMj3d4cMbQPY6FJh1AVqbNkeCJVoaW
         Z+AbioHl5U3SB8mbAX2yf78/ShUVAyr8n1QDn62WtPOWxEmv0jhBt8JPjHZvK7HUjpUo
         LQy4VevgDqtX+KPZOZdMh8XNEVdGaiA+RHsL2wdWPPs2txQmjvDpVsDqQdUKRZqwHOUI
         MJE7FDdMu0lpd71vW4t/SNNL6ROy2toSqoEburH1VU8IwZqC2U3mmEXNlJjYiLYH35It
         JpbQ==
X-Gm-Message-State: AOAM531Bh0untWg5anysTvkhYkGTJdZsMNEDdhfFPJmaeQSNld9jyGK9
        OkXzwDZZQRdCBN1PdCICjbc=
X-Google-Smtp-Source: ABdhPJx294dO5ebgBnVWibhDdFXl85WArQeiLA5m9XKR2VzCmbwy/SZgK9FpWiGMTr2Eiub3lTVJDw==
X-Received: by 2002:aa7:96c2:0:b0:50d:90da:f8f with SMTP id h2-20020aa796c2000000b0050d90da0f8fmr199495pfq.52.1651249344360;
        Fri, 29 Apr 2022 09:22:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y9-20020a17090a1f4900b001cd498dc153sm14109289pjy.3.2022.04.29.09.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 09:22:23 -0700 (PDT)
Message-ID: <baec3c8d-72f1-b1b5-f472-ee73be1047d6@gmail.com>
Date:   Fri, 29 Apr 2022 09:22:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [net-next v2 02/12] net: dsa: add Renesas RZ/N1 switch tag driver
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <20220429143505.88208-1-clement.leger@bootlin.com>
 <20220429143505.88208-3-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220429143505.88208-3-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/22 07:34, Clément Léger wrote:
> The switch that is present on the Renesas RZ/N1 SoC uses a specific
> VLAN value followed by 6 bytes which contains forwarding configuration.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

[snip]

> +struct a5psw_tag {
> +	__be16 ctrl_tag;
> +	__be16 ctrl_data;
> +	__be16 ctrl_data2_hi;
> +	__be16 ctrl_data2_lo;
> +} __packed;

The structure should already be naturally aligned.

> +
> +static struct sk_buff *a5psw_tag_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct a5psw_tag *ptag;
> +	u32 data2_val;
> +
> +	BUILD_BUG_ON(sizeof(*ptag) != A5PSW_TAG_LEN);
> +
> +	/* The Ethernet switch we are interfaced with needs packets to be at
> +	 * least 64 bytes (including FCS) otherwise they will be discarded when
> +	 * they enter the switch port logic. When tagging is enabled, we need
> +	 * to make sure that packets are at least 68 bytes (including FCS and
> +	 * tag).

Did you mean 70 bytes since your tag is 6, and not 4 bytes?
-- 
Florian
