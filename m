Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07B123C0B1
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgHDUUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbgHDUUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 16:20:32 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8455C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 13:20:31 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f7so38623754wrw.1
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 13:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dAoqumB3DzP0zMt0dLEL+Txc/hVSzHBcs9dqx6X9/Xk=;
        b=HfqX017XWj9FEW6I1P8DXdtUSblBHKcT2D4QOC2xmSA8cB+FSoeTbs+X+GlhaYXj9V
         CS5hwXsqg0U2/n7ReSGlJ0/B/4YS7PDt6xVUBbsAnJ0fxv+V0s78Jpi+bFnMxqM3Qb0s
         I2wGkRowI34hXIoPzSYNBjCSdpwLUwNqRoT7ou7Oag170HAczLU+JoEda2k3nFBYVf49
         eFaswOzm+jHgBPGVAOsH5BnQ4kppr/yNLREyUHXxeXKz+qT/TvIlrlguy9ipyvO0IX/A
         AzFxJZ3LTOLsnqTsTfJC7rcIZ3nMP3FrfgydJlLSSQbP3qsudtsndeRqJMSf2YBBOkwV
         2ukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dAoqumB3DzP0zMt0dLEL+Txc/hVSzHBcs9dqx6X9/Xk=;
        b=WMonoZ66NcUKzSZJo8vfQdrJt3K3XXk7wgKewrGc+82Bgf/K5rI13Xwku+fwGBvlA9
         MT8Ae46NA/u2q4Ian45l8wRROaybEtadC75K9tBKS16eum7F33YfF1p6fcqXIQNAtdIX
         fEALnDsBL4+/iy83DO9oJq8QtTgW/CfQJVaKJAW++bJbhth4iEsduYmj3PPoG5FtvgLS
         +tKOXtKRtyE4C70F+6W91ooiHxwgNMrx4kAEh8VZb0F5TQ8O0FUzObfBoHFkd9xMTieZ
         7NptUUnUfuATG9Y63inFeQ5tEqFT0gKi2z/iLwwtN96Xvqldx3pmg6gF93MNg0P5fr8W
         ko1w==
X-Gm-Message-State: AOAM533IjqpVULpmyjZ+kGTb/VacSY53dfGMd2vhfXlDKaM3dcKMW/u9
        H23BeY0JxGOLH2ILyBy/Da7MDrFD
X-Google-Smtp-Source: ABdhPJx2MK6Z36EIRD5Juvwej3G0xmJrNi6WpiStXXqa4Ob5mIwUtTb9fU6sO0cpQS0OCH2BJvNoDw==
X-Received: by 2002:a05:6000:12c1:: with SMTP id l1mr19881936wrx.270.1596572429072;
        Tue, 04 Aug 2020 13:20:29 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l1sm33034873wrb.12.2020.08.04.13.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 13:20:28 -0700 (PDT)
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
 <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
 <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
 <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com>
 <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
 <800bbbe8-2c51-114c-691b-137fd96a6ccd@gmail.com>
 <20200804195423.ixeevhsviap535on@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b4a859cc-1e17-67c2-a619-968e9fcfaf10@gmail.com>
Date:   Tue, 4 Aug 2020 13:20:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200804195423.ixeevhsviap535on@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/2020 12:54 PM, Vladimir Oltean wrote:
> On Tue, Aug 04, 2020 at 08:51:00AM -0700, Florian Fainelli wrote:
>> "I looked into it deeper, the driver does rxvlan offloading."
>>
>> Is this part of the driver upstream or are you using a vendor tree from
>> Freescale which has that change included?
>>
> 
> Does it matter?

If this was a downstream problem yes, there would not necessarily be a
pressing need to address it with a patch targeting 'net' for instance.
This is not the case, therefore it should be addressed.

> FWIW, mainline fec does declare NETIF_F_HW_VLAN_CTAG_RX:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/freescale/fec_main.c#L3317
> and move it to the hwaccel area on RX:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/freescale/fec_main.c#L1513
> 

-- 
Florian
