Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEC154BDCB
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 00:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353630AbiFNWie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 18:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353695AbiFNWiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 18:38:23 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4C5506C2;
        Tue, 14 Jun 2022 15:38:23 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id hv24-20020a17090ae41800b001e33eebdb5dso2350022pjb.0;
        Tue, 14 Jun 2022 15:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MSFR5gI9wUNub/ZSpto9GgyChmCRsCaQPpnAQmtSwaY=;
        b=a6WmxvO7u8Wto5TWE/+eqSzL+M6m8EebKm54UrOaFSJnZ5I48dVOwrGTrA06My+N+3
         XLRg7PkI0woswJ2Sz3Y8t2qXTNpRsZcuzshHEV3cAM7mgQ7lb0NuftOztq0lMyjQvp/p
         4iys1ABu7lQ4TWvrAYwGn7JyaJ2LnC17Pr3AVNdfVTCC7pNk4n9GeuuXiuUI9374c9J8
         550rQewazo9nvRaE5suJV9P1GG9XY3lVeNrjXUejJfqAqkQsm4s1vE12fDdxWzpBKJAj
         kjikW8JOcpwql2y5w9ieeutMackza5AhnZMUrL7yqu3aEZHVQoQnDXz4SM/0hGv/kPuF
         hCtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MSFR5gI9wUNub/ZSpto9GgyChmCRsCaQPpnAQmtSwaY=;
        b=4T5Zc8VEYJjk7O9k1nVgKT+v+191B7uNszBH3ZlnXgmxOnAcE9W+RQLZ9jupznN9xo
         lxidMBXiEUTz3KnTcE8Xm66OsapXl5ae05MOKSQRweiStJ1HhnmneCT6dRufUtvrkcBM
         s+5Oc8KD5E7EeIi08qVqcPARoQ63QeJLnUmDa9ofZDyaM10ZcSZM7lDnHaTBCApaWUa7
         SXqp2nuQC81lYMeUQHsQeZ9Yk7Z05sSPVovNbuugPp87gwNXUqMPjhx36oR6KzrOloku
         bvjOEP5tmquhUtaTSo1284wbr/bWciopgksau2hw59e2A+bl8sl8F73dZvvHefYnVzFX
         nC6Q==
X-Gm-Message-State: AJIora+B+MlsPLhNoZXE2rYLH/4bvcf6W3k8pRSG/PmoME+JFp9zege7
        fiBbsfQ23If52htsC9OkOtU=
X-Google-Smtp-Source: AGRyM1tmDYfyXc0kKb1nG6kmjqYeG4UHCuj0PHfYOCrNvAI8T5jdAxJ7ZT/jlyZuexSDe2/xV5ZLTA==
X-Received: by 2002:a17:902:8c93:b0:167:879d:6670 with SMTP id t19-20020a1709028c9300b00167879d6670mr6497581plo.31.1655246302373;
        Tue, 14 Jun 2022 15:38:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y69-20020a62ce48000000b00522c3f34362sm3359pfg.215.2022.06.14.15.38.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 15:38:21 -0700 (PDT)
Message-ID: <ee3e06ff-646e-7129-722e-051aaac0af4d@gmail.com>
Date:   Tue, 14 Jun 2022 15:38:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH RESEND net-next v7 08/16] net: dsa: rzn1-a5psw: add
 statistics support
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
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <20220610103712.550644-1-clement.leger@bootlin.com>
 <20220610103712.550644-9-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220610103712.550644-9-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/22 03:37, Clément Léger wrote:
> Add statistics support to the rzn1-a5psw driver by implementing the
> following dsa_switch_ops callbacks:
> - get_sset_count()
> - get_strings()
> - get_ethtool_stats()
> - get_eth_mac_stats()
> - get_eth_ctrl_stats()
> - get_rmon_stats()
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
