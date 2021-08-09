Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661063E3DDC
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 04:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhHICHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 22:07:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229891AbhHICHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 22:07:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628474834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MKeRRmEFZM8hzagAYmFUTWjMruqDJIbN19rQLqjEMFU=;
        b=d/EEEwhHSPhg2Ar9wxPyyGvvMjTnnuDAav8M8thMNdXxfpgmwKqhiSDjd7C7NaEgZxX7I3
        UsJK7BEx63Q0cqi5G2O+kpWaKVi1/0ap8pMQI0ctpDdmmyUkiatMlL16lAepJWFqDGLhh0
        Bl38Uky7xPyard7Kh8EPfnbSL6pdhOY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-BTNHBNU6MySn7PRYUxel3A-1; Sun, 08 Aug 2021 22:07:13 -0400
X-MC-Unique: BTNHBNU6MySn7PRYUxel3A-1
Received: by mail-qt1-f198.google.com with SMTP id 21-20020ac857150000b029024e8c2383c1so6954749qtw.5
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 19:07:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MKeRRmEFZM8hzagAYmFUTWjMruqDJIbN19rQLqjEMFU=;
        b=tQddp9Y+bjemA5uf98ZVDWYAw+lMj9xsUeP4+uYdTbOKUKY8avIqrw1GL6Q+Hrm2Oj
         EzDr7OlqmnxKfmVUCEJGVoH7zmzBIE5r9yYy5KmBYECjDaOh6CT8OIoIt5MGnkCA4thS
         LiaOUHpkRdyoTgLhRtWwtAgSws4DCQ5HFxktArwuvU4kmDjr9amu28Y4UGlYgFx2RAEq
         3pBrF8/hAQJ1Y+6q8GE8IcxE9YDn8SvkdhNduLRcoXZpPRt3W4GnF0isMU/hCWq61Sin
         /fCox3LvGGGclUEdHGeBFCAbNT+TaaEufI9jyBTOQZTniffrnfFeXBZA6aJ/T/AfybFP
         YIxw==
X-Gm-Message-State: AOAM530xQ18aMMK7y4uzo54GgRSUHTE5dnLWYJsw/cwsQXqqd46OZnlA
        x0alEo01wuCZDZRBESqMFQ5Dc+/vH21Tn7Zw5UEs9Rm6MBW9NbCN8pYtIkdlIBs7/QfWwl7+45M
        fwk2pKz1E1g2Jhq+0
X-Received: by 2002:a37:ad0d:: with SMTP id f13mr3829037qkm.108.1628474832980;
        Sun, 08 Aug 2021 19:07:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxb/iPJ5JikGft8E9Naqs4/4b4sSjhoVLQLUxiLA9lEb9oQQ9hE54YCTtrvBzJ83js5P6foDw==
X-Received: by 2002:a37:ad0d:: with SMTP id f13mr3829024qkm.108.1628474832788;
        Sun, 08 Aug 2021 19:07:12 -0700 (PDT)
Received: from jtoppins.rdu.csb ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id p13sm7851736qkk.87.2021.08.08.19.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 19:07:12 -0700 (PDT)
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
From:   Jonathan Toppins <jtoppins@redhat.com>
Message-ID: <b384c564-8467-1504-026c-5a437cad1a14@redhat.com>
Date:   Sun, 8 Aug 2021 22:07:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <745ab8a85430ad4268a86b0957aa690c1a7a6d0f.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/21 6:02 AM, Joe Perches wrote:
> On Sat, 2021-08-07 at 17:54 -0400, Jonathan Toppins wrote:
>> On 8/6/21 11:52 PM, Joe Perches wrote:
>>> On Fri, 2021-08-06 at 23:30 -0400, Jonathan Toppins wrote:
>>>> There seems to be no reason to have different error messages between
>>>> netlink and printk. It also cleans up the function slightly.
>>> []
>>>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>>> []
>>>> +#define BOND_NL_ERR(bond_dev, extack, errmsg) do {		\
>>>> +	NL_SET_ERR_MSG(extack, errmsg);				\
>>>> +	netdev_err(bond_dev, "Error: " errmsg "\n");		\
>>>> +} while (0)
>>>> +
>>>> +#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do {	\
>>>> +	NL_SET_ERR_MSG(extack, errmsg);				\
>>>> +	slave_err(bond_dev, slave_dev, "Error: " errmsg "\n");	\
>>>> +} while (0)
>>>
>>> If you are doing this, it's probably smaller object code to use
>>> 	"%s", errmsg
>>> as the errmsg string can be reused
>>>
>>> #define BOND_NL_ERR(bond_dev, extack, errmsg)			\
>>> do {								\
>>> 	NL_SET_ERR_MSG(extack, errmsg);				\
>>> 	netdev_err(bond_dev, "Error: %s\n", errmsg);		\
>>> } while (0)
>>>
>>> #define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg)	\
>>> do {								\
>>> 	NL_SET_ERR_MSG(extack, errmsg);				\
>>> 	slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
>>> } while (0)
>>>
>>>
>>
>> I like the thought and would agree if not for how NL_SET_ERR_MSG is
>> coded. Unfortunately it does not appear as though doing the above change
>> actually generates smaller object code. Maybe I have incorrectly
>> interpreted something?
> 
> No, it's because you are compiling allyesconfig or equivalent.
> Try defconfig with bonding.
> 
> 

