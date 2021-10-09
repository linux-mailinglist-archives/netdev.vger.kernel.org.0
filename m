Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE08427825
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 10:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhJIIgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 04:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhJIIgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 04:36:47 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB12C061570;
        Sat,  9 Oct 2021 01:34:50 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id z11so40426576lfj.4;
        Sat, 09 Oct 2021 01:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u3CEb8/GnPNv91/8LASJszvrji6wflkCDYNbgNZbMGk=;
        b=h0r7aVReDbr/hW2qK/3MfrAkfzgKZ7N0dNXsvj2BNlX2UjbYVI4d9VP4ohKD85NY3i
         aWDB6/w1FF+1Jm1phb7tUc03BMjdeLyVKk2PZaubPIHy7423XvjZP7JnLfbmDyJlh6r/
         vH2V9NCAr+D/i1YhRrSLYZ+s5V6NsgFhaiiNNaRoEzopkrzWCXp4kiw6PisLvdmlxJk4
         xwmJfbK5cb66LJIEewNx9fhCkPJLZiimqh3wK/RbqKlB4mPgdGVx35sTuDu9yvWU+wlw
         rja5/VPkB9BkB/6wXqbLhqNWhka0iMJGGISI49EkQckXuWaOJj9hO31ag8NBcWyjBp+2
         GtGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=u3CEb8/GnPNv91/8LASJszvrji6wflkCDYNbgNZbMGk=;
        b=Y2zVkc0+Ea/aBREy5tedrBcIyHKVJj9MA4tEnKrdlsaj0sDCFTbeCB1iQZV20qOB5l
         Zh932J2uLEqkQns+c6zZ30VpXCc1ZauhNYM3Dny2epLMZkUwoA95RW72rf5u+Oc024Hd
         u4/Xywpkiwe71oJdKj7yBnVqv5Ty7eAUjMw40Qx2HmDMW26YPpaL5rmJUpbcqbpGSxvw
         ftAyqKGHd1eMmqovKX4qgDSXAK8uxrrSKZmBC7BFV3WaBiHEHs7ZYvxAS74FRdWiHu6K
         2vSferKEJq414X9CF30DPzZrBFolR6hAf6qvxoJTniCbH2P/8caCz9TaPZ/uuITwlf2m
         8W/Q==
X-Gm-Message-State: AOAM531UYoh/m/Xr4wPsnsbjK9vYxww9SN98oNe954DLK8iB/4BObz7t
        fTM/od88GJNeciFYmjhFZnk=
X-Google-Smtp-Source: ABdhPJxTU+zSbZbUjMolA8L3giNL8/KlOXSjszDd2P/GIrYRhcrnHNdpcwjntcHAn4QaN5RDhnZ42g==
X-Received: by 2002:a05:6512:114d:: with SMTP id m13mr15645858lfg.303.1633768488876;
        Sat, 09 Oct 2021 01:34:48 -0700 (PDT)
Received: from [192.168.1.100] ([31.173.82.247])
        by smtp.gmail.com with ESMTPSA id z21sm150396lfq.239.2021.10.09.01.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Oct 2021 01:34:48 -0700 (PDT)
Subject: Re: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
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
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-8-biju.das.jz@bp.renesas.com>
 <63592646-7547-1a81-e6c3-5bac413cb94a@omp.ru>
 <OS0PR01MB592295BD59F39001AC63FD3886B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <7c31964b-8cde-50c5-d686-939b7c5bd7f0@omp.ru>
 <OS0PR01MB5922239A85405F807AE3C79A86B19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <04dea1e6-c014-613d-f2f9-9ba018ced2a3@omp.ru>
 <OS0PR01MB5922BCF31F520F8F975606B286B19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <OS0PR01MB5922165EFE14E02388B34F4086B29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <52f0d801-9750-dbd6-7ba0-258a324208cf@omp.ru>
 <19204ce1-f689-3295-c5a5-7f91ceac2fca@omp.ru>
 <OS0PR01MB59228A4BA524B092F760B52E86B39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <5dd44e8b-a927-7c9a-9ca5-a2e51b2f3bd7@gmail.com>
Date:   Sat, 9 Oct 2021 11:34:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB59228A4BA524B092F760B52E86B39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.10.2021 11:27, Biju Das wrote:

