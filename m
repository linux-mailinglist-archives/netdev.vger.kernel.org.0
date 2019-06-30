Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 345B35B106
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 19:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfF3RmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 13:42:08 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:53482 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfF3RmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 13:42:08 -0400
Received: by mail-wm1-f51.google.com with SMTP id x15so13572324wmj.3
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 10:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T4HWR69BiaDiSlUaYDaQysgTtlmWN6KMpMeUpSbIMng=;
        b=AvPAMPJIH9Px1wttSxPFIb/+X4+1369e8MTYFpBSuttmB6hyd86oAQwcVqfIskKcoU
         Lnby5fXoD+EgHyfgrpINOr+FtPlDOolLql0I10HEVSQiW4vX8+9hRQOwo1QsTuKdOqNP
         3bYCt+fNGh4bLrgDuyp0TvPIq1xBmVM8Ay85N/fJx6U2nkJNiYMBF632qO7dgwxwAsIZ
         UvLgSuAjz2EU1evmTZPZV3oMz6et+31xAo6x95f8EdH6t8eaQ4wCZd9fOZPgffGkWq6t
         Svu8DJ0EjukckP1Y0ELbufNbl9ky8+kGAl/lSlY3nleSGZR9WSkCo8BQjM7k/uj994YA
         RvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T4HWR69BiaDiSlUaYDaQysgTtlmWN6KMpMeUpSbIMng=;
        b=clvoDWcUZKQzxRz/kOr+FuHlKZroJf0ssiatDFbTZuGtE+EicLtR8hwdc4sPvLe01j
         qo2mnYr+YJF7lbniUNT9BX5EwKSZb1PCIe+culaiazTlLgiu4yEbLDQDTD5GY0ONMHRY
         W9qWA5EKarbWmQBhC2bcR9uIfoByh/2OLoxW20F5ILJKuWEN2SdPx/Oi6k+j5igAIDEx
         xH/8A66ie6YYOGx2EVCKfJDnFUOIek/aboGjs6lyjHlbdkL1X6W2IAfKLoD19n78Mk66
         yUkxEoxnA586L1sTG7ysl03cPszULCA1qh1dKn14C9DqIBOOalvL97l1eHZvts5v4zdQ
         NRbA==
X-Gm-Message-State: APjAAAVXARAlDjJDn+EhU1sWzcKRAWkCFSQcoHYJgOb99Fe+zPv4hV/8
        vRJM1v1NXEHIBXQMj9QGV30P2MDx
X-Google-Smtp-Source: APXvYqwMEeeql9SEo4aGj3YfgBe6mjbJlXeFaeDKaX25lB0gQIEyvMY6SzHThPkMREkZ2CPEmOYmlA==
X-Received: by 2002:a1c:6156:: with SMTP id v83mr14899328wmb.81.1561916525433;
        Sun, 30 Jun 2019 10:42:05 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:7d07:14b4:53c2:77e1? (p200300EA8BD60C007D0714B453C277E1.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:7d07:14b4:53c2:77e1])
        by smtp.googlemail.com with ESMTPSA id v12sm6189568wrr.41.2019.06.30.10.42.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 10:42:04 -0700 (PDT)
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
To:     Karsten Wiborg <karsten.wiborg@web.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     nic_swsd@realtek.com, romieu@fr.zoreil.com, netdev@vger.kernel.org
References: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
 <85548ec0-350b-118f-a60c-4be2235d5e4e@gmail.com>
 <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
 <b104dbf2-6adc-2eee-0a1a-505c013787c0@gmail.com>
 <62684063-10d1-58ad-55ad-ff35b231e3b0@web.de> <20190630145511.GA5330@lunn.ch>
 <3825ebc5-15bc-2787-4d73-cccbfe96a0cc@web.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <27dfc508-dee0-9dad-1e6b-2a5df93c3977@gmail.com>
Date:   Sun, 30 Jun 2019 19:42:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <3825ebc5-15bc-2787-4d73-cccbfe96a0cc@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.06.2019 18:03, Karsten Wiborg wrote:
> Hi Andrew,
> 
> On 30/06/2019 16:55, Andrew Lunn wrote:
>> Hi Karsten
>>
>> What MAC address do you get with the vendor driver? Is it the same MAC
>> address every time you reboot, or does it look random.
>>
>> The BIOS is expected to program the MAC address into the hardware. It
>> could be that the vendor driver is checking if the MAC address is
>> valid, and if not, picking a random MAC address. The mainline driver
>> does not do this.
> 
> I programmed a static DHCP-entry on my local DHCP-server so I would
> notice if the MAC address changes. Just turned the computer back on and
> received the intended IP address, so the MAC address seems to stay the
> same with the vendor driver.
> 

Vendor driver uses this code, do you see the related messages in syslog?

        if (!is_valid_ether_addr(mac_addr)) {
                netif_err(tp, probe, dev, "Invalid ether addr %pM\n",
                          mac_addr);
                eth_hw_addr_random(dev);
                ether_addr_copy(mac_addr, dev->dev_addr);
                netif_info(tp, probe, dev, "Random ether addr %pM\n",
                           mac_addr);
                tp->random_mac = 1;
        }

> The vendor part of my MAC is 6e:69:73 which is interesting because
> according to some Vendor-Lookup-pages the vendor is unknown.
> 
> Regards,
> Karsten
> 

