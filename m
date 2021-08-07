Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A2F3E3741
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 23:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhHGVyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 17:54:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41212 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229719AbhHGVyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 17:54:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628373267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Ouhso+fXGviI6knKE4P53n2vIYIknqTkdYBIyB7lgc=;
        b=Mf6If6r4T61+ZQPIIMdFNTDMpMYH8y+NZB+fIyBPDGzTQldoTXJUcq4bGt+o1XHZZ4R+sy
        hvigszGhNX6sZ6GPbfAJhtBnrPzgQFTQsR1CLC62rL86+zIcTTK0dY1sLVl5k+WukbLnTq
        w7TpNaJcEJp++2iDNUZlLVqXcZi0IMk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-EiF4uoTTPgicJ_M6BMojxQ-1; Sat, 07 Aug 2021 17:54:26 -0400
X-MC-Unique: EiF4uoTTPgicJ_M6BMojxQ-1
Received: by mail-qv1-f70.google.com with SMTP id j13-20020a0cf30d0000b029032dd803a7edso9152782qvl.2
        for <netdev@vger.kernel.org>; Sat, 07 Aug 2021 14:54:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Ouhso+fXGviI6knKE4P53n2vIYIknqTkdYBIyB7lgc=;
        b=m/jnOt9+UtdkkLxeWN9rsusKFbNpZLUvEbuyQn5emKlABIKPcXMNh46ci67E7EvQMp
         SAv9bazPCdGXOzx2BqBzGWKkmlrLP7DuEfIBEPurWbagocdbdRerV5E8dOSIgHcdcrIp
         5eSIcsRKP8crZ/W59Ho3fDvhPApCJJkiWvOTsju7fLWXGolagfGU7HjWAzRI/LPJFR/y
         Ng4KUmpWtzubLfEIsP6O8QLvVeLLf2vOd3ZEiOctemJtreH1KW3DJdsvhs8L4InLqyUH
         JR3GZE8wsipuPy4Mq9eNNeh7YEcmzf46HgHoqvff+jUlaI9AkAcunwHliaMuQs2IfVsp
         t9Ug==
X-Gm-Message-State: AOAM5306BTlbYzHBUlqJmzHFbBPPTYneKRpiFvG1xX6x5PHMOpWVfJug
        KVJUnW7oROtUqZ8cxo9MFewMDOI/LQq6PWVKR+AAv8wpVGKSex5UMq28SfSGVQQSzXbvU7Rmeuv
        a09lklzaFEVJPbN1d
X-Received: by 2002:ac8:4d8e:: with SMTP id a14mr14314795qtw.157.1628373265775;
        Sat, 07 Aug 2021 14:54:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2rRCA7TcY3owPv2AMPYK3GeSQp2u20MynsAjO59yMMmC70AXO/qIrutyCyYqEBN9RYM0xxg==
X-Received: by 2002:ac8:4d8e:: with SMTP id a14mr14314780qtw.157.1628373265536;
        Sat, 07 Aug 2021 14:54:25 -0700 (PDT)
Received: from jtoppins.rdu.csb ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id j185sm6781368qkf.28.2021.08.07.14.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Aug 2021 14:54:25 -0700 (PDT)
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
From:   Jonathan Toppins <jtoppins@redhat.com>
Message-ID: <f519f9eb-aefd-4d0a-01ce-4ed37b7930ef@redhat.com>
Date:   Sat, 7 Aug 2021 17:54:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <37c7bbbb01ede99974fc9ce3c3f5dad4845df9ee.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/6/21 11:52 PM, Joe Perches wrote:
> On Fri, 2021-08-06 at 23:30 -0400, Jonathan Toppins wrote:
>> There seems to be no reason to have different error messages between
>> netlink and printk. It also cleans up the function slightly.
> []
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> []
>> +#define BOND_NL_ERR(bond_dev, extack, errmsg) do {		\
>> +	NL_SET_ERR_MSG(extack, errmsg);				\
>> +	netdev_err(bond_dev, "Error: " errmsg "\n");		\
>> +} while (0)
>> +
>> +#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do {	\
>> +	NL_SET_ERR_MSG(extack, errmsg);				\
>> +	slave_err(bond_dev, slave_dev, "Error: " errmsg "\n");	\
>> +} while (0)
> 
> If you are doing this, it's probably smaller object code to use
> 	"%s", errmsg
> as the errmsg string can be reused
> 
> #define BOND_NL_ERR(bond_dev, extack, errmsg)			\
> do {								\
> 	NL_SET_ERR_MSG(extack, errmsg);				\
> 	netdev_err(bond_dev, "Error: %s\n", errmsg);		\
> } while (0)
> 
> #define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg)	\
> do {								\
> 	NL_SET_ERR_MSG(extack, errmsg);				\
> 	slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
> } while (0)
> 
> 

I like the thought and would agree if not for how NL_SET_ERR_MSG is 
coded. Unfortunately it does not appear as though doing the above change 
actually generates smaller object code. Maybe I have incorrectly 
interpreted something?

$ git show
commit 6bb346263b4e9d008744b45af5105df309c35c1a (HEAD -> 
upstream-bonding-cleanup)
Author: Jonathan Toppins <jtoppins@redhat.com>
Date:   Sat Aug 7 17:34:58 2021 -0400

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
$ git log --oneline -3
6bb346263b4e (HEAD -> upstream-bonding-cleanup) object code optimization
a36c7639a139 bonding: combine netlink and console error messages
88916c847e85 bonding: remove extraneous definitions from bonding.h
jtoppins@jtoppins:~/projects/linux-rhel7$ git rebase -i --exec "make 
drivers/net/bonding/bond_main.o; ls -l drivers/net/bonding/bond_main.o" 
HEAD^^
hint: Waiting for your editor to close the file... Error detected while 
processing 
/home/jtoppins/.vim/bundle/cscope_macros.vim/plugin/cscope_macros.vim:
line   42:
E568: duplicate cscope database not added
Press ENTER or type command to continue
Executing: make menuconfig


*** End of the configuration.
*** Execute 'make' to start the build or try 'make help'.

Executing: make drivers/net/bonding/bond_main.o; ls -l 
drivers/net/bonding/bond_main.o
   CALL    scripts/checksyscalls.sh
   CALL    scripts/atomic/check-atomics.sh
   DESCEND objtool
   DESCEND bpf/resolve_btfids
   CC [M]  drivers/net/bonding/bond_main.o
-rw-r--r--. 1 jtoppins jtoppins 1777896 Aug  7 17:37 
drivers/net/bonding/bond_main.o
Executing: make drivers/net/bonding/bond_main.o; ls -l 
drivers/net/bonding/bond_main.o
   CALL    scripts/checksyscalls.sh
   CALL    scripts/atomic/check-atomics.sh
   DESCEND objtool
   DESCEND bpf/resolve_btfids
   CC [M]  drivers/net/bonding/bond_main.o
-rw-r--r--. 1 jtoppins jtoppins 1778320 Aug  7 17:37 
drivers/net/bonding/bond_main.o
Successfully rebased and updated refs/heads/upstream-bonding-cleanup.

It appears the change increases bond_main.o by 424 (1778320-1777896) bytes.

