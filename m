Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E213E4AA9
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbhHIRRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:17:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233472AbhHIRRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 13:17:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628529437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=onvqB4qwnIUYnLkEvoLyUq1WbCsTad0akxGJbuTe7Qg=;
        b=TYcsgMRHwnspjUeTbpX6dIWnuH2aA9zSVbPlhgzWDO7iIhzF3xngt9/B0RdQUifoMkFMrG
        LRmQNPg4LmDXvvMKkgLwDPEs6B/T9z7d3i2E0ltQ8EZHKSiF8maVEDROH35X9Ux5TVIOEi
        LQK/d847eMJvruddXy58Sn6nx4FAyt0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-Zpn7uW2QMK-n1dar-dts9A-1; Mon, 09 Aug 2021 13:17:16 -0400
X-MC-Unique: Zpn7uW2QMK-n1dar-dts9A-1
Received: by mail-qv1-f71.google.com with SMTP id w10-20020a0cfc4a0000b0290335dd22451dso13155059qvp.5
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 10:17:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=onvqB4qwnIUYnLkEvoLyUq1WbCsTad0akxGJbuTe7Qg=;
        b=C3j7DHlui5cGupIOSjKVEaf+7Ja9M2TDN2dmJq9oFXz0aHP+/lM/hSNtspBS5zvNzu
         AJQxoUZ12d1gvafpDXvJdv+nfqchjHtg+YzGtLPMHDlNI6GVrZzQ0GquAGbule2SvwOn
         PRuB4V0+nj9gU0FLpX1kQNE5tjsf5G09qzd2tcr0OjQfp5Ht7wiTDpTe2rZP2pE8NgZD
         lfqsxkL01qhJhgApVPYh5EItbZ0TD5lscMe8fOyPcFu3+U9amuwInoRPKXM2q3u4YJdn
         skC/XYysnewPJbGOqkMa1pI49qF8Xz3aFfM/87fJo6HqS96KHhXzurQttOlb7D60owmB
         369A==
X-Gm-Message-State: AOAM53147Pg65GtFeK4P453VppKVsFVrsLLJ86IMC6opPs1LDCSCZTQj
        7u+/v4VobDWgD12v/Gpt0vtenwfdyc2ZNWOijkNxMCeOq+z87qpAHUyPu0PBsDh3y7wgkFXhTsl
        TLAYtFxMyZXyF2uo0
X-Received: by 2002:a05:620a:1022:: with SMTP id a2mr24914637qkk.136.1628529435479;
        Mon, 09 Aug 2021 10:17:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2YZUhj1moOCap9bMoUky0hAjdppfzdqLZcHyPP5I4F6tQlVpTe5b/ISqU3wg4OkBV+yIoeg==
X-Received: by 2002:a05:620a:1022:: with SMTP id a2mr24914615qkk.136.1628529435236;
        Mon, 09 Aug 2021 10:17:15 -0700 (PDT)
Received: from jtoppins.rdu.csb ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id 62sm4107787qkf.76.2021.08.09.10.17.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 10:17:14 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] bonding: combine netlink and console error
 messages
To:     Joe Perches <joe@perches.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <cover.1628306392.git.jtoppins@redhat.com>
 <a36c7639a13963883f49c272ed7993c9625a712a.1628306392.git.jtoppins@redhat.com>
 <37c7bbbb01ede99974fc9ce3c3f5dad4845df9ee.camel@perches.com>
 <f519f9eb-aefd-4d0a-01ce-4ed37b7930ef@redhat.com>
 <745ab8a85430ad4268a86b0957aa690c1a7a6d0f.camel@perches.com>
 <b384c564-8467-1504-026c-5a437cad1a14@redhat.com>
 <686044636dbf886e7eedb626ca1569e82eac1a64.camel@perches.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
