Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316A63DFF5B
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237283AbhHDKVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbhHDKVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 06:21:10 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E8AC0613D5;
        Wed,  4 Aug 2021 03:20:56 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id m18so1995718ljo.1;
        Wed, 04 Aug 2021 03:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tNxHagJQr1Rb8aNwI6TSrxV6+wuGV2zf3F39b2s3O5Y=;
        b=Vidz+iCS7TAPieh3V/326kIBY6CXX/FwL9JMKawF8k1zacLede8OVytjAyurAVemW5
         MS3v7SKpyKm3kd5yR7nN7HbjJSrzYmtf7TOME/cV5Yg+J3mHeY0cKnEflkRK20uLmLgh
         MmoiXMH63ONHFwgjpNYBE7+eJODV8pL5RYmL07FexXi4tNcRqlHSLtTcBrMfRsqib6N4
         wkVbNpJn7JyMhdaUoFF/QqLgBrZknO2/Yb4wNA4n6o/Tlbb2W0L9Seb4498FhF/ReobD
         ufA8RkKmslCVIDm7tPWkU3w3RurpM6flLPzZDVI0J9W1ABPUGZzVYEaSI2pZuZ0GE5Ho
         JgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tNxHagJQr1Rb8aNwI6TSrxV6+wuGV2zf3F39b2s3O5Y=;
        b=go/EvDQJCVBBAMScOvGVukOxwXgnaiGHssD6+o1LHcxysmpAYhDpvilZ7TYdIdJQDl
         GQmlWLAU8z0n/afMGqRWxJhkx4Q+pTHuC3c79eooHb0HFtyMCefkbIj4lLY7odD/9BMg
         MuLnrQUCfmPfvCCAcZEjy/Pl/mv77QsNzONfFbMzhDoZBmsOqqJDPmPOl+qwGr+jFnKh
         cBfGuF6yxF8j/6CXKlh/EO2QPYvxISTME4DQuNTPsUogSe/cs3j+seb84oVxVbM7r2qi
         ESpRdfkucnQ9js8qACiUO01rcC1+IyPWyCgUuuOej0ea6Ows4Rz7LnF2Gnw/KMBAkjcE
         EoLQ==
X-Gm-Message-State: AOAM532G9mPE1ntGef6DKQ8SdCztv/J1mWPauE7/78Ks1qfZXuWcYPHo
        wbWD/cdlKBMBBWC2VFlJQP0=
X-Google-Smtp-Source: ABdhPJxejklVF3W+5nKz1cEv0woUBlntO0aQ57sYVwld8rrekQytnWuaUE49NIjUhENkbNQMeXfjnw==
X-Received: by 2002:a2e:a607:: with SMTP id v7mr17151678ljp.73.1628072455003;
        Wed, 04 Aug 2021 03:20:55 -0700 (PDT)
Received: from [192.168.1.100] ([31.173.87.148])
        by smtp.gmail.com with ESMTPSA id m10sm129508ljo.128.2021.08.04.03.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 03:20:54 -0700 (PDT)
Subject: Re: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature to
 struct ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
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
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-8-biju.das.jz@bp.renesas.com>
 <ad727120-3ae6-4db7-e368-f06c82cfa759@gmail.com>
 <OS0PR01MB5922974FA17E6ABB4697B6B986F19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <2815f1f1-0e69-0a06-2874-318af4b76292@gmail.com>
Date:   Wed, 4 Aug 2021 13:20:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922974FA17E6ABB4697B6B986F19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.08.2021 8:13, Biju Das wrote:

[...]
>>> R-Car Gen3 supports TX and RX clock internal delay modes, whereas
>>> R-Car
>>> Gen2 and RZ/G2L do not support it.
>>> Add an internal_delay hw feature bit to struct ravb_hw_info to enable
>>> this only for R-Car Gen3.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>> ---
>>> v2:
>>>   * Incorporated Andrew and Sergei's review comments for making it
>> smaller patch
>>>     and provided detailed description.
>>> ---
>>>   drivers/net/ethernet/renesas/ravb.h      | 3 +++
>>>   drivers/net/ethernet/renesas/ravb_main.c | 6 ++++--
>>>   2 files changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>> b/drivers/net/ethernet/renesas/ravb.h
>>> index 3df813b2e253..0d640dbe1eed 100644
>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>> @@ -998,6 +998,9 @@ struct ravb_hw_info {
>>>   	int num_tx_desc;
>>>   	int stats_len;
>>>   	size_t skb_sz;
>>> +
>>> +	/* hardware features */
>>> +	unsigned internal_delay:1;	/* RAVB has internal delays */
>>
>>     Oops, missed it initially:
>>     RAVB? That's not a device name, according to the manuals. It seems to
>> be the driver's name.
> 
> OK. will change it to AVB-DMAC has internal delays.

    Please don't -- E-MAC has them, not AVB-DMAC.

> Cheers,
> Biju

MBR, Sergei
