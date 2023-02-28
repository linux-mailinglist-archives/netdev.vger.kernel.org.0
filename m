Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796876A562E
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 10:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjB1Jza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 04:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjB1Jz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 04:55:29 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171372BECB
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 01:55:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1677578107; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=FHn5jSVRRPzoCUAmY2vPGh882tsHZlhcwJl5rSl57cyp+k4XEXYN5Luefq9PHGCQ295QGLjQaYyjuxLY6sB9Q2Y3OAcIqEFxzQywmfaP/lfMWxJBaeN5KyOt5/zcspE8Cq4kPo7RLMui87+qDacGB8WLZ9VDNVUJrWV3Q1vw2TA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1677578107; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=1UKr/phEUB83iqqeal9B+3j9EZHyJmAvtUNDfzR3s4E=; 
        b=XxhN0k/q7S1zSrmhhd+MuFMuRyNC6uGSVj/7B9fnijCP2mziUXl77MxE3qJhgiYU8i4DwWPXKVdpckQfJ88HfYB9PHHVqUzGj8Miq8T/9jYJl+wnbYJsQ8kRNDyj9Z/HRb4viO40KP/kqszvePaI4p6EIbRJZIC5L6SqL0R1j+4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1677578107;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=1UKr/phEUB83iqqeal9B+3j9EZHyJmAvtUNDfzR3s4E=;
        b=JHzUAH7SbYz9yXtaSaB157jZUpwZrN+yW4gFXmU4bfi15XSGHucMAn/d9FQTE7Qb
        ce9uVK8PJdGJaJDS+rolSW5YABsndB6OsejJJ/vST52/GM4qE9jG5GEOT12+c4+cyBl
        6xNm5PC1+bWrx5592JB4LZ95Fvob9uqhb7Bi+fL0=
Received: from [10.10.10.122] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1677578104068848.0916428452233; Tue, 28 Feb 2023 01:55:04 -0800 (PST)
Message-ID: <b59a9d46-7183-d809-e744-3159d0f666dd@arinc9.com>
Date:   Tue, 28 Feb 2023 12:54:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: Aw: Re: Re: Choose a default DSA CPU port
To:     Frank Wunderlich <frank-w@public-files.de>,
        Felix Fietkau <nbd@nbd.name>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
 <20230224210852.np3kduoqhrbzuqg3@skbuf>
 <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
 <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
 <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
 <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.02.2023 15:12, Frank Wunderlich wrote:
> Hi,
>> Gesendet: Samstag, 25. Februar 2023 um 20:56 Uhr
>> Von: "Arınç ÜNAL" <arinc.unal@arinc9.com>
> 
>> On 25.02.2023 19:11, Arınç ÜNAL wrote:
>>> On 25.02.2023 16:50, Frank Wunderlich wrote:
> 
>>>> f63959c7eec3151c30a2ee0d351827b62e742dcb is the first bad commit
>>>
>>> Thanks a lot for finding this. I can confirm reverting this fixes the
>>> low throughput on my Bananapi BPI-R2 as well.
> 
>> Just tested on an MT7621 Unielec U7621-06 board. MT7621 is not affected.
> 
> do you have full 1G (940 Mbit/s) on mt7621 device in 6.1??

Just tried 6.1 on MT7621. The result is similar. This SoC isn't capable 
of delivering 1 Gbps throughput anyway, unless hardware flow offloading 
is used, which I don't here.

$ iperf3 -c 192.168.2.1 -R
Connecting to host 192.168.2.1, port 5201
Reverse mode, remote host 192.168.2.1 is sending
[  5] local 192.168.2.2 port 42310 connected to 192.168.2.1 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  88.6 MBytes   743 Mbits/sec
[  5]   1.00-2.00   sec  88.9 MBytes   745 Mbits/sec
[  5]   2.00-3.00   sec  90.2 MBytes   757 Mbits/sec
[  5]   3.00-4.00   sec  91.9 MBytes   771 Mbits/sec
[  5]   4.00-5.00   sec  92.0 MBytes   772 Mbits/sec
[  5]   5.00-6.00   sec  91.6 MBytes   768 Mbits/sec
[  5]   6.00-7.00   sec  91.9 MBytes   771 Mbits/sec
[  5]   7.00-8.00   sec  91.9 MBytes   771 Mbits/sec
[  5]   8.00-9.00   sec  91.8 MBytes   770 Mbits/sec
[  5]   9.00-10.00  sec  91.4 MBytes   767 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.01  sec   911 MBytes   764 Mbits/sec    0             sender
[  5]   0.00-10.00  sec   910 MBytes   764 Mbits/sec 
receiver

> 
> if you look at the commit you see a special handling for mt7621
> 
> if (IS_ENABLED(CONFIG_SOC_MT7621)) {
> ...
> }else{
> //all others go there including mt7623, out (t)rgmii should be here (internally SPEED_100 afair, but higher clock for trgmii):
>                 case SPEED_1000:
>                         val |= MTK_QTX_SCH_MAX_RATE_EN |
>                                FIELD_PREP(MTK_QTX_SCH_MAX_RATE_MAN, 10) |
>                                FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 5) |
>                                FIELD_PREP(MTK_QTX_SCH_MAX_RATE_WEIGHT, 10);
>                         break;
> }
> 
> but i do not understand the full code as it looks like it changes the full packet-handling ;)

Well, whatever it's doing, it doesn't hinder the performance on MT7621. ;P

> 
> imho reverting is good for test, but dropping the full change is not the right way...we should wait for felix here

Agreed, I did that to make sure nothing else on current linux-next 
affects the performance.

> 
> but back to topic...we have a patch from vladuimir which allows setting the preferred cpu-port...how do we handle mt7531 here correctly (which still sets port5 if defined and then break)?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c#n2383
> 
> 	/* BPDU to CPU port */
> 	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
> 		mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
> 			   BIT(cpu_dp->index));
> 		break; //<<< should we drop this break only to set all "cpu-bits"? what happens then (flooding both ports with packets?)
> 	}
> 
> as dsa only handles only 1 cpu-port we want the real cpu-port (preferred | first). is this bit set also if the master is changed with your follow-up patch?

Honestly, I don't know. I'd like to leave this to you to figure out. You 
should be able to get to the bottom of this with some testing on an 
MT7531 switch. I haven't got access to one.

Arınç