Message-ID: <4553213d-47ea-a139-5a4a-7720abd08968@redhat.com>
Date:   Mon, 9 Aug 2021 13:17:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <686044636dbf886e7eedb626ca1569e82eac1a64.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/21 1:05 AM, Joe Perches wrote:
> On Sun, 2021-08-08 at 22:07 -0400, Jonathan Toppins wrote:
>> On 8/8/21 6:02 AM, Joe Perches wrote:
>>> On Sat, 2021-08-07 at 17:54 -0400, Jonathan Toppins wrote:
>>>> On 8/6/21 11:52 PM, Joe Perches wrote:
>>>>> On Fri, 2021-08-06 at 23:30 -0400, Jonathan Toppins wrote:
>>>>>> There seems to be no reason to have different error messages between
>>>>>> netlink and printk. It also cleans up the function slightly.
>>>>> []
>>>>>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>>>>> []
>>>>>> +#define BOND_NL_ERR(bond_dev, extack, errmsg) do {		\
>>>>>> +	NL_SET_ERR_MSG(extack, errmsg);				\
>>>>>> +	netdev_err(bond_dev, "Error: " errmsg "\n");		\
>>>>>> +} while (0)
>>>>>> +
>>>>>> +#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do {	\
>>>>>> +	NL_SET_ERR_MSG(extack, errmsg);				\
>>>>>> +	slave_err(bond_dev, slave_dev, "Error: " errmsg "\n");	\
>>>>>> +} while (0)
>>>>>
>>>>> If you are doing this, it's probably smaller object code to use
>>>>> 	"%s", errmsg
>>>>> as the errmsg string can be reused
>>>>>
>>>>> #define BOND_NL_ERR(bond_dev, extack, errmsg)			\
>>>>> do {								\
>>>>> 	NL_SET_ERR_MSG(extack, errmsg);				\
>>>>> 	netdev_err(bond_dev, "Error: %s\n", errmsg);		\
>>>>> } while (0)
>>>>>
>>>>> #define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg)	\
>>>>> do {								\
>>>>> 	NL_SET_ERR_MSG(extack, errmsg);				\
>>>>> 	slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
>>>>> } while (0)
>>>>>
>>>>>
>>>>
>>>> I like the thought and would agree if not for how NL_SET_ERR_MSG is
>>>> coded. Unfortunately it does not appear as though doing the above change
>>>> actually generates smaller object code. Maybe I have incorrectly
>>>> interpreted something?
>>>
>>> No, it's because you are compiling allyesconfig or equivalent.
>>> Try defconfig with bonding.
>>>
>>>
>>
>> $ git clean -dxf
>> $ git log -1 -p
>> commit 8985f8d3fa38bca5f5384f9210ed735d58fd94f2 (HEAD ->
>> upstream-bonding-cleanup)
>> Author: Jonathan Toppins <jtoppins@redhat.com>
>> Date:   Sun Aug 8 21:45:14 2021 -0400
>>
>>       object code optimization
>>
>> diff --git a/drivers/net/bonding/bond_main.c
>> b/drivers/net/bonding/bond_main.c
>> index 46b95175690b..e2903ae7cdab 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -1714,12 +1714,12 @@ void bond_lower_state_changed(struct slave *slave)
>>
>>    #define BOND_NL_ERR(bond_dev, extack, errmsg) do {             \
>>           NL_SET_ERR_MSG(extack, errmsg);                         \
>> -       netdev_err(bond_dev, "Error: " errmsg "\n");            \
>> +       netdev_err(bond_dev, "Error: %s\n", errmsg);            \
>>    } while (0)
>>
>>    #define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do { \
>>           NL_SET_ERR_MSG(extack, errmsg);                         \
>> -       slave_err(bond_dev, slave_dev, "Error: " errmsg "\n");  \
>> +       slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);  \
>>    } while (0)
>>
>>    /* enslave device <slave> to bond device <master> */
>> $ git log --oneline -2
>> 8985f8d3fa38 (HEAD -> upstream-bonding-cleanup) object code optimization
>> e326bf8fd30f bonding: combine netlink and console error messages
>> $ make defconfig
>>     HOSTCC  scripts/basic/fixdep
>> [...]
>> *** Default configuration is based on 'x86_64_defconfig'
>> #
>> # configuration written to .config
>> #
>> $ grep "BONDING" .config
>> # CONFIG_BONDING is not set
>> $ make menuconfig
>>     UPD     scripts/kconfig/mconf-cfg
>> [...]
>> configuration written to .config
>>
>> *** End of the configuration.
>> *** Execute 'make' to start the build or try 'make help'.
>>
>> $ grep "BONDING" .config
>> CONFIG_BONDING=m
>> $ git rebase -i --exec "make drivers/net/bonding/bond_main.o; ls -l
>> drivers/net/bonding/bond_main.o" HEAD^^
>> Executing: make drivers/net/bonding/bond_main.o; ls -l
>> drivers/net/bonding/bond_main.o
>>     SYNC    include/config/auto.conf.cmd
>> [...]
>>     CC      /home/jtoppins/projects/linux-rhel7/tools/objtool/librbtree.o
>>     LD      /home/jtoppins/projects/linux-rhel7/tools/objtool/objtool-in.o
>>     LINK    /home/jtoppins/projects/linux-rhel7/tools/objtool/objtool
>>     CC [M]  drivers/net/bonding/bond_main.o
>> -rw-r--r--. 1 jtoppins jtoppins 131800 Aug  8 21:47
>> drivers/net/bonding/bond_main.o
>> Executing: make drivers/net/bonding/bond_main.o; ls -l
>> drivers/net/bonding/bond_main.o
>>     CALL    scripts/checksyscalls.sh
>>     CALL    scripts/atomic/check-atomics.sh
>>     DESCEND objtool
>>     CC [M]  drivers/net/bonding/bond_main.o
>> -rw-r--r--. 1 jtoppins jtoppins 131928 Aug  8 21:47
> 
> Your size is significantly different than mine (x86-64 defconfig w/ bonding)
> 
> $ gcc --version
> gcc (Ubuntu 10.3.0-1ubuntu1) 10.3.0
> Copyright (C) 2020 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> Original:
> 
> $ git log -1
> commit 7999516e20bd9bb5d1f7351cbd05ca529a3a8d60 (HEAD, tag: next-20210806, origin/master, origin/HEAD)
> Author: Mark Brown <broonie@kernel.org>
> Date:   Fri Aug 6 17:52:53 2021 +0100
> 
>      Add linux-next specific files for 20210806
>      
>      Signed-off-by: Mark Brown <broonie@kernel.org>
> 
> $ size drivers/net/bonding/built-in.a -t
>     text	   data	    bss	    dec	    hex	filename
>    59630	    399	    460	  60489	   ec49	drivers/net/bonding/bond_main.o (ex drivers/net/bonding/built-in.a)
>    16790	     14	      2	  16806	   41a6	drivers/net/bonding/bond_3ad.o (ex drivers/net/bonding/built-in.a)
>    17101	     50	      0	  17151	   42ff	drivers/net/bonding/bond_alb.o (ex drivers/net/bonding/built-in.a)
>     7116	   1516	      0	   8632	   21b8	drivers/net/bonding/bond_sysfs.o (ex drivers/net/bonding/built-in.a)
>     1411	     72	      0	   1483	    5cb	drivers/net/bonding/bond_sysfs_slave.o (ex drivers/net/bonding/built-in.a)
>      165	      0	      0	    165	     a5	drivers/net/bonding/bond_debugfs.o (ex drivers/net/bonding/built-in.a)
>     6971	    232	      0	   7203	   1c23	drivers/net/bonding/bond_netlink.o (ex drivers/net/bonding/built-in.a)
>    15889	     74	      0	  15963	   3e5b	drivers/net/bonding/bond_options.o (ex drivers/net/bonding/built-in.a)
>     4769	      0	      0	   4769	   12a1	drivers/net/bonding/bond_procfs.o (ex drivers/net/bonding/built-in.a)
>   129842	   2357	    462	 132661	  20635	(TOTALS)
> 
> Then with your 2 patches:
> 
> $ size -t drivers/net/bonding/built-in.a
>     text	   data	    bss	    dec	    hex	filename
>    59590	    399	    460	  60449	   ec21	drivers/net/bonding/bond_main.o (ex drivers/net/bonding/built-in.a)
>    16790	     14	      2	  16806	   41a6	drivers/net/bonding/bond_3ad.o (ex drivers/net/bonding/built-in.a)
>    17101	     50	      0	  17151	   42ff	drivers/net/bonding/bond_alb.o (ex drivers/net/bonding/built-in.a)
>     7116	   1516	      0	   8632	   21b8	drivers/net/bonding/bond_sysfs.o (ex drivers/net/bonding/built-in.a)
>     1411	     72	      0	   1483	    5cb	drivers/net/bonding/bond_sysfs_slave.o (ex drivers/net/bonding/built-in.a)
>      165	      0	      0	    165	     a5	drivers/net/bonding/bond_debugfs.o (ex drivers/net/bonding/built-in.a)
>     6971	    232	      0	   7203	   1c23	drivers/net/bonding/bond_netlink.o (ex drivers/net/bonding/built-in.a)
>    15889	     74	      0	  15963	   3e5b	drivers/net/bonding/bond_options.o (ex drivers/net/bonding/built-in.a)
>     4769	      0	      0	   4769	   12a1	drivers/net/bonding/bond_procfs.o (ex drivers/net/bonding/built-in.a)
>   129802	   2357	    462	 132621	  2060d	(TOTALS)
> 
> Then with my suggestion:
> 
> $ size -t drivers/net/bonding/built-in.a
>     text	   data	    bss	    dec	    hex	filename
>    59561	    399	    460	  60420	   ec04	drivers/net/bonding/bond_main.o (ex drivers/net/bonding/built-in.a)
>    16790	     14	      2	  16806	   41a6	drivers/net/bonding/bond_3ad.o (ex drivers/net/bonding/built-in.a)
>    17101	     50	      0	  17151	   42ff	drivers/net/bonding/bond_alb.o (ex drivers/net/bonding/built-in.a)
>     7116	   1516	      0	   8632	   21b8	drivers/net/bonding/bond_sysfs.o (ex drivers/net/bonding/built-in.a)
>     1411	     72	      0	   1483	    5cb	drivers/net/bonding/bond_sysfs_slave.o (ex drivers/net/bonding/built-in.a)
>      165	      0	      0	    165	     a5	drivers/net/bonding/bond_debugfs.o (ex drivers/net/bonding/built-in.a)
>     6971	    232	      0	   7203	   1c23	drivers/net/bonding/bond_netlink.o (ex drivers/net/bonding/built-in.a)
>    15889	     74	      0	  15963	   3e5b	drivers/net/bonding/bond_options.o (ex drivers/net/bonding/built-in.a)
>     4769	      0	      0	   4769	   12a1	drivers/net/bonding/bond_procfs.o (ex drivers/net/bonding/built-in.a)
>   129773	   2357	    462	 132592	  205f0	(TOTALS)
> 
> cheers, Joe
> 

Humm I was just building the .o of the one compilation unit. I wonder if 
there is further optimization later. Will post a v2 with yours and 
Leon's changes later this evening.

Appreciate the suggestions.

-Jon