$ git clean -dxf
$ git log -1 -p
commit 8985f8d3fa38bca5f5384f9210ed735d58fd94f2 (HEAD -> 
upstream-bonding-cleanup)
Author: Jonathan Toppins <jtoppins@redhat.com>
Date:   Sun Aug 8 21:45:14 2021 -0400

     object code optimization

diff --git a/drivers/net/bonding/bond_main.c 
b/drivers/net/bonding/bond_main.c
index 46b95175690b..e2903ae7cdab 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1714,12 +1714,12 @@ void bond_lower_state_changed(struct slave *slave)

  #define BOND_NL_ERR(bond_dev, extack, errmsg) do {             \
         NL_SET_ERR_MSG(extack, errmsg);                         \
-       netdev_err(bond_dev, "Error: " errmsg "\n");            \
+       netdev_err(bond_dev, "Error: %s\n", errmsg);            \
  } while (0)

  #define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do { \
         NL_SET_ERR_MSG(extack, errmsg);                         \
-       slave_err(bond_dev, slave_dev, "Error: " errmsg "\n");  \
+       slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);  \
  } while (0)

  /* enslave device <slave> to bond device <master> */
$ git log --oneline -2
8985f8d3fa38 (HEAD -> upstream-bonding-cleanup) object code optimization
e326bf8fd30f bonding: combine netlink and console error messages
$ make defconfig
   HOSTCC  scripts/basic/fixdep
[...]
*** Default configuration is based on 'x86_64_defconfig'
#
# configuration written to .config
#
$ grep "BONDING" .config
# CONFIG_BONDING is not set
$ make menuconfig
   UPD     scripts/kconfig/mconf-cfg
[...]
configuration written to .config

*** End of the configuration.
*** Execute 'make' to start the build or try 'make help'.

$ grep "BONDING" .config
CONFIG_BONDING=m
$ git rebase -i --exec "make drivers/net/bonding/bond_main.o; ls -l 
drivers/net/bonding/bond_main.o" HEAD^^
Executing: make drivers/net/bonding/bond_main.o; ls -l 
drivers/net/bonding/bond_main.o
   SYNC    include/config/auto.conf.cmd
[...]
   CC      /home/jtoppins/projects/linux-rhel7/tools/objtool/librbtree.o
   LD      /home/jtoppins/projects/linux-rhel7/tools/objtool/objtool-in.o
   LINK    /home/jtoppins/projects/linux-rhel7/tools/objtool/objtool
   CC [M]  drivers/net/bonding/bond_main.o
-rw-r--r--. 1 jtoppins jtoppins 131800 Aug  8 21:47 
drivers/net/bonding/bond_main.o
Executing: make drivers/net/bonding/bond_main.o; ls -l 
drivers/net/bonding/bond_main.o
   CALL    scripts/checksyscalls.sh
   CALL    scripts/atomic/check-atomics.sh
   DESCEND objtool
   CC [M]  drivers/net/bonding/bond_main.o
-rw-r--r--. 1 jtoppins jtoppins 131928 Aug  8 21:47 
drivers/net/bonding/bond_main.o
Successfully rebased and updated refs/heads/upstream-bonding-cleanup.
$ gcc --version
gcc (GCC) 8.4.1 20200928 (Red Hat 8.4.1-1)
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

-Jon

