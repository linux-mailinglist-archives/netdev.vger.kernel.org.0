Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2418922CCBB
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 20:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgGXSBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 14:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgGXSBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 14:01:06 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A38C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 11:01:06 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id bm28so7653468edb.2
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 11:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T2MZYItk78DRBwTgDd7Jp7TK4m6gryLglYr9iQqfq0o=;
        b=OGU9X3tilat5/7JOWbheIwPnUb7Qk3/EVBIuTRW2CgWmpT3sdSjEtm7uBVzGijbLeA
         O11xgWbYAjohLCpRmKRHmiUGwUH5j6BzJnTacif/qccXWyJh2NC0EirpdIbpo8/NO4Du
         DqgtIdeSUHQJGFA8+ByZiAq6ug5w+wbjEPIrdjVd26guSKEhGvFqE3i8fAUYIwCYGRoB
         WAp001xdGcypfxBkHvI0DOOoZzluRr/sbM+eWS8pDpz1MZCChqqO3s1BfgsTqiYitgzE
         W+H2EfIYXPHUMCU8tZ4l9RwMmRnDcxxvqTYSvQUhTPXv9MYO5pdRxy5tW769Dnx3ZhUc
         oIZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=T2MZYItk78DRBwTgDd7Jp7TK4m6gryLglYr9iQqfq0o=;
        b=gVuVQ6pf5yI4CcJ/0zsQDrElf/kHOL+CmN5H0jKqNqLhPrJvhcsLYPDJ42QjUgDQtY
         f/t5qhoioJbTPsHM6ys9O/4nPfgLpvd0chtQyf2sYVuCgYGcUec6I/ooKypAbwpJmJXr
         bCIgvoN2gi5dxAFUkNx/o0pPQnrr6YMIqP3aDfxEK5UlpfrOMKS0TM/wGprLA03PFEf4
         gefk8tlbw6lKFGwq2kFP/hVZDDzCSs3F9Pz/YTGqiIYfbvTJw8z1U0sOg6FTF45RymTb
         /m3CUr9Ng+dnUhk4Qifdb2O3NHFp+wiFvM0yZn9VpJs4rPOqZJxe3raXiSb4JIQzPnei
         ddtw==
X-Gm-Message-State: AOAM532lFf07eLT5Ew0g0BCwM5RPByp5WXndgUDgE//2ClGgrHCtxOpx
        MWkk0frXODhqMW/1vbGhFgM=
X-Google-Smtp-Source: ABdhPJw216lpPXhqA88+mWa+yYQWXTOWLDS7MdtSMG5GTRkqwEaf1sJMAA3rBD7s39NEQyUvzYN0Hg==
X-Received: by 2002:a50:ee8d:: with SMTP id f13mr9716524edr.302.1595613664920;
        Fri, 24 Jul 2020 11:01:04 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n2sm1144529edq.73.2020.07.24.11.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 11:01:04 -0700 (PDT)
Subject: Re: [PATCH net-next] mscc: Add LCPLL Reset to VSC8574 Family of phy
 drivers
To:     Bryan.Whitehead@microchip.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
References: <1595534997-29187-1-git-send-email-Bryan.Whitehead@microchip.com>
 <c8791db0-b036-51c0-c714-676357fd8be1@gmail.com>
 <MN2PR11MB36624200516FB937C0E91F0DFA770@MN2PR11MB3662.namprd11.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <c55019cd-32cf-cc72-1188-3115c547102c@gmail.com>
Date:   Fri, 24 Jul 2020 11:00:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <MN2PR11MB36624200516FB937C0E91F0DFA770@MN2PR11MB3662.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/20 9:29 AM, Bryan.Whitehead@microchip.com wrote:
> Hi Florian, see below.
> 
>>>  /* bus->mdio_lock should be locked when using this function */
>>> +/* Page should already be set to MSCC_PHY_PAGE_EXTENDED_GPIO */
>>> +static int vsc8574_wait_for_micro_complete(struct phy_device *phydev)
>>> +{
>>> +     u16 timeout = 500;
>>> +     u16 reg18g = 0;
>>> +
>>> +     reg18g = phy_base_read(phydev, 18);
>>> +     while (reg18g & 0x8000) {
>>> +             timeout--;
>>> +             if (timeout == 0)
>>> +                     return -1;
>>> +             usleep_range(1000, 2000);
>>> +             reg18g = phy_base_read(phydev, 18);
>>
>> Please consider using phy_read_poll_timeout() instead of open coding this busy
>> waiting loop.
> 
> There are a couple issues with the use of phy_read_poll_timeout
> 1) It requires the use of phy_read, which acquires bus->mdio_lock.
> But this function is run with the assumption that, that lock is already acquired.
> There for I presume it will deadlock> 2) The implementation of phy_base_read uses __phy_package_read which
uses a shared phy addr, rather than the addr associated with the phydev.
> 
> These issues could be eliminated if I used read_poll_timeout directly.
> Does that seem reasonable to you?

Certainly, whatever makes the code more maintainable and makes use of
existing functions is better on all counts.
-- 
Florian
