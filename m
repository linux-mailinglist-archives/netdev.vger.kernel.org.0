Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F3158C8FF
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 15:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243081AbiHHNGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 09:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243082AbiHHNGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 09:06:35 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926DB6161
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 06:06:32 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id tl27so16516754ejc.1
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 06:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=bgQjFRSLa2xwB4CS5aSMut/Qn8ytzGfpdDtj3UKw97A=;
        b=MYgq8XxOOEc57m/ecEPlAH4rjCGi/yR46Iins5wrCHU86d9lytN7WP72HojoDPX3dq
         Pn5EjkJk6igW2D1f03WkODG6LKERiiQjVsY3JdOItAWf3U/+CXaQt9YYGKtkLos5pRsm
         gBMPt4gRgq4lQyJmdjmEhlxFdWKGoDz40qaoEQGSdOHweB4ekEBiJWAhsIxlTNN07xbP
         t8rmI51RNdlOLs7j0Kceu0IJl/ci8/C3mVBdg1P6q27SJgoAWmmtGFajJWx38wLd4dG6
         JTUk4mj5NQ7ODWqG+rvoSxC6CiKBDBGPJmCXOsNde5/jrRvMgQfY/yIdrlGbdtNz4jUB
         rHNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=bgQjFRSLa2xwB4CS5aSMut/Qn8ytzGfpdDtj3UKw97A=;
        b=Di69qtscbDWiiaaIw7askvMpZ/w3HB98M64W1kBbScUacCOr9GRVDaavuZydnVnrod
         P2edFo1rU2WyTX1Lkp2FcpxbkXn+3uG0GKqRk6SzncZw6VVYkADTuk1VsIXC1B5L50Xj
         VbDUuES9U1HJyMZl96QYHKU+rtK++Whvmlk8vu4BaFUo8sac6/pVNRl0IMRS/PR0BRXp
         /h2NbGVfGuU7GrQQFQeEOlnhj1M3pLvsE1OM3V1tzKtFjCGpGZRwjaG4ypCw88am04ZG
         LQfj2QCeYo3igBMG85/FqrRCZUpj0pA23prGvrRPFRBwwSBbQ1QYU8F8D2L6bHGxbP1H
         VBiw==
X-Gm-Message-State: ACgBeo2yyT3zWTRgRhfWkU2mio+de74bm2FX5q7rlfXdAOMhUFu3hkPz
        2xJN97mich72thGMX0RpDhqsiw==
X-Google-Smtp-Source: AA6agR6IRBphtpl8tdKw635ZPdSwozJAE2arHfftpN0/aFI7GBrgP+PJ3/YMdxSY6WcHw92NXiiwUQ==
X-Received: by 2002:a17:906:fc6:b0:72f:d080:416 with SMTP id c6-20020a1709060fc600b0072fd0800416mr13638743ejk.1.1659963990811;
        Mon, 08 Aug 2022 06:06:30 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id cn15-20020a0564020caf00b0043ba0cf5dbasm4524616edb.2.2022.08.08.06.06.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 06:06:30 -0700 (PDT)
Message-ID: <e011d195-e72f-d163-9f36-79b473a9466d@blackwall.org>
Date:   Mon, 8 Aug 2022 16:06:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v1] net:bonding:support balance-alb interface with vlan to
 bridge
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
References: <20220808094107.6150-1-sunshouxin@chinatelecom.cn>
 <278221fe-e836-9794-374f-0955cc10f8be@blackwall.org>
In-Reply-To: <278221fe-e836-9794-374f-0955cc10f8be@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/08/2022 15:44, Nikolay Aleksandrov wrote:
> On 08/08/2022 12:41, Sun Shouxin wrote:
>> In my test, balance-alb bonding with two slaves eth0 and eth1,
>> and then Bond0.150 is created with vlan id attached bond0.
>> After adding bond0.150 into one linux bridge, I noted that Bond0,
>> bond0.150 and  bridge were assigned to the same MAC as eth0.
>> Once bond0.150 receives a packet whose dest IP is bridge's
>> and dest MAC is eth1's, the linux bridge cannot process it as expected.
>> The patch fix the issue, and diagram as below:
>>
>> eth1(mac:eth1_mac)--bond0(balance-alb,mac:eth0_mac)--eth0(mac:eth0_mac)
>>                       |
>>                    bond0.150(mac:eth0_mac)
>>                       |
>>                    bridge(ip:br_ip, mac:eth0_mac)--other port
>>
>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>> ---
>>  drivers/net/bonding/bond_alb.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>> index 007d43e46dcb..0dea04f00f12 100644
>> --- a/drivers/net/bonding/bond_alb.c
>> +++ b/drivers/net/bonding/bond_alb.c
>> @@ -654,6 +654,7 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
>>  {
>>  	struct slave *tx_slave = NULL;
>>  	struct arp_pkt *arp;
>> +	struct net_device *dev;
> 
> reverse xmas tree order
> 
>>  
>>  	if (!pskb_network_may_pull(skb, sizeof(*arp)))
>>  		return NULL;
>> @@ -665,6 +666,13 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
>>  	if (!bond_slave_has_mac_rx(bond, arp->mac_src))
>>  		return NULL;
>>  
>> +	dev = ip_dev_find(dev_net(bond->dev), arp->ip_src);
>> +	if (dev) {
>> +		if (netif_is_bridge_master(dev)) {
>> +			return NULL;
>> +		}
> 
> nit: the {} aren't needed
> 
>> +	}
>> +
>>  	if (arp->op_code == htons(ARPOP_REPLY)) {
>>  		/* the arp must be sent on the selected rx channel */
>>  		tx_slave = rlb_choose_channel(skb, bond, arp);
> 
> Aside from the small cosmetic comments, have you tried adding the second mac address
> as permanent in the bridge?
> i.e.: 
> $ bridge fdb add <eth1_mac> dev bond0.150 master permanent
> 
> That should fix your problem without any bonding hacks.
> 
> Cheers,
>  Nik

Ah, I just found your original submission and understood the problem better.
The fix sounds good, as Jay explained there, but the commit message can use a bit
more explanation of what exactly is wrong and why the bond shouldn't load balance
these. :)

Anyway, nevermind my last comment.


