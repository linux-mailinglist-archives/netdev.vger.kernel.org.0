Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0658F54BD06
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357172AbiFNVvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355115AbiFNVvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:51:37 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AAE522F1;
        Tue, 14 Jun 2022 14:51:37 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 123so9688700pgb.5;
        Tue, 14 Jun 2022 14:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VuUbr9hQqzKaVq9n4+d7s4wZFCfkEeiNzclq7d1jnbg=;
        b=C0LAzHrCJ9U68PI3/LjggUfXQz94N12msgIGu9Zrj2dwdH6p64ic/iMtbLiqJ12Uf4
         KKaileOZxLpd5Q2H8eSkE6ka3W08KLjRb+c5JQh1KafZDNGFUCaqB4/BEY9WFFJdzA+/
         4HkGFK5i9Q4+Iq26SlYTexgylYxp/gZL0DqYScn7vBTcHL3AJeLylO32Q2jFLPerSk/j
         TVNH3ZgwYPXDcBX52JM6fjpcC2SYtMGd7j7LU+acI33xT4Zp3F8SHmQt+vt5FpA/VaUz
         9doMnn8UpGTa4unwWzQ4v8en5IzgIDLPQCtaVwp4OKZCZVDbtOBEq1S4CUyRv6z71lFB
         u6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VuUbr9hQqzKaVq9n4+d7s4wZFCfkEeiNzclq7d1jnbg=;
        b=cG/CPhftL4u7IHIBTZyfXodDzhZZt3KaI5BPA/6C5xL+ivR/n2JMigno9l+hNuiZtG
         chKkyl7ntPM/hRFI72C/ZSk2BmB4J6ONxQfSDdF9qP0h7YZdP1w/sU/q81Ngf/oRnK2R
         Xa82MtoIEvuFOj8WBnrl+bJJ+9GCbAl6b1z9YS7KciR5yym2VIBcQhqiK/3gePXJZcKh
         Sl+y0HjJ+tGJHSoXwoA672sbEBMPTRGteNA0njPbRZYBnJdOMX4okWjiy8JurHYrG4XZ
         aJZN4nqp70ixKHA/iBx9b+XrNJ15nmcVBEnv/hmHMnKKniC31YgKYgL4dMcMwKyE0BtR
         Z28g==
X-Gm-Message-State: AOAM5330xD6Q9PvMxv5xCuk5PPk7aO/xgbRZ6m36Z6h69QiWMT4vwQBT
        0IpEzz319FqxgvbQuFxuPPY=
X-Google-Smtp-Source: AGRyM1s4IOseFf+0LQA8Wc97A2HgVlIfB+FfEdgkM+g8MX2D0/VjMQZVHyJZc1d+1JC4tM+hQ3Phjg==
X-Received: by 2002:a05:6a00:b51:b0:51b:f772:40c5 with SMTP id p17-20020a056a000b5100b0051bf77240c5mr6343737pfo.22.1655243496705;
        Tue, 14 Jun 2022 14:51:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h13-20020a17090a3d0d00b001ea5d9ae7d9sm67289pjc.40.2022.06.14.14.51.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 14:51:36 -0700 (PDT)
Message-ID: <06bc97ae-f16b-72c1-b4f9-8306a4bbad9b@gmail.com>
Date:   Tue, 14 Jun 2022 14:51:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH RESEND net-next v7 06/16] dt-bindings: net: dsa: add
 bindings for Renesas RZ/N1 Advanced 5 port switch
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
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh@kernel.org>
References: <20220610103712.550644-1-clement.leger@bootlin.com>
 <20220610103712.550644-7-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220610103712.550644-7-clement.leger@bootlin.com>
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
> Add bindings for Renesas RZ/N1 Advanced 5 port switch. This switch is
> present on Renesas RZ/N1 SoC and was probably provided by MoreThanIP.
> This company does not exists anymore and has been bought by Synopsys.
> Since this IP can't be find anymore in the Synospsy portfolio, lets use
> Renesas as the vendor compatible for this IP.
> 
> Reviewed-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
