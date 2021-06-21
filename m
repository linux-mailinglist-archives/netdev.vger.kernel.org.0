Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D0D3AF817
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 23:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhFUVyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 17:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhFUVyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 17:54:53 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69891C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 14:52:38 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w31so15261759pga.6
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 14:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J5ay4nptFW39bfvOPN7weW3689BMkMAyYx0e6Gu9K8Q=;
        b=agP3oenDLgpBiSeOl/N/WHGsbBZn7XnUccUGBsZxofblf7NLEN1rf3T3qZbjtS9Nof
         PgVEAW/tzqj4zstRSAJl+NjJLYe+xGUtwIalUKfQcdDCiHTnpYvtO+8HAAZMdB25nhJO
         hje96wkMKcvP/lpLWwZ0EIjawibZ8Th3ZIlodoa4jE24rhakIOry7EFhbUVmjFEcjqiz
         ArCvozvLYxUdFRaDy7SCGfB66qTsCbPW9XrOTS0JCafKzLMUWN5DkPBFApFqynjkZ6Sw
         /H7+63o+VwASbxWpsbMQbl17OqexVCL1fCw/XKaZKctZ8hq4yT9ACtHIo+2AUMvgim6N
         vMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J5ay4nptFW39bfvOPN7weW3689BMkMAyYx0e6Gu9K8Q=;
        b=m7JlHIljJ7zEPArzm3PxIOAhZ8tXNbto/QojWxMnNuMpgz+MXu4qCwdIiDQMsH9rDb
         CR4h4jwQj/kI0rabc+sbqRLceelJlu+BUPpdTAqLIU/1mFbmvza8zb8ldfpfs++W1CIV
         wntTJDWXNV54COGttq1Px4b7upnKfU5BfVLuLb45hbd4uPJxo/OHW2fItEFZLEY027v6
         xjpW0xU4EggXtCj10KkI7MNZZpvcIwc9HuFjIpVD6G+69mLnUF8/ShqP6gyALWSYtQ6y
         5e1JAzDHWKpPGmi3jDdMYMzi4jqyskkd/MsWtbWHGtmYlRr9mv1FJKdOtuRE1qzqekGv
         CVTQ==
X-Gm-Message-State: AOAM530querrKtTmGBRPdhlxJxIqQNUmkarCJxNXNDfNO18cX5LxCVkU
        vsMSfDyG3S8CEXSG0wZDlrU=
X-Google-Smtp-Source: ABdhPJyTNXDNeaQqCnM/+XKzB/yQo1AAv6LxUa4eacFj0pJ+RwDHENFwcsybSPo08Dsf5vlOfAWfqQ==
X-Received: by 2002:aa7:9252:0:b029:2ae:bde3:621f with SMTP id 18-20020aa792520000b02902aebde3621fmr320141pfp.18.1624312357888;
        Mon, 21 Jun 2021 14:52:37 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 11sm16302579pfh.182.2021.06.21.14.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 14:52:37 -0700 (PDT)
Subject: Re: [PATCH] mv88e6xxx: fixed adding vlan 0
To:     patchwork-bot+netdevbpf@kernel.org,
        Eldar Gasanov <eldargasanov2@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org
References: <20210621085437.25777-1-eldargasanov2@gmail.com>
 <162431220437.17422.6366269633750145571.git-patchwork-notify@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7beb3632-fa36-4d12-ed20-65400dd4e0df@gmail.com>
Date:   Mon, 21 Jun 2021 14:52:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <162431220437.17422.6366269633750145571.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/21 2:50 PM, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (refs/heads/master):
> 
> On Mon, 21 Jun 2021 11:54:38 +0300 you wrote:
>> 8021q module adds vlan 0 to all interfaces when it starts.
>> When 8021q module is loaded it isn't possible to create bond
>> with mv88e6xxx interfaces, bonding module dipslay error
>> "Couldn't add bond vlan ids", because it tries to add vlan 0
>> to slave interfaces.
>>
>> There is unexpected behavior in the switch. When a PVID
>> is assigned to a port the switch changes VID to PVID
>> in ingress frames with VID 0 on the port. Expected
>> that the switch doesn't assign PVID to tagged frames
>> with VID 0. But there isn't a way to change this behavior
>> in the switch.
>>
>> [...]
> 
> Here is the summary with links:
>   - mv88e6xxx: fixed adding vlan 0
>     https://git.kernel.org/netdev/net/c/b8b79c414eca

This version would ideally have been applied instead:

https://lore.kernel.org/netdev/20210621134703.33933-1-eldargasanov2@gmail.com/
-- 
Florian