>>> [...]
>>>>>>>>>>> Fillup ravb_rx_gbeth() function to support RZ/G2L.
>>>>>>>>>>>
>>>>>>>>>>> This patch also renames ravb_rcar_rx to ravb_rx_rcar to be
>>>>>>>>>>> consistent with the naming convention used in sh_eth driver.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>>>>>>>>>> Reviewed-by: Lad Prabhakar
>>>>>>>>>>> <prabhakar.mahadev-lad.rj@bp.renesas.com>[...]
>>>>>>>>>>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>>>>>>>>>>> b/drivers/net/ethernet/renesas/ravb_main.c
>>>>>>>>>>> index 37164a983156..42573eac82b9 100644
>>>>>>>>>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>>>>>>>>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>>>>>>>>>>> @@ -720,6 +720,23 @@ static void ravb_get_tx_tstamp(struct
>>>>>>>>>>> net_device
>>>>>>>>>> *ndev)
>>>>>>>>>>>   	}
>>>>>>>>>>>   }
>>>>>>>>>>>
>>>>>>>>>>> +static void ravb_rx_csum_gbeth(struct sk_buff *skb) {
>>>>>>>>>>> +	u8 *hw_csum;
>>>>>>>>>>> +
>>>>>>>>>>> +	/* The hardware checksum is contained in sizeof(__sum16) (2)
>>>>>> bytes
>>>>>>>>>>> +	 * appended to packet data
>>>>>>>>>>> +	 */
>>>>>>>>>>> +	if (unlikely(skb->len < sizeof(__sum16)))
>>>>>>>>>>> +		return;
>>>>>>>>>>> +	hw_csum = skb_tail_pointer(skb) - sizeof(__sum16);
>>> [...]
>>>>>>> Please check the section 30.5.6.1 checksum calculation handling>
>>>>>>> And figure 30.25 the field of checksum attaching field
>>>>>>
>>>>>>     I have.
>>>>>>
>>>>>>> Also see Table 30.17 for checksum values for non-error conditions.
>>>>>>
>>>>>>> TCP/UDP/ICPM checksum is at last 2bytes.
>>>>>>
>>>>>>     What are you arguing with then? :-)
>>>>>>     My point was that your code fetched the TCP/UDP/ICMP checksum
>>>>>> ISO the IP checksum because it subtracts sizeof(__sum16), while
>>>>>> should probably subtract sizeof(__wsum)
>>>>>
>>>>> Agreed. My code missed IP4 checksum result. May be we need to
>>>>> extract 2 checksum info from last 4 bytes.  First checksum(2bytes)
>>>>> is IP4 header checksum and next checksum(2 bytes)  for TCP/UDP/ICMP
>>>>> and use this info finding the non error case mentioned in  Table
>> 30.17.
>>>>>
>>>>> For eg:-
>>>>> IPV6 non error-condition -->  "0xFFFF"-->IPV4HeaderCSum value and
>> "0x0000"
>>>>> TCP/UDP/ICMP CSUM value
>>>>>
>>>>> IPV4 non error-condition -->  "0x0000"-->IPV4HeaderCSum value and
>> "0x0000"
>>>>> TCP/UDP/ICMP CSUM value
>>>>>
>>>>> Do you agree?
>>>
>>>> What I meant here is some thing like below, please let me know if you
>>>> have any issues with this, otherwise I would like to send the patch
>> with below changes.
>>>>
>>>> Further improvements can happen later.
>>>>
>>>> Please let me know.
>>>>
>>>> +/* Hardware checksum status */
>>>> +#define IPV4_RX_CSUM_OK                0x00000000
>>>> +#define IPV6_RX_CSUM_OK                0xFFFF0000
>>>
>>>     Mhm, this should prolly come from the IP headers...
>>>
>>> [...]
>>>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
>>>> b/drivers/net/ethernet/renesas/ravb_main.c
>>>> index bbb42e5328e4..d9201fbbd472 100644
>>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>>>> @@ -722,16 +722,18 @@ static void ravb_get_tx_tstamp(struct
>>>> net_device *ndev)
>>>>
>>>>   static void ravb_rx_csum_gbeth(struct sk_buff *skb)  {
>>>> -       u16 *hw_csum;
>>>> +       u32 csum_result;
>>>
>>>     This is not against the patch currently under investigation. :-)
>>>
>>>> +       u8 *hw_csum;
>>>>
>>>>          /* The hardware checksum is contained in sizeof(__sum16) (2)
>> bytes
>>>>           * appended to packet data
>>>>           */
>>>> -       if (unlikely(skb->len < sizeof(__sum16)))
>>>> +       if (unlikely(skb->len < sizeof(__wsum)))
>>>
>>>     I think this usage of __wsum is valid (I remember that I suggested
>> it). We have 2 16-bit checksums here
>>
>>     I meant "I don't think", of course. :-)
> 
> Ok will use 2 * sizeof(__sum16) instead and extract IPV4 header csum and TCP/UDP/ICMP csum result.

    I'm not sure how to deal with the later...

> All error condition/unsupported cases will be passed to stack with CHECKSUM_NONE
> and only non-error cases will be set as CHECKSUM_UNNCESSARY.
> 
> Does it sounds good to you?

    No. The networking stack needs to know about the bad checksums too.

> Regards,
> Biju

>> [...]

MBR, Sergey
