Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D386739306F
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbhE0OIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbhE0OIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 10:08:43 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E2EC061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 07:07:10 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id df21so1016737edb.3
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 07:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NEwoWYHoMyZvlK5v/9vxYSllrivb2fGhpF/F9EbDTx4=;
        b=PvRUlKk4V21PLN8uGlr5l95HxHbFGyzBVqXcjre1aoKx77GAlc6khxypZKGV9G8cpH
         dVDnfBN+dZ7dmiH223ur0H11rOMq8uBM9aKhZHVoXpkUQmW7zg6Eq36UHZzQskABBF/g
         VymDBm3XBVwwoNIl5NCkP6tD2qnG9CQx8mHkXnWG76P/jIjNlJxP/3hE8PJoqnrQfEEG
         mKz4jUeOf4xhMQLnWd/RTsSlPsxtsLD5IFG1K76zabi+FEd/fTpeE9Mh/fWHrCnSK9sJ
         BiOTG4PsUT/I+cskf/Id34ec5xkGNpDB/xteJSMmTal5MRV8nua2uJErv25SNmZ8NdWu
         6Jqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NEwoWYHoMyZvlK5v/9vxYSllrivb2fGhpF/F9EbDTx4=;
        b=rVbuUqqrdtRda5OIek99TW0XL+0xa5e1byy9lz7YCJAXWKPCCnm8SdonJs6I00uSXu
         9amhXjK454qGxfTCqUYY8JJTYrSI1nv0ar+fPzdV4ps5Yl7D2jpA4qyIGds77QeRYnyg
         FBsoqtve25rWHo4dn0OCQXZ7HUKPtQ/sGTsCP9aKwONKHuUhtro+ppaqFh2frSvrtIEi
         sCuIecs8CoDkUm0ZSRlmkrkpaYszVLqQgp+O1sPhixwkRVQ/e2wqiftQUkf8BaHIjyk7
         QlgW0YS6FRjRfbdbAn0hMPFKZabV0Do9+sQBP7S6jV93rxHSGR4HixD0kS/umDh4ekJ5
         hTig==
X-Gm-Message-State: AOAM53367PCg1Pt7PKFAKD1hQmgXQnFUBLy43jSzRDdEIkBqGf0tj8OE
        onHZAxzbUEstg3IKm+5x7fNB6tU+0Vo=
X-Google-Smtp-Source: ABdhPJyTpT68RdeWp5i/COb0/c0Ha2OO8c62sukBFWYaZaPe2dsyc2OwJnW6uWkwNxGrvSguc3p9bQ==
X-Received: by 2002:aa7:c1c9:: with SMTP id d9mr4497196edp.308.1622124428801;
        Thu, 27 May 2021 07:07:08 -0700 (PDT)
Received: from [192.168.0.108] ([77.124.85.114])
        by smtp.gmail.com with ESMTPSA id r2sm1035383ejc.78.2021.05.27.07.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 07:07:08 -0700 (PDT)
Subject: Re: [RFC PATCH 0/6] BOND TLS flags fixes
To:     Jakub Kicinski <kuba@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
References: <20210526095747.22446-1-tariqt@nvidia.com>
 <20210526174714.1328af13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <8182c05b-03ab-1052-79b8-3cdf7ab467b5@gmail.com>
Date:   Thu, 27 May 2021 17:07:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210526174714.1328af13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2021 3:47 AM, Jakub Kicinski wrote:
> On Wed, 26 May 2021 12:57:41 +0300 Tariq Toukan wrote:
>> This RFC series suggests a solution for the following problem:
>>
>> Bond interface and lower interface are both up with TLS RX/TX offloads on.
>> TX/RX csum offload is turned off for the upper, hence RX/TX TLS is turned off
>> for it as well.
>> Yet, although it indicates that feature is disabled, new connections are still
>> offloaded by the lower, as Bond has no way to impact that:
>> Return value of bond_sk_get_lower_dev() is agnostic to this change.
>>
>> One way to solve this issue, is to bring back the Bond TLS operations callbacks,
>> i.e. provide implementation for struct tlsdev_ops in Bond.
>> This gives full control for the Bond over its features, making it aware of every
>> new TLS connection offload request.
>> This direction was proposed in the original Bond TLS implementation, but dropped
>> during ML review. Probably it's right to re-consider now.
>>
>> Here I suggest another solution, which requires generic changes out of the bond
>> driver.
>>
>> Fixes in patches 1 and 4 are needed anyway, independently to which solution
>> we choose. I'll probably submit them separately soon.
> 
> No opinions here, semantics of bond features were always clear
> as mud to me. What does it mean that bond survived 20 years without
> rx-csum? And it so why would TLS offload be different from what one
> may presume the semantics of rx-csum are today? 🤷🏻‍♂️
> 

Hi Jakub,

Advanced device offloads have basic logical dependencies, that are 
applied for all kind of netdevs, agnostic to internal details of each 
netdev.

Nothing special with TLS really.
TLS device offload behaves similarly to TSO (needs HW_CSUM), and GRO_HW 
(needs RXCSUM).

For TLS TX:
Dependency problem doesn't exist for bond because HW_CSUM is already 
supported. That's why TSO is available on bond.

Currently, TLS RX is blocked, as RXCSUM is cleared.
Why wouldn't RX side of bond act in a symmetric way to TX?

Moreover:
Today, bond *does* support NETIF_F_LRO (find it in BOND_VLAN_FEATURES).
It should mean that GRO_HW can be easily enabled as well. But no, it's 
blocked by the missing RXCSUM.

Actually, I think that this code below that blocks GRO_HW if no RXCSUM 
should be extended to block LRO as well. But this would make a 
degradation in bond, unless RXCSUM.

if (!(features & NETIF_F_RXCSUM)) {
         /* NETIF_F_GRO_HW implies doing RXCSUM since every packet
          * successfully merged by hardware must also have the
          * checksum verified by hardware.  If the user does not
          * want to enable RXCSUM, logically, we should disable GRO_HW.
          */
         if (features & NETIF_F_GRO_HW) {
                 netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no 
RXCSUM feature.\n");
                 features &= ~NETIF_F_GRO_HW;
         }
}

More relevant code from netdev_fix_features():

if ((features & NETIF_F_TSO) && !(features & NETIF_F_HW_CSUM) &&
                                 !(features & NETIF_F_IP_CSUM)) {
         netdev_dbg(dev, "Dropping TSO features since no CSUM feature.\n");
         features &= ~NETIF_F_TSO;
         features &= ~NETIF_F_TSO_ECN;
}

if ((features & NETIF_F_TSO6) && !(features & NETIF_F_HW_CSUM) &&
                                  !(features & NETIF_F_IPV6_CSUM)) {
         netdev_dbg(dev, "Dropping TSO6 features since no CSUM feature.\n");
         features &= ~NETIF_F_TSO6;
}

Thanks,
Tariq
