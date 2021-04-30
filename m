Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E2F36F997
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 13:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhD3Lu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 07:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbhD3Lu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 07:50:58 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32B6C06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 04:50:09 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id o16so80417987ljp.3
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 04:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-transfer-encoding;
        bh=qThMQBgs0R43oy5MH1AeQfPHa9icvwVKOvzMVn86g84=;
        b=s09n6Kbw9zst0+L+hS62XABNPd6l5RIahXz16lwnXocUOH/i2H99dOK2l7KAqPpFGC
         FE2dKycqXmA1TIn/slqyyESs05IvLD/jtCjdhz4bwOpG+tukUM8SFnOK7aq7oQbgeYvU
         wchKSsEStoO+cPGQWjc4HpfaO8muAHC6Ms/U8O7HNwmS6ZTh9Jj2F4CiOnJFqiEGu7eC
         3UVUcw4hp5nG0caMVaWavZW0NaDJdZhBI4ta5dizQVH+vOiXErU7Dra2rS1tvSZrJPLa
         umvMlDvOAEiiuBOASxXbXqYMbWZn8P2cyER1j97/z4+liZSNMIHj/CuJcQ6LkOIf970e
         MPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :subject:content-transfer-encoding;
        bh=qThMQBgs0R43oy5MH1AeQfPHa9icvwVKOvzMVn86g84=;
        b=qSu6ToqWyavox67nKqPl/hWByfL42RuFCoweKN/SteQFk4gLMGdivfQZjAWCxBpV3e
         dsDZO6btLTgwFYt75hvM5bkirZSlBA3UT2Sw55qkee1n9VAOoeWLXqk/OoiRI2rfn46C
         rQEP69fwb2KLQk5w6OxdGF6MUgvs456vMu1SnKfbSPJcC5jICITYxmao+swUD7u3i96d
         WlMvWdHye90WWKOERADUqLgScqvGFeSVSpQe+rTVyw9Um5wep+kz9ixUa9fwU/hXu6Uj
         cDVMjv6LL8LuCeE4tA4SVGgdzf6Y+GahzRWdnsav81A4wt5dt30PdHdr/9flBjXYAsDu
         lN+Q==
X-Gm-Message-State: AOAM5337PEHkwuyeamVGAZ7tKrsb1O2FycNMf3W3OO/aTnz9NJuFEeDA
        SpodOYyFLIkeIXoxyVR3jdY=
X-Google-Smtp-Source: ABdhPJy3Pyf+SuSWXgC6IsxRs4abMf6npKgl1+I0SrM/FqFECUPiXe9UTjsprJAyKVVhlrCt515baA==
X-Received: by 2002:a2e:98d8:: with SMTP id s24mr3490914ljj.416.1619783408244;
        Fri, 30 Apr 2021 04:50:08 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id l25sm267464lfe.188.2021.04.30.04.50.07
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Fri, 30 Apr 2021 04:50:07 -0700 (PDT)
Message-ID: <608BF122.7050307@gmail.com>
Date:   Fri, 30 Apr 2021 14:59:30 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Chris Snook <chris.snook@gmail.com>, netdev@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        nic-devel@qualcomm.com
Subject: A problem with "ip=..." ipconfig and Atheros alx driver.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Chris and others,

I'm observing a problem with Atheros alx ethernet driver and in-kernel 
ip4 configuration (using "ip=192.168....." boot parameter).

The problem first showed itself as a huge unexpected delay in bootup as 
long as "ip=..." was specified (and a real device is present). I've then 
noticed a timeout counter "Waiting up to 110 more seconds for network" 
between the "Atheros(R) AR816x/AR817x" message and "eth0: NIC Up: 1 Gbps 
Full" message. Meanwhile, this ethernet device is fully operational and 
my cable is perfectly reliable.

Now, after debugging it a little bit more, I've apparently found the 
root cause. One can see in net/ipv4/ipconfig.c that ic_open_devs() tries 
to ensure carrier is physically present. But before opening device(s) 
and starting wait for the carrier, it calls rtnl_lock(). Now in 
ethernet/atheros/alx/main.c one can see that at opening, it first calls 
netif_carrier_off() then schedules alx_link_check() to do actual work, 
so carrier detection is supposed to happen a bit later. Now looking at 
this alx_link_check() carefully, first thing is does is rtnl_lock(). 
Bingo! Double-lock. Effectively actual carrier check in alx is therefore 
delayed just until ic_open_devs() gave up waiting for it and called 
rtnl_unlock(). Hence this delay and timeout.

I have checked with clean 4.9.268 and 5.4.115 on real hardware.
Can't check with 5.12 at the moment because my gcc is somewhat old to 
compile it, but browsing the code it looks like nothing has changed 
substantially anyway.

Fixing this myself is a bit beyond my capability I'm afraid, but I'd be 
happy do some testing if someone requests me to.


Thank you,

Reagrds,
Nikolai
