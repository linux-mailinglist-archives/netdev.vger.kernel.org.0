Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828DE9BC67
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 09:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfHXHmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 03:42:10 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42155 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbfHXHmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 03:42:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id b16so10540748wrq.9
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 00:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ip+/2UFsqnRlpVZ0C6S+KUXKzEwaCh99ektOwnbv38M=;
        b=UuCMpAb11y8XQBxUDvyzG/sYs6kCsahahng2dlI1Doyc765+ekid3Qe81k/e1RHZUW
         65+batFV8m3njiH+RyVaJ6mzjqtRlT76OpnyoWMhIfFga7gmJ14chi300sp2IIpysc3b
         tBu1Kz5X7ybLQxnrMPqUUkJy0a5oMTurfs9q6DBcGlUhCfxTURPCp66IEYx116QJ2OgP
         OaUaxYlRk+BIQz+v/Q49UE9WXFRoSHAoxXwFYh9DnSthSp3kBaRiP3ZyodTGamgZ/HTH
         uDFjluKeCAmm5OTvxdnM9GTHaViSQHxcAoeUSdw+QtfuKNz/X3FKIulLhKa/lA6uxuug
         Nbag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ip+/2UFsqnRlpVZ0C6S+KUXKzEwaCh99ektOwnbv38M=;
        b=Cpe4wQImAx3HXOfrIqZ7xwOWJzBpG7x6nU0yHmovqXvI18xiWVHMH229ByQMyKc5+S
         9Tyw2le9T9hlKMuuVid+H7GYkfgNLIgUUAeKS0Z/k5Zq1wAIw0sFxIB/5b3fM+qADb/w
         V3gzNhweWlOZ5GYU/tNz8DE3qs+X7E1EM2Jf8Z8pbaMm7I3fP7Mbgneih7eA9VE2eC3/
         xvj5XCXAvLo93oHP7fL3RtmOpkW1oe7T8hDDYCW28YXiCxf4EPEYnVx3fjLHX9XJs+c/
         ceu41R6BJeT9QDKgPniREQa/DfBsOlFjJrG6rJVjWg46aHoL1v0g/COC8MpL1uI6S9LB
         yeTw==
X-Gm-Message-State: APjAAAWLkI4lXNhv8Pja/eJkqhyl83AaO3NF5gQgOIj2JNP5Y9dWVeu+
        Nf5jqblt/ATwPi2PCPXdPWV5Ew==
X-Google-Smtp-Source: APXvYqz3ZBZz3CY8KRTU2t8eeN5o2vyZN7IdC6zEX1A+AZJ4A51eh54y1FOYtJjw3XetINFyAhHksQ==
X-Received: by 2002:adf:ba4a:: with SMTP id t10mr9322894wrg.325.1566632526261;
        Sat, 24 Aug 2019 00:42:06 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 74sm9736213wma.15.2019.08.24.00.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2019 00:42:05 -0700 (PDT)
Date:   Sat, 24 Aug 2019 09:42:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] Add NETIF_F_HW_BRIDGE feature
Message-ID: <20190824074204.GA15041@nanopsycho.orion>
References: <1566500850-6247-1-git-send-email-horatiu.vultur@microchip.com>
 <e47a318c-6446-71cd-660c-8592037d8166@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e47a318c-6446-71cd-660c-8592037d8166@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Aug 24, 2019 at 01:25:02AM CEST, f.fainelli@gmail.com wrote:
>On 8/22/19 12:07 PM, Horatiu Vultur wrote:
>> Current implementation of the SW bridge is setting the interfaces in
>> promisc mode when they are added to bridge if learning of the frames is
>> enabled.
>> In case of Ocelot which has HW capabilities to switch frames, it is not
>> needed to set the ports in promisc mode because the HW already capable of
>> doing that. Therefore add NETIF_F_HW_BRIDGE feature to indicate that the
>> HW has bridge capabilities. Therefore the SW bridge doesn't need to set
>> the ports in promisc mode to do the switching.
>
>Then do not do anything when the ndo_set_rx_mode() for the ocelot
>network device is called and indicates that IFF_PROMISC is set and that
>your network port is a bridge port member. That is what mlxsw does AFAICT.

Correct.

>
>As other pointed out, the Linux bridge implements a software bridge by
>default, and because it needs to operate on a wide variety of network
>devices, all with different capabilities, the easiest way to make sure
>that all management (IGMP, BPDU, etc. ) as well as non-management
>traffic can make it to the bridge ports, is to put the network devices
>in promiscuous mode. If this is suboptimal for you, you can take
>shortcuts in your driver that do not hinder the overall functionality.
>
>> This optimization takes places only if all the interfaces that are part
>> of the bridge have this flag and have the same network driver.
>> 
>> If the bridge interfaces is added in promisc mode then also the ports part
>> of the bridge are set in promisc mode.
>> 
>> Horatiu Vultur (3):
>>   net: Add HW_BRIDGE offload feature
>>   net: mscc: Use NETIF_F_HW_BRIDGE
>>   net: mscc: Implement promisc mode.
>> 
>>  drivers/net/ethernet/mscc/ocelot.c | 26 ++++++++++++++++++++++++--
>>  include/linux/netdev_features.h    |  3 +++
>>  net/bridge/br_if.c                 | 29 ++++++++++++++++++++++++++++-
>>  net/core/ethtool.c                 |  1 +
>>  4 files changed, 56 insertions(+), 3 deletions(-)
>> 
>
>
>-- 
>Florian
