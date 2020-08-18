Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900DF248F5E
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 22:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgHRUIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 16:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgHRUIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 16:08:05 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2558C061389;
        Tue, 18 Aug 2020 13:08:04 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id 88so19422595wrh.3;
        Tue, 18 Aug 2020 13:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P+e1XORCArUjlcDdAd5PUU8mU/r/AXgnqjIeFVw8sX0=;
        b=hjWjfWhzsO5WjVXAZMLwnWx/NcPsyU+rLlisNYNis5RdLQ9BJPhfkNExNd8hQDI5YK
         xKuMya1lhEhb8Kddcy8Q25nIDq1RS8BM4BuF/rc+e1xFQ4f4UdYwkLrCzD5CoB/F3uog
         N4IRGBsAkOnDIiPHsmYYbj0dq88Z5yLs6N8Dt4cBVEXjLasehClXIz7mkeg/VLiOexP7
         9eQGa8GCty5mZlAlEcTiHXe3nkmi6e6kI64n3DyeZXKAjK95QKkQ1v9ORbSClj9vakwo
         DJ5AA7Z/hhtONXdK42+ZqnYs2S4biys9wpXNBDJaa+v1mKp3vurGsd+PqY2hOAum3exU
         LnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P+e1XORCArUjlcDdAd5PUU8mU/r/AXgnqjIeFVw8sX0=;
        b=rRPOYy5Q2e1gftIlupgBe5uuR81lP/b0MI5LjLE3QJcZ6wr+h/F80kcH0aLisdn4nO
         Xflb2rmpglZqtdIcqQ/tVWdysUZx0yGF11HYDEIWgilBYycfh3ovfKUxuy9beZ9ehmFI
         CqWogkFkXAXE2kucde+WY23yrO5i9ACUMy1s+gIxG/QUR8TZi3kr70b/RJa//Zor5hVL
         R9sRsQutKBYB6o5hjTdAfN5t4iUbbV8bH/hk3BUi6oucXzBOrnMfpy1V8OIBigDxgq4t
         EMleaEzqc9APR9oY9YXKQf03dlOjrX0cr43W3K7ZcUsjuK8CzYturgUxi2TdkGVEkmE7
         mckw==
X-Gm-Message-State: AOAM531LAJ9so3dA/CmCiF09P77TP8sbrExP8icMPhsEzMKiDGPwrxjW
        AXdkyDYBAxW5tjv4dZEXLlb/KnA9M8U=
X-Google-Smtp-Source: ABdhPJykL/i7OeaWIHcNFUBv29KZ35a6suyplOOvmz9XtIcn+gcy+MyozdD0gATn1PST6BzQjvsuGQ==
X-Received: by 2002:adf:ba10:: with SMTP id o16mr16937864wrg.100.1597781281606;
        Tue, 18 Aug 2020 13:08:01 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id l11sm1306472wme.11.2020.08.18.13.07.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 13:08:01 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: loop: Return VLAN table size through
 devlink
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200818040354.44736-1-f.fainelli@gmail.com>
 <20200818174300.GI2330298@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <def6ed7c-54a2-a670-624a-9c23c0306cd0@gmail.com>
Date:   Tue, 18 Aug 2020 13:07:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200818174300.GI2330298@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/2020 10:43 AM, Andrew Lunn wrote:
> On Mon, Aug 17, 2020 at 09:03:54PM -0700, Florian Fainelli wrote:
>> We return the VLAN table size through devlink as a simple parameter, we
>> do not support altering it at runtime:
>>
>> devlink resource show mdio_bus/fixed-0:1f
>> mdio_bus/fixed-0:1f:
>>    name VTU size 4096 occ 4096 unit entry dpipe_tables none
> 
> Hi Florian
> 
> The occ 4096 looks wrong. It is supposed to show the occupancy, how
> many are in use.
> 
>> +static u64 dsa_loop_devlink_vtu_get(void *priv)
>> +{
>> +	struct dsa_loop_priv *ps = priv;
>> +
>> +	return ARRAY_SIZE(ps->vlans);
>> +}
> 
> So this should probably be looping over all vlan IDs and counting those
> with members?

Yes, I sent an incorrect version, thanks!
-- 
Florian
