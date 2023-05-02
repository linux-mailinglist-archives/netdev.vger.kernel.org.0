Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009ED6F49A6
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbjEBSYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 14:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjEBSYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 14:24:04 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB71DEC;
        Tue,  2 May 2023 11:24:03 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1aaec6f189cso21971475ad.3;
        Tue, 02 May 2023 11:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683051843; x=1685643843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uyXrnPA+SkyO4YF2T9X8RYQ0xk0l+3Tn+Ec/OwFQBKE=;
        b=YB3v24W5xyeIsoNG7b4+SsjsszwJ3V0SySFaHCag1NHc5VerC3c+LYDwV/XE4Grcq0
         vgNCiPnTKvne6m5fX2vS3b4cYJqPco33DYRyolpueX6jDt6fQa286O1tuqW0HgxKQmDn
         Q/uMBim4/mqZwHJyxvd5SvFirWVaW9KqGmc3snJN1i4jj1sR9s212WJZXx2z6u7cfq76
         fV9G//AsBOZOKrPdDCOiDCIVWXVmhWynfosVRX0JmDSZ7axiC38HmCrvM1g6hdY6Sjrb
         pLOnHMylqAUsq2xAhtrRJqmshs4qMrpsHqfKESfZSRJ2oeDgnMHqg90cRePvpvgwdk5x
         auEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683051843; x=1685643843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uyXrnPA+SkyO4YF2T9X8RYQ0xk0l+3Tn+Ec/OwFQBKE=;
        b=Yd5i+SylGe1pB4qBXbMsBm1m5L+Moxk0AAruFViTKjJXXbL/7nnmKrDW6iFs7z7Qjq
         wVjRSm49fzUsdOgyrpx28G2U57GgpE9+n06DPLMt8UI4SFr+BRJWUqUwu8vSoyGkdhRl
         MknLAfwvx8oUM+5CEg3pSftWD7NLxXQnyFAorhJeVfWEVcxUoRV4ZHs2WhHtyf9bkNNr
         xKK9lt793VgpotqU3U15X1ZRJn3k34vBfScvRQy2IS3Uymfg5L1pMB6p8KPrQmloyodO
         dPxjcSU841i5UEW/dJJLwVKL0WwMx7h3Uwgrd+KOTD2FYZSnk/RCYU6cLfyvmBqKmFRt
         3aQQ==
X-Gm-Message-State: AC+VfDzSgwCKOLlMmiAN27t4lWalJT7t9jE7RVUf19Shgr/KI/eaQHlS
        RswEwdkWKKCr0LW8off7wJ8=
X-Google-Smtp-Source: ACHHUZ4LK12ztNRyp7y/Em4paeVtiFv9NYBulnnc1VUZwjGW57iY/+aNCpzRFQOFa4xyZqxiBXtfHw==
X-Received: by 2002:a17:902:ec8d:b0:1a6:566b:dd73 with SMTP id x13-20020a170902ec8d00b001a6566bdd73mr23045645plg.60.1683051843232;
        Tue, 02 May 2023 11:24:03 -0700 (PDT)
Received: from [10.69.71.131] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id jj2-20020a170903048200b001ab016e7916sm3072086plb.234.2023.05.02.11.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 11:24:02 -0700 (PDT)
Message-ID: <6dd0ae37-9de9-c1fa-002c-b2b114b094a5@gmail.com>
Date:   Tue, 2 May 2023 11:24:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net 1/2] net: dsa: mt7530: fix corrupt frames using trgmii
 on 40 MHz XTAL MT7621
Content-Language: en-US
To:     arinc9.unal@gmail.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
Cc:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230501121538.57968-1-arinc.unal@arinc9.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230501121538.57968-1-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/1/2023 5:15 AM, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The multi-chip module MT7530 switch with a 40 MHz oscillator on the
> MT7621AT, MT7621DAT, and MT7621ST SoCs forwards corrupt frames using
> trgmii.
> 
> This is caused by the assumption that MT7621 SoCs have got 150 MHz PLL,
> hence using the ncpo1 value, 0x0780.
> 
> My testing shows this value works on Unielec U7621-06, Bartel's testing
> shows it won't work on Hi-Link HLK-MT7621A and Netgear WAC104. All devices
> tested have got 40 MHz oscillators.
> 
> Using the value for 125 MHz PLL, 0x0640, works on all boards at hand. The
> definitions for 125 MHz PLL exist on the Banana Pi BPI-R2 BSP source code
> whilst 150 MHz PLL don't.
> 
> Forwarding frames using trgmii on the MCM MT7530 switch with a 25 MHz
> oscillator on the said MT7621 SoCs works fine because the ncpo1 value
> defined for it is for 125 MHz PLL.
> 
> Change the 150 MHz PLL comment to 125 MHz PLL, and use the 125 MHz PLL
> ncpo1 values for both oscillator frequencies.
> 
> Link: https://github.com/BPI-SINOVOIP/BPI-R2-bsp/blob/81d24bbce7d99524d0771a8bdb2d6663e4eb4faa/u-boot-mt/drivers/net/rt2880_eth.c#L2195
> Fixes: 7ef6f6f8d237 ("net: dsa: mt7530: Add MT7621 TRGMII mode support")
> Tested-by: Bartel Eerdekens <bartel.eerdekens@constell8.be>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
