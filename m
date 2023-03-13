Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6463B6B74AF
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjCMKwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjCMKwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:52:49 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CE14D2A7
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:52:47 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id o12so46841171edb.9
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678704766;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a9L5C11Sw9bIHqmk7RYsTOno8/sluS1+0CyCq3POQ0M=;
        b=0AglgEMexqm6E156DEN4Qa4jyoykz5XuhUZ0ytMDX68sH+rnJY7hHcqw4t5bB3vNKj
         yJPg6Pgzoc84GKqNWsSRgiScNOuy2c5mub+ZMoS7P4scoRyMFsPGcx+2csMkwaYB5dzt
         ZzqnFdLqNTmxJ/5BR/Weh/WmMlkTLi62zX6T4YwmQGr46yvOtxtkWM9vEqvZh1hdPn2t
         P5ABDuu2w9KZcXOiysFdCrYi5Tcpg/QAy1KThLSZ+kwCoDTnd8irRIjEQyQPfpLRiUxa
         zF16bot6S5Vy4TYeg2twu/mJ778QFeOpQ2M4Eau6/lmRZjYHLTxgH5TFu/c3NdWDKF9b
         qX6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678704766;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a9L5C11Sw9bIHqmk7RYsTOno8/sluS1+0CyCq3POQ0M=;
        b=UbeeWsy2c/DEUbD39I+tOg6w+fbmoAUlptNCMDLcvwHFDXJxGcGuU0m0fxBj09XGVP
         6PC1xPzE+AjvSDLL8CKLeB7XWdqkTEgiC0CXxbFGcv5hGSSImlfeSzc0xUqRoXdGyCL1
         gVjhsdLpY/c90SqqK1AfOY6bCg2ofONtphkE+BftcNA66nw8eA7ruwap3RZXYo27jkxM
         EJ9c1Sjhv3c1A5r+wkdK/yRM4LV0NeKlNtt2EnGe/ezL0mdkluMFs9PUAgH31Fj+fXga
         eAu9NrOSFAyfLC+rO1jdoErCccE+fo9qSYrh0fAoZJjykxunhRo6Lu57olHPrXBIiwqO
         DdOw==
X-Gm-Message-State: AO0yUKWgdLbAjbozUr4trJoGNyNgsP6o6IsJ+HMA+bmJzZFI+zOhKJZ3
        XKaUzYE2LRHa9vhn5fcRyukhXA==
X-Google-Smtp-Source: AK7set/8dDJjJEqZ2S0YFmzS1sFgfPoHjF+MbyrAUp81PZ0trhB3npHFUidCia72yC4qkIoUTax2WA==
X-Received: by 2002:a17:906:bcc2:b0:923:5f10:affa with SMTP id lw2-20020a170906bcc200b009235f10affamr5327319ejb.69.1678704766105;
        Mon, 13 Mar 2023 03:52:46 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id hj20-20020a170906875400b0091fdc2b4fa2sm3131405ejb.145.2023.03.13.03.52.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 03:52:45 -0700 (PDT)
Message-ID: <45fc873b-9b71-adf2-8f2f-17134344e490@blackwall.org>
Date:   Mon, 13 Mar 2023 12:52:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net] bonding: Fix warning in default_device_exit_batch()
Content-Language: en-US
To:     Shigeru Yoshida <syoshida@redhat.com>
Cc:     j.vosburgh@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
References: <20230312152158.995043-1-syoshida@redhat.com>
 <d7a740f1-99e9-6947-06ef-3139198730f7@blackwall.org>
 <ZA7uTL2/IkBEIRD7@kernel-devel>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <ZA7uTL2/IkBEIRD7@kernel-devel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 11:35, Shigeru Yoshida wrote:
