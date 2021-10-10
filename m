Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4313842804A
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 11:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhJJJvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 05:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhJJJvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 05:51:21 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC80C061570;
        Sun, 10 Oct 2021 02:49:22 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id n8so57346778lfk.6;
        Sun, 10 Oct 2021 02:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a2/MrncRWVKL9otdqQ0i4zx9AftIr4djrzJPe4gxLKY=;
        b=k1SUwNcjMfjPRtDT9wcFikDLywkBUjElWT1S3KkN3A1+Yig49KslXX6D8lZ4HXPvh9
         DPjziaEI7ysyYy96ck7AwQUi7+15a462HrQszo3mzoxoqtAJxibW8426nUK+re+NnfQk
         Cwd7MPcGuJMNoEV8D83GjrrDp4M9ZYYrfLlPp7cdaJsiYj1SDEbcBJQsFJoshnJy305Y
         yaH0No1LyFsl8wEALoUc3QJlZqYGzU9D0eq8+52qk0Snf67wcJGZ7GaK0j4EQbq2ZUan
         Ahr3LHZ10LoVYQ0RdCHYlEu10ElBFP/LUXyddlFhcKKdOka3bxrA+CADo7flet087KUn
         54wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=a2/MrncRWVKL9otdqQ0i4zx9AftIr4djrzJPe4gxLKY=;
        b=Z5t4P0VeJpgrMH/IfKGXlwEYu2BHh4rYpt/cCVyZq9OhLVEQp7UTiVvB1hEJiAbifD
         bgosgFJHB/0pV34tpr8isor5voeA+aIuRQNGbmZJKNcTi38xID0zmOqaje8pvjYGhrK6
         xfYsyV//96eQL2FQMLqIjPxlSJtjGokiLoW5DRDr11X8zXe1ohHAJP/59SKsPtFDQXC2
         e8JOnrH0dyiOjzAxH7W/9L6BvbxRJjtN5rawNEt9T93bnX9R9zGcyYehK3/BTIi8MT+q
         ItvxX2JTuiMVqF3HMp1HyX4pPZNi3wGGodhJvKuBIHZ2XdfFcF01nDmI85xHlH6AtRTU
         7QPA==
X-Gm-Message-State: AOAM531g59La8lZoBs8nh6uyJprS2PMixoznYwOR58PMrcX8EzMrV5Qy
        A1A/VUz3nXFpmp+5ub8mMi8=
X-Google-Smtp-Source: ABdhPJyBLos8XkbAKVlsdhD+5SjFX9sWWyApMWzwvWj0DFqZETUznzVeky9lov2A3ZGsdmZSkRBNZA==
X-Received: by 2002:ac2:4e98:: with SMTP id o24mr21488077lfr.295.1633859360846;
        Sun, 10 Oct 2021 02:49:20 -0700 (PDT)
Received: from [192.168.1.100] ([31.173.85.147])
        by smtp.gmail.com with ESMTPSA id q189sm423644ljb.8.2021.10.10.02.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 02:49:20 -0700 (PDT)
Subject: Re: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
 <20211010072920.20706-14-biju.das.jz@bp.renesas.com>
 <8c6496db-8b91-8fb8-eb01-d35807694149@gmail.com>
 <OS0PR01MB5922109B263B7FDBB02E33B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <57dbab90-6f2c-40f5-2b73-43c1ee2c6e06@gmail.com>
Date:   Sun, 10 Oct 2021 12:49:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922109B263B7FDBB02E33B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.10.2021 12:37, Biju Das wrote:
> Hi Sergey,
> 
>> -----Original Message-----
>> From: Sergei Shtylyov <sergei.shtylyov@gmail.com>
>> Sent: 10 October 2021 10:28
>> To: Biju Das <biju.das.jz@bp.renesas.com>; David S. Miller
>> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>
>> Cc: Sergey Shtylyov <s.shtylyov@omp.ru>; Geert Uytterhoeven
>> <geert+renesas@glider.be>; Sergey Shtylyov <s.shtylyov@omprussia.ru>; Adam
>> Ford <aford173@gmail.com>; Andrew Lunn <andrew@lunn.ch>; Yuusuke Ashizuka
>> <ashiduka@fujitsu.com>; Yoshihiro Shimoda
>> <yoshihiro.shimoda.uh@renesas.com>; netdev@vger.kernel.org; linux-renesas-
>> soc@vger.kernel.org; Chris Paterson <Chris.Paterson2@renesas.com>; Biju
>> Das <biju.das@bp.renesas.com>; Prabhakar Mahadev Lad <prabhakar.mahadev-
>> lad.rj@bp.renesas.com>
>> Subject: Re: [PATCH net-next v2 13/14] ravb: Update EMAC configuration
>> mode comment
>>
>> On 10.10.2021 10:29, Biju Das wrote:
>>
>>> Update EMAC configuration mode comment from "PAUSE prohibition"
>>> to "EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC Pass Through;
>>> Promiscuous".
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>>> ---
>>> v1->v2:
>>>    * No change
>>> V1:
>>>    * New patch.
>>> ---
>>>    drivers/net/ethernet/renesas/ravb_main.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>>> b/drivers/net/ethernet/renesas/ravb_main.c
>>> index 9a770a05c017..b78aca235c37 100644
>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>>> @@ -519,7 +519,7 @@ static void ravb_emac_init_gbeth(struct net_device
>> *ndev)
>>>    	/* Receive frame limit set register */
>>>    	ravb_write(ndev, GBETH_RX_BUFF_MAX + ETH_FCS_LEN, RFLR);
>>>
>>> -	/* PAUSE prohibition */
>>> +	/* EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC Pass Through;
>>> +Promiscuous */
>>
>>      Promiscuous mode, really? Why?!
> 
> This is TOE related 

    The promiscuous mode is supported by _all_ Ethernet controllers, I think.

> and is recommendation from BSP/HW team.

    On what grounds?

> If you think it is wrong.
> I can take this out. Please let me know. Currently the board is booting and everything works without issues.

    Please do take it out. It'll needlessly overload the controller when 
there's much traffic on the local network.

> The meaning of promiscuous in H/W manual as follows.

    I know what the promiscuous mode is. :-)
    It's needed by things like 'tcpdump' and normally shoild be off.

> Promiscuous Mode
> 1: All the frames except for PAUSE frame are received. Self-addressed unicast,
> different address unicast, multicast, and broadcast frames are all transferred to
> TOE. PAUSE frame reception is controlled by PFR bit.
> 0: Self-addressed unicast, multicast, and broadcast frames are received, then
> transferred to TOE.
> 
> Regards,
> Biju

MBR, Sergey
