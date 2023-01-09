Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BB26635DA
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 00:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237930AbjAIXtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 18:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237550AbjAIXtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 18:49:01 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B23F46;
        Mon,  9 Jan 2023 15:49:00 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id jr10so2318475qtb.7;
        Mon, 09 Jan 2023 15:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rszgv4ftpflSP0hfAbu9auGucePJ+YbSLRVLVyYuDXk=;
        b=bq0pFZG6HYlFRfwv/fEiuOtG+U2H0ZPh+d7TNDidxHUedHGkhXEiMIhrSS73kbvXr0
         9WwhVBJL1CqXfCiMUlUIz22JOdVF5Y8RpGyYnlWqzlN1D5ohpb/b2xycl6ppik2u6x4T
         6Jz3cm4uMHYmAmXHagTUf1ychN2iuHsxPmbsfG7Y2KCjeCirQxaNET9wp6rMhvKcApyJ
         UT1/edkqnYKXg5NNDRn84s6DmgcVAZ7ZOTuuCd94ZXekEy4SKpFL33vNCO1yCHnLW2u0
         NlK49731n7jqJ0BJz+0BJQf9N1L6hNUo/9zU9zY45qcl0jtZbY48Vn8kQoRBDrSHzhQJ
         +sAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rszgv4ftpflSP0hfAbu9auGucePJ+YbSLRVLVyYuDXk=;
        b=hbxmmwm/Ctk4Zxav6vDskLsvNSHhOfhds5h95PKnBChRRqnpxQjPbC332vFSfP2URH
         EgIGQEFJD5i4aEKXnBRi7GamSfamZPTRGvLZSx4/sy9iOJJFPR/SVz5mGLBRWKTeGDFk
         +RqU6ckKoF0EJ1FXSLpf7Abn1AmLFOUVx6oJS1JCfNrDQ9VJ2FqDI3APUiHzAlbr3ynf
         67UK4uTpGw/KDx0TSySGiXE/EWa8F8nxxYWxiL9xeC0VsyGmHDviNN8Qbu4DhFcLIlIx
         /NWzpDNPNYTUU1WgrSYs89r+/lDq9gIg6//hom61LLBUfx/cn2yjvp56RVfUVZU4F9ej
         91Zw==
X-Gm-Message-State: AFqh2krwBrbK01tBuq4bTZ+iU1w8T9pvFXnMwrw1fnxkHJhe7cEa/HvB
        6Yq5Yy9rxLnLmNBUYrDJhb4=
X-Google-Smtp-Source: AMrXdXsFyUnhOqKpDyFw2zu3D79IHlXWFEnxcd+MLCh7XJ/2VlzDOwjVoHObK/9LFIy/K0bCx6rOwQ==
X-Received: by 2002:ac8:764b:0:b0:3ab:d179:d49e with SMTP id i11-20020ac8764b000000b003abd179d49emr1219580qtr.45.1673308140043;
        Mon, 09 Jan 2023 15:49:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x8-20020ac81208000000b003999d25e772sm5205577qti.71.2023.01.09.15.48.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:48:59 -0800 (PST)
Message-ID: <101995f8-ef11-c3e8-f50f-02aaa62c8e8f@gmail.com>
Date:   Mon, 9 Jan 2023 15:48:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v3 02/11] net: pcs: pcs-xpcs: Use C45 MDIO API
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20221227-v6-2-rc1-c45-seperation-v3-0-ade1deb438da@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v3-2-ade1deb438da@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v3-2-ade1deb438da@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/23 07:30, Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Convert the PCS-XPCS driver to make use of the C45 MDIO bus API for
> modify_change().
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

