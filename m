Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707D23B2571
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 05:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFXD34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 23:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhFXD3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 23:29:55 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DA2C061574;
        Wed, 23 Jun 2021 20:27:33 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id g19so2580354qvx.12;
        Wed, 23 Jun 2021 20:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6BySdzNVQYhIv90tT7J4QnjMzf7GOediSrHJcYggFgM=;
        b=NiyGAXctTfQJOUMhwq9YHE7SLoVzBQGApi6oEuie5hWDfW7JAPeidPRkw5yro5Fp8j
         rxnACRroG50cblAP2Lwy9LHpcjp2aUjeOGDxMApEpKy+h9VP9GmUgLiXA2eOLbZH1HwR
         fsMqqDc+jyqOTvOjnuwvDtAm6QY6gEGvGfAeHy29CPtPmmtcvItCBaGFL9paTrAFtcCg
         TVD0GafbX3dIvgAPJmdlI/o9IZaEHrnp29Q2zGp+ViJdHPSz6JKB80A62JtrpY6qRtHV
         1iEUvvxVgyVf5pQQty05upEUmtRotUbp862WPR2qjWjVKi3BoU+amT6L/yrF0Yl+xEfr
         gKUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6BySdzNVQYhIv90tT7J4QnjMzf7GOediSrHJcYggFgM=;
        b=auzoy7p9DXDa6d4Bq1LtzD/YHMl+MIded5eW9+3LpFC5ARyvbmzWVTjWsSTjph1Ckz
         FJorm7moTr1hsB2jpZTgV1Ik+tgePvpHOwEWJtW7a6wrYowzZ+42nqGpTnXUN50BPb82
         nSpunZXixktoQzv+75h87th9yPYIbUwq+6QUm+8cj2tY+0GJVfMaPN4fPsvFv22dFcIR
         35jwW9WekX2dB1IuxiZao5+jC6o6gX61dOkUMLAxhTfopO1W+tg5q1dbg8yyY2+/eU3D
         y5R1R3optaNiukrX39Sgss6OXeIxf8wIpkIvTTyjM36TmhG732beW5JFRVOfVx0Sg+H0
         OeGg==
X-Gm-Message-State: AOAM531GoflD2rny8FoivGos/9Zah69EeCbC2ahaSYpmoWz90myeuqr9
        ph52fKXUunXIjFt5oS8YGvM=
X-Google-Smtp-Source: ABdhPJxWM1d1ON/iK6uJVBtqsItIMgrH+IsQi/f6pmkpNmDlIMxJ7SGysltZuGGdxIyzMbLiV0CxlA==
X-Received: by 2002:ad4:4852:: with SMTP id t18mr3349864qvy.33.1624505253002;
        Wed, 23 Jun 2021 20:27:33 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:d597:85ff:418f:90ba? ([2600:1700:dfe0:49f0:d597:85ff:418f:90ba])
        by smtp.gmail.com with ESMTPSA id m187sm1463960qkd.131.2021.06.23.20.27.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 20:27:32 -0700 (PDT)
Subject: Re: [PATCH v2] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
To:     Jian-Hong Pan <jhp@endlessos.org>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        bcm-kernel-feedback-list@broadcom.com,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux@endlessos.org, linux-rpi-kernel@lists.infradead.org
References: <20210623032802.3377-1-jhp@endlessos.org>
 <162448140362.19131.3107197931445260654.git-patchwork-notify@kernel.org>
 <7f4e15bb-feb5-b4d2-57b9-c2a9b2248d4a@gmail.com>
 <CAPpJ_edpVxbnPBGTrkvB8EY5mt_sgPmoMv7rBdUKUHZJnjhHNg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <20eeedec-4ec2-7aae-2e80-09b784e1693b@gmail.com>
Date:   Wed, 23 Jun 2021 20:27:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAPpJ_edpVxbnPBGTrkvB8EY5mt_sgPmoMv7rBdUKUHZJnjhHNg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/2021 7:47 PM, Jian-Hong Pan wrote:
> Florian Fainelli <f.fainelli@gmail.com> 於 2021年6月24日 週四 上午5:19寫道：
>>
>> On 6/23/21 1:50 PM, patchwork-bot+netdevbpf@kernel.org wrote:
>>> Hello:
>>>
>>> This patch was applied to netdev/net.git (refs/heads/master):
>>>
>>> On Wed, 23 Jun 2021 11:28:03 +0800 you wrote:
>>>> The Broadcom UniMAC MDIO bus from mdio-bcm-unimac module comes too late.
>>>> So, GENET cannot find the ethernet PHY on UniMAC MDIO bus. This leads
>>>> GENET fail to attach the PHY as following log:
>>>>
>>>> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
>>>> ...
>>>> could not attach to PHY
>>>> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
>>>> uart-pl011 fe201000.serial: no DMA platform data
>>>> libphy: bcmgenet MII bus: probed
>>>> ...
>>>> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
>>>>
>>>> [...]
>>>
>>> Here is the summary with links:
>>>    - [v2] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
>>>      https://git.kernel.org/netdev/net/c/b2ac9800cfe0
> 
> This bot is interesting!!!  Good feature! :)
> 
>> There was feedback given that could have deserved a v3, if nothing else
>> to fix the typo in the subject, I suppose that would do though.
> 
> I can prepare the v3 patch with Florian's suggestion!

Too late, once it's merged only fixups can be accepted, and that does 
not include commit messages, it's alright.
-- 
Florian