> Hi Nik,
> 
> On Sun, Mar 12, 2023 at 10:58:18PM +0200, Nikolay Aleksandrov wrote:
>> On 12/03/2023 17:21, Shigeru Yoshida wrote:
>>> syzbot reported warning in default_device_exit_batch() like below [1]:
>>>
>>> WARNING: CPU: 1 PID: 56 at net/core/dev.c:10867 unregister_netdevice_many_notify+0x14cf/0x19f0 net/core/dev.c:10867
>>> ...
>>> Call Trace:
>>>  <TASK>
>>>  unregister_netdevice_many net/core/dev.c:10897 [inline]
>>>  default_device_exit_batch+0x451/0x5b0 net/core/dev.c:11350
>>>  ops_exit_list+0x125/0x170 net/core/net_namespace.c:174
>>>  cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:613
>>>  process_one_work+0x9bf/0x1820 kernel/workqueue.c:2390
>>>  worker_thread+0x669/0x1090 kernel/workqueue.c:2537
>>>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>>>  </TASK>
>>>
>>> For bond devices which also has a master device, IFF_SLAVE flag is
>>> cleared at err_undo_flags label in bond_enslave() if it is not
>>> ARPHRD_ETHER type.  In this case, __bond_release_one() is not called
>>> when bond_netdev_event() received NETDEV_UNREGISTER event.  This
>>> causes the above warning.
>>>
>>> This patch fixes this issue by setting IFF_SLAVE flag at
>>> err_undo_flags label in bond_enslave() if the bond device has a master
>>> device.
>>>
>>
>> The proper way is to check if the bond device had the IFF_SLAVE flag before the
>> ether_setup() call which clears it, and restore it after.
>>
>>> Fixes: 7d5cd2ce5292 ("bonding: correctly handle bonding type change on enslave failure")
>>> Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>>> Link: https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef [1]
>>> Reported-by: syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
>>> Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
>>> ---
>>>  drivers/net/bonding/bond_main.c | 2 ++
>>>  include/net/bonding.h           | 5 +++++
>>>  2 files changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>>> index 00646aa315c3..1a8b59e1468d 100644
>>> --- a/drivers/net/bonding/bond_main.c
>>> +++ b/drivers/net/bonding/bond_main.c
>>> @@ -2291,6 +2291,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>>>  			dev_close(bond_dev);
>>>  			ether_setup(bond_dev);
>>>  			bond_dev->flags |= IFF_MASTER;
>>> +			if (bond_has_master(bond))
>>> +				bond_dev->flags |= IFF_SLAVE;
>>>  			bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
>>>  		}
>>>  	}
>>> diff --git a/include/net/bonding.h b/include/net/bonding.h
>>> index ea36ab7f9e72..ed0b49501fad 100644
>>> --- a/include/net/bonding.h
>>> +++ b/include/net/bonding.h
>>> @@ -57,6 +57,11 @@
>>>  
>>>  #define bond_has_slaves(bond) !list_empty(bond_slave_list(bond))
>>>  
>>> +/* master list primitives */
>>> +#define bond_master_list(bond) (&(bond)->dev->adj_list.upper)
>>> +
>>> +#define bond_has_master(bond) !list_empty(bond_master_list(bond))
>>> +
>>
>> This is not the proper way to check for a master device.
>>
>>>  /* IMPORTANT: bond_first/last_slave can return NULL in case of an empty list */
>>>  #define bond_first_slave(bond) \
>>>  	(bond_has_slaves(bond) ? \
>>
>> The device flags are wrong because of ether_setup() which clears IFF_SLAVE, we should
>> just check if it was present before and restore it after the ether_setup() call.
> 
> Thank you so much for your comment!  I understand your point, and
> agree that your approach must resolve the issue.
> 
> BTW, do you mean there is a case where a device has IFF_SLAVE flag but
> the upper list is empty?  I thought a device with IFF_SLAVE flag has a
> master device in the upper list (that is why I took the above way.)
> 

Hi Shigeru,
No, that's not what I meant. It's the opposite actually, you may have an upper list
but you don't have a "master" device or slave flag set. Yes, you can say that if
a device has IFF_SLAVE set, then it must have a master upper device but that's not
what you're checking for, you've reversed that logic to check for an upper device instead
and assume there's a IFF_SLAVE flag set (which may not be true).
For an upper device to be considered a "master" device, it must have the master bool set to
true in its netdev_adjacent structure. We already have helpers to check for master devices
and to retrieve them, e.g. check netdev_master_upper_dev_get* in net/core/dev.c

The most robust way to fix it is to check if the flag was there prior to the ether_setup() call
and restore it after, also to leave a nice comment about all of this. :)

> Thanks,
> Shigeru
> 

Cheers,
 Nik
