Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C383E1BAB
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241738AbhHESst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240771AbhHESst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:48:49 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04CEC061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:48:33 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id p5so7862092wro.7
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n3DFyEUcKB/CA5jIT2EW0WAQ2YqqDzPoJj3CNP+FfjU=;
        b=ol/PTbb/EtNmnSt+wwIbEOZgkHUJ+/Cujd8f16p06gPnhTe8JLIcY/4/WUtlR+wgqr
         1qHthHMr1OHRkBi3DRBsYCfGu3/aOXIwzq+jz2L3FPxhLrudKlksW/SbrF8fly2fuO54
         Lhn8G0SZr6sOonzFUPJ+yehg52B04rSneBFpmkWwaZd2e0eIPqhg1wObLxTrdnLQF3uu
         OrKdWyMrFey9URAsRNPQ1JmF7nrqwOqnkBCaS54FW4jW0A5QtGFd0Q0KnH4e9lt9BKxq
         mkfcztaO+rdwb4CkXIPa92bvTfVbrWlwkp+2DsvPKnof3xWIvzVGjjMe1G9lMgbjvnEJ
         A7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n3DFyEUcKB/CA5jIT2EW0WAQ2YqqDzPoJj3CNP+FfjU=;
        b=bZnEKno8t5IcifXjYn8aR1VMpUbQhJFZDJ21YnPTiUJCS4VVrBjyJb1hNAWMxc2SZL
         o1pQ21Y/QSBshK0j2p74maCLK236JbeiZLhlAeY8dtwyplBHmA0ekYM85+AD2AgIj7ws
         Gg8o+hrx9izoP8btzICrnrQRK3Mi6bWuoZeHJZ/Vpb+JuCHZnD9GU6BUlidm/YZl4l9Z
         nzeTGCNkreYsmJNBqMiWUMPSzyWcZP7wWtWibmWAQgpMyfhDja8MXWDmdzJ5fdaYPgx6
         1Qcs4Y9Q8AuBHcZxqfL1rymz+lXL4l18i/N/RY73XcXg2WO7/Qicf0XKz+7LnnENlIVy
         yNmQ==
X-Gm-Message-State: AOAM530cmeL7wH1H+DAKo/bHPYnHLDRyuRT7sk8A6y2sVw2R0GR6mHG+
        /FcgMFiv/1NGZK/qofU3MKveL2mIwItLxA==
X-Google-Smtp-Source: ABdhPJx0U6Sl8ba6up1Q61eodjVNGnSAQRWrXV69bjgpsj4AvEwI2ObXcA4NrGOfYVTOFeopNh/gbw==
X-Received: by 2002:adf:eb4a:: with SMTP id u10mr6681769wrn.11.1628189312289;
        Thu, 05 Aug 2021 11:48:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:75d1:7bfc:8928:d5ba? (p200300ea8f10c20075d17bfc8928d5ba.dip0.t-ipconnect.de. [2003:ea:8f10:c200:75d1:7bfc:8928:d5ba])
        by smtp.googlemail.com with ESMTPSA id j19sm11395290wmi.3.2021.08.05.11.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 11:48:31 -0700 (PDT)
To:     Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
 <05bae6c6-502e-4715-1283-fc4135702515@gmail.com>
 <89f026f5-cc61-80e5-282d-717bc566632c@linux.ibm.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 4/4] ethtool: runtime-resume netdev parent in
 ethnl_ops_begin
Message-ID: <c937314e-57a0-03ef-cde2-02d7746cd39c@gmail.com>
Date:   Thu, 5 Aug 2021 20:48:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <89f026f5-cc61-80e5-282d-717bc566632c@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.08.2021 13:51, Julian Wiedmann wrote:
> On 01.08.21 13:41, Heiner Kallweit wrote:
>> If a network device is runtime-suspended then:
>> - network device may be flagged as detached and all ethtool ops (even if not
>>   accessing the device) will fail because netif_device_present() returns
>>   false
>> - ethtool ops may fail because device is not accessible (e.g. because being
>>   in D3 in case of a PCI device)
>>
>> It may not be desirable that userspace can't use even simple ethtool ops
>> that not access the device if interface or link is down. To be more friendly
>> to userspace let's ensure that device is runtime-resumed when executing the
>> respective ethtool op in kernel.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  net/ethtool/netlink.c | 31 +++++++++++++++++++++++++------
>>  1 file changed, 25 insertions(+), 6 deletions(-)
>>
> 
> [...]
> 
>>  
>>  void ethnl_ops_complete(struct net_device *dev)
>>  {
>>  	if (dev && dev->ethtool_ops->complete)
>>  		dev->ethtool_ops->complete(dev);
>> +
>> +	if (dev->dev.parent)
>> +		pm_runtime_put(dev->dev.parent);
>>  }
>>  
>>  /**
>>
> 
> Hello Heiner,
> 
> Coverity complains that we checked dev != NULL earlier but now
> unconditionally dereference it:
> 
Thanks for the hint. I wonder whether we have any valid case where
dev could be NULL. There are several places where dev is dereferenced
after the call to ethnl_ops_begin(). Just one example:
linkmodes_prepare_data()

Only ethnl_request_ops where allow_nodev_do is true is
ethnl_strset_request_ops. However in strset_prepare_data()
ethnl_ops_begin() is called only if dev isn't NULL.
Supposedly we should return an error from ethnl_ops_begin()
if dev is NULL.

> 
> *** CID 1506213:  Null pointer dereferences  (FORWARD_NULL)
> /net/ethtool/netlink.c: 67 in ethnl_ops_complete()
> 61     
> 62     void ethnl_ops_complete(struct net_device *dev)
> 63     {
> 64     	if (dev && dev->ethtool_ops->complete)
> 65     		dev->ethtool_ops->complete(dev);
> 66     
>>>>     CID 1506213:  Null pointer dereferences  (FORWARD_NULL)
>>>>     Dereferencing null pointer "dev".
> 67     	if (dev->dev.parent)
> 68     		pm_runtime_put(dev->dev.parent);
> 69     }
> 70     
> 71     /**
> 72      * ethnl_parse_header_dev_get() - parse request header
> 

