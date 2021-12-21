Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352AD47C0FB
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 14:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhLUNsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 08:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhLUNsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 08:48:38 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11307C061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 05:48:38 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v11so27032957wrw.10
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 05:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=YbbkhWM1JdVf5LTU+LOAHIUMG5QGMAOWIjnbdFV3sks=;
        b=qmtW22zXEqIv2tFBcedaj9C577pYjn4ddO6ZnllZEPv80s9KkRmxcX/IOlV44wZ5bw
         wG4fj4QoGT/rfc5gaqUb5LdUGqgqDuwUxB0uAy7+WkI0rXYUeRQBUDtWKi3ZmQI9l7NL
         Nk+mwHAiiMHUkOf+YqODEuLs3KsL2nEfV85o8Ip8PedjdXu45MnsrU4tSVn8dgVcVDnh
         6ZmqUVXwwHV+JD4S6ZF0XmgQEcuyzI26ldDog0b2rZPozl+1bfolOZ+71o67RKo9sloG
         0LtjqukDXC0Lnrggb4ZYZsZ97dKKVeBSp4PeOcQSXNFCXXMSoCSRmpZA2W0wON9dQiK7
         tj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=YbbkhWM1JdVf5LTU+LOAHIUMG5QGMAOWIjnbdFV3sks=;
        b=63XDAIfRTA5clCLhboO90ZxIc36QdldLJ/lR5tyMhE1pe20tRvibYWbkIdm6jIsCXx
         g0eS9EpRF2OQcYc2JNcDavn5Du03mMKY1cbrtp7pC391ksNhZuLfZpPOv3CJHIgeAW7U
         nhIiacCcmHOsSi1z4bwnlTjKqlTjhAlpXBUO9POOgw84U3txdJVwKae0M3CCGKbfsiDh
         i4DDeaDO6XrFWdwf0xhQKJ03BD18UjoZ0kzQlEsEcHGj7Kw0YxLVRyfw3YW2Xm9AP6fQ
         jyN9nZ0D1t4FYE5a2Puxww8CVpdbMnXFeDRSMhsUINboEGXX7yMhjuW7WbThKKMlR4Iy
         WrFg==
X-Gm-Message-State: AOAM533GnDdjtlc/4TxvcxStdx6XR1RE24Ri8i+tShXuME+pc3K/cyFW
        rmv7c586h3+e/L0Q7N2lRbrl00wIHs0V+A==
X-Google-Smtp-Source: ABdhPJyyAPW1nS5u1unhHTLYtLj1XJLfRdSiHglZFI2MdpJNCY3zI07Bz0C/xjS4+8sCGC8gMG5w0Q==
X-Received: by 2002:a5d:5849:: with SMTP id i9mr2806672wrf.446.1640094516727;
        Tue, 21 Dec 2021 05:48:36 -0800 (PST)
Received: from [10.0.0.4] ([37.166.195.247])
        by smtp.gmail.com with ESMTPSA id d10sm2292919wri.57.2021.12.21.05.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 05:48:35 -0800 (PST)
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com
From:   Eric Dumazet <eric.dumazet@gmail.com>
Subject: [bridge] sane minimal values for
 multicast_query_interval/multicast_startup_query_interval
Message-ID: <e8b9ce41-57b9-b6e2-a46a-ff9c791cf0ba@gmail.com>
Date:   Tue, 21 Dec 2021 05:48:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay

I was looking at a syzbot report, crashing a host simply by creating

hundreds of bridge devices, with IFLA_BR_MCAST_QUERY_INTVL set to 0.


For each bridge device, br_multicast_send_query() is invoked 1000 times 
per second (on HZ=1000 build) and machine eventually crashes hard.


What would be a reasonable minimal value for 
multicast_query_interval/multicast_startup_query_interval,

and should we enforce some kind of global rate limit to avoid future 
syzbot reports ?

INFO: rcu detected stall in br_multicast_query_expired

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu:    0-...!: (1 GPs behind) idle=6eb/1/0x4000000000000000 
softirq=14214/14215 fqs=16
         (t=10500 jiffies g=15505 q=102699)
rcu: rcu_preempt kthread starved for 9059 jiffies! g15505 f0x0 
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu:    Unless rcu_preempt kthread gets sufficient CPU time, OOM is now 
expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:28688 pid: 14 
ppid:     2 flags:0x00004000


