Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD25B8EC3E
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 15:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732066AbfHONCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 09:02:42 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55513 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730775AbfHONCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 09:02:42 -0400
Received: by mail-wm1-f68.google.com with SMTP id f72so1213146wmf.5
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 06:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s1IxN24sow9rf+cX3FhyblDBtRM7TlEk672hXmMNOw0=;
        b=oZDQ73JZgcvGjukK8cjPnkE+FU9YrsD7xsWRlLwJO5t9gpenHwUTL6u/7yUJXrygrG
         475JBagTHNfc64EJ+7seLatEkbBn0L1GWbG3pLfkbSYfHE3RhsNcRnlCImb3sSo8Ik77
         gcAght494AM0+V/J+/2h+I2EghurPYVgNJDU0VEm1nEIM0LAJGqLOywbDYLCEeuR1d13
         aMPIPeIe2GORrauYgipewxgDr8L1uWAHfCqosJv4EzN8WzKRoaCZ7EzCPbd0XFD50btL
         pTpfT/5toBHwX3FVk/SKjD67s382L1rWO4lj9e3U1ireHd6n4BXuhKcNM/hfC+m40/2O
         r0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s1IxN24sow9rf+cX3FhyblDBtRM7TlEk672hXmMNOw0=;
        b=KjbAl0+e5wz0qJYxRzGoAMYnBvA/7XBiT4HazJ6qAZy6sD0ulRPKIaoy+Vj90HS5lP
         gMp/xGwz8cHpdMTGCGtD6AAPf+fPkUz+mKqgwQd2xKUxsw6hZt3g9wThHVmlag5gvNO7
         BvzFlUIdavmRld+HWbGR37UV9XYwT/7ouFjzGUk2fAyQbgedY3VA6TtHJKv/KSWfSktC
         jAY8wgVYJxp9TKdc0mRsypSGMWZYyrmr97BwUkLLFgiaY3G07jqpnnQVRk4nkQTWi5ti
         iiHVQ/daZx2eq0YdtP8ldRzERrKKgeK6r/aZMY7whzQQDHmDn4OnYE6MQcE9ykLW0myv
         IK7w==
X-Gm-Message-State: APjAAAVYXfWSACkzqF4fsoq0jLVwaypNacwSi9wWt5iWphLbrJJ5n0AK
        zrfi7lYtApTZ3YALrU1bIVwiz+we
X-Google-Smtp-Source: APXvYqxAxA62Lg77VUuyaX29WyqrMpaVkFOHInZhH4fAwZIPxVl8CiUL7+nmxIBzQvkMOVDzrA2VvA==
X-Received: by 2002:a7b:cd17:: with SMTP id f23mr2732831wmj.177.1565874160227;
        Thu, 15 Aug 2019 06:02:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:b8fa:18d8:f880:513c? (p200300EA8F2F3200B8FA18D8F880513C.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:b8fa:18d8:f880:513c])
        by smtp.googlemail.com with ESMTPSA id z2sm1193972wmi.2.2019.08.15.06.02.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 06:02:39 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] r8169: use the generic EEE management
 functions
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <4a6878bf-344e-2df5-df00-b80c7c0982d1@gmail.com>
 <c5a137b1-d9d3-070c-55a1-938d6b77bdbc@gmail.com>
 <20190815123558.GA31172@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <bfd67eb3-0da7-b8a5-928a-a66802185b68@gmail.com>
Date:   Thu, 15 Aug 2019 15:02:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815123558.GA31172@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.08.2019 14:35, Andrew Lunn wrote:
> On Thu, Aug 15, 2019 at 11:47:33AM +0200, Heiner Kallweit wrote:
>> Now that the Realtek PHY driver maps the vendor-specific EEE registers
>> to the standard MMD registers, we can remove all special handling and
>> use the generic functions phy_ethtool_get/set_eee.
> 
> Hi Heiner
> 
Hi Andrew,

> I think you should also add a call the phy_init_eee()?
> 
I think it's not strictly needed. And few things regarding
phy_init_eee are not fully clear to me:

- When is it supposed to be called? Before each call to
  phy_ethtool_set_eee? Or once in the drivers init path?

- The name is a little bit misleading as it's mainly a
  validity check. An actual "init" is done only if
  parameter clk_stop_enable is set.

- It returns -EPROTONOSUPPORT if at least one link partner
  doesn't advertise EEE for current speed/duplex. To me this
  seems to be too restrictive. Example:
  We're at 1Gbps/full and link partner advertises EEE for
  100Mbps only. Then phy_init_eee returns -EPROTONOSUPPORT.
  This keeps me from controlling 100Mbps EEE advertisement.  

>   Andrew
> 
Heiner
