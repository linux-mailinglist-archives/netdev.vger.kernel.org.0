Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1D44282B3
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 19:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhJJRrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 13:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbhJJRrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 13:47:19 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C6AC061570;
        Sun, 10 Oct 2021 10:45:20 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id y15so63339168lfk.7;
        Sun, 10 Oct 2021 10:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DNo61M3hgSFY9M4/J3pGGkFZNLfOlBh55/IVe4fL7qQ=;
        b=U0ubIrheXcLLzTwl6IruBGuYDCqBTfDCaAdyfFM4YxD7oZDnbvT7aY3Sowhkij+Zb6
         kToR9cminPdnkpNmoL1p92khH6l2TS3QY6ZVeJtUYSMEyQ6XTRny3I2d67LS7M7CMhTV
         /bf31SPxiTOCqAHBouFjFq54DKwQco0wfTj4YcXLCXC4MW4h/ZDTW55FJ+1HbiSqGnEe
         YFrEWlTRhK1oTdjUdKVE2KEa6mr9CSMtuq4HMwbJpER1JNbSC+j/0ooO/csbnWmd43gA
         nQsgh3Nf4KTiG8gop/E6BOqT43w/qpnbUEJFZQfXCJbCsQLpLaLuTNrcrQPL8KyQmebi
         zEbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DNo61M3hgSFY9M4/J3pGGkFZNLfOlBh55/IVe4fL7qQ=;
        b=vLErW7iAJcxm0q++PjQdlsblZjG7WZvUuWHksMD1VyAobiQr5mDupOBm7jZWj9/BF6
         Y31tcT8FI/u04wLmqU7M0N3vuNFXe9IE0ikrx9hnJ0Sq8cx+DeUaazriVoVZf9YW+h/m
         XLtHThGCW6poPXq8qqFAt8EoQteDN8CZpm/aowFKZvtreB0z96iKI0TqpmPpzc1BSIcf
         kFUpeKdzqCNQ/VJw7GA/kMnSF7SeTNiUjdvOPoh1lNBoLScliAXDkbIzKgP7Dl1fRnNX
         CID8B7KizDIKctCZRgMgSfzBRd8wgr7Kw+XV/7k5OQJB+d3/pR9q7E46MGzoS9jCtR9z
         vkWQ==
X-Gm-Message-State: AOAM532+kdt1q62/nQ1RVhsdr5dOG0gqLIKxbjRvqxVviYMZLDUcvrHA
        FBMntIr/Ik7n5dVHIrwUxk0=
X-Google-Smtp-Source: ABdhPJzjg42OWWix23yBuIYPzQ7QEOmeowu7eoLZe2WNEKMdpi5xwI/JBd/4WwWuvJMfyyYKD26g7Q==
X-Received: by 2002:a19:4902:: with SMTP id w2mr22841071lfa.387.1633887918434;
        Sun, 10 Oct 2021 10:45:18 -0700 (PDT)
Received: from [192.168.1.103] ([31.173.86.3])
        by smtp.gmail.com with ESMTPSA id q12sm585212ljg.19.2021.10.10.10.45.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 10:45:18 -0700 (PDT)
Subject: Re: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
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
 <57dbab90-6f2c-40f5-2b73-43c1ee2c6e06@gmail.com>
 <OS0PR01MB592229224714550A4BFC10B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <5b1fda6d-5be2-6d3d-a90e-cf1509a35191@omp.ru>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <ee22431f-e796-4d1f-4ded-9a047f2c74f1@gmail.com>
Date:   Sun, 10 Oct 2021 20:45:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5b1fda6d-5be2-6d3d-a90e-cf1509a35191@omp.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10/21 8:24 PM, Sergey Shtylyov wrote:

[...]
>>>>>> Update EMAC configuration mode comment from "PAUSE prohibition"
>>>>>> to "EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC Pass Through;
>>>>>> Promiscuous".
>>>>>>
>>>>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>>>>> Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>>>>>> ---
>>>>>> v1->v2:
>>>>>>    * No change
>>>>>> V1:
>>>>>>    * New patch.
>>>>>> ---
>>>>>>    drivers/net/ethernet/renesas/ravb_main.c | 2 +-
>>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>>>>>> b/drivers/net/ethernet/renesas/ravb_main.c
>>>>>> index 9a770a05c017..b78aca235c37 100644
>>>>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>>>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>>>>>> @@ -519,7 +519,7 @@ static void ravb_emac_init_gbeth(struct
>>>>>> net_device
>>>>> *ndev)
>>>>>>    	/* Receive frame limit set register */
>>>>>>    	ravb_write(ndev, GBETH_RX_BUFF_MAX + ETH_FCS_LEN, RFLR);
>>>>>>
>>>>>> -	/* PAUSE prohibition */
>>>>>> +	/* EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC Pass Through;
>>>>>> +Promiscuous */
>>>>>
>>>>>      Promiscuous mode, really? Why?!
>>>>
>>>> This is TOE related,
>>
>> I meant the context here is TOE register related. That is what I meant.
>>
>>>
>>>     The promiscuous mode is supported by _all_ Ethernet controllers, I
>>> think.
>>>
>>>> and is recommendation from BSP team.
>>>
>>>     On what grounds?
>>
>> The reference implementation has this on. Any way it is good catch. 
>> I will turn it off and check.
>>
>> by looking at the RJ LED's there is not much activity and packet statistics also show not much activity by default.
>>
>> How can we check, it is overloading the controller? So that I can compare with and without this setting
> 
>    Maybe it doesn't get overloaded that simply, but definitely the promiscuous mode is not the thing
> for the normal driver use...
> 
>>>> If you think it is wrong.
>>>> I can take this out. Please let me know. Currently the board is booting
>>> and everything works without issues.
>>>
>>>     Please do take it out. It'll needlessly overload the controller when
>>> there's much traffic on the local network.
>>
>>
>> I can see much activity only on RJ45 LED's when I call tcpdump or by setting IP link set eth0 promisc on.
>> Otherwise there is no traffic at all.
> 
>    Sounds like the kernel initially sets the RX mode with IFF_PROMISC = 0 and thus clear ECMR.PRM but I don't
> see where it does this? Could you instrument ravb_set_tx_mode() plz?

   Sorry, ravb_set_rx_mode(), of/c. :-)

>> Regards,
>> Biju
> 
> [...]

MBR, Sergey
