Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9155E3B73C0
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhF2OHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhF2OHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:07:36 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8DAC061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:05:08 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w17so15970630edd.10
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rPEkCmec3SNIBsNmkCAS46X3u6XuZTa3DrxNLdIIU7Y=;
        b=qGFQrP+JF7HBBNCt370tuH9/OCUjuc80jVvQtGOxkQmfbz6DX2AkLL7ea0MW4EiWJ1
         rg4zk28F0lK/qs2Q3eY+0q8uTySewIlk8fRSmTGymdW1HqDDRLmp2mNctr4yunzgaHOT
         Zd6/tDZC4zZUYJ5lJ3mSwp5E/O3vXSO7xWzojhmcGYnq4JyCNhgAe6x1OV6+CqS8qWmZ
         /qVa8/a/Toxx66UiSU9waeYMkpZrjD4axNDYg0qnDTyEm9s/bm6ux7AfQRhnVi4n9bCT
         akgds+Y4HlhKyqqkfU05NoHk0djs2bxHKqpdb+OJgW4CiYXNQtsmHUEMtFafX9Yx+aw+
         fLWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rPEkCmec3SNIBsNmkCAS46X3u6XuZTa3DrxNLdIIU7Y=;
        b=Xf/SYC10ulwSut8EqXId+LU7vB1N/k+jKtLx+2aIj6ZMSnHZW7aLyM4gXzSjzQ/eoB
         Gtznu8lOLvs8ym5M+ghHH2WvUdNgloAPurMJS7uMRCZIAMygm5gtiOJt2zL4hpZOS+Md
         TlJgwr3jVfsfyQhB6emO5mfpcVVSjbwM1R6+LEzVYJ221/jwV42OMCycvC1eLRcD5TeB
         yZKR/Jjv8/OpIF7uLrTHnamfowDSEiNA22c8Mrzi1BkfsXSG9rSLHUEx6nwrqmPq5xxU
         NPWUgS0lcoT9Zajo6cmKZmlcQvSPPeUXgh82nOoHHrsoK/loPMDd7799ZY1925jkKFxG
         pZ/Q==
X-Gm-Message-State: AOAM533EDd/u3OacjwrwN3pbzkOMbnLXxNb8Sws8x3ZvbPJelV5RFVMk
        TAjlpeVBKFHsnT9/pcuBjZc=
X-Google-Smtp-Source: ABdhPJxKB1+Jr0Snyszm8GFjw5QhYQYup9hANFL3KBerX9/syrIvGtPFxTnBbu09miaK5/OMUdpH2g==
X-Received: by 2002:aa7:db93:: with SMTP id u19mr40322690edt.227.1624975507273;
        Tue, 29 Jun 2021 07:05:07 -0700 (PDT)
Received: from [192.168.1.24] ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id ce3sm8336331ejc.53.2021.06.29.07.05.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 07:05:06 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6: Add sysctl for RA default route table
 number
To:     antony.antony@secunet.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Christian Perle <christian.perle@secunet.com>,
        David Ahern <dsahern@gmail.com>
References: <cover.1619775297.git.antony.antony@secunet.com>
 <32de887afdc7d6851e7c53d27a21f1389bb0bd0f.1624604535.git.antony.antony@secunet.com>
 <95b096f7-8ece-46be-cedb-5ee4fc011477@gmail.com>
 <20210629125316.GA18078@moon.secunet.de>
From:   Eyal Birger <eyal.birger@gmail.com>
Message-ID: <69e7e4e5-4219-5149-e7aa-fd26aa62260e@gmail.com>
Date:   Tue, 29 Jun 2021 17:05:03 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210629125316.GA18078@moon.secunet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Antony,

On 29/06/2021 15:53, Antony Antony wrote:
> Hi David,
> 
> On Fri, Jun 25, 2021 at 22:47:41 -0600, David Ahern wrote:
>> On 6/25/21 1:04 AM, Antony Antony wrote:
>>> From: Christian Perle <christian.perle@secunet.com>
>>>
>>> Default routes learned from router advertisements(RA) are always placed
>>> in main routing table. For policy based routing setups one may
>>> want a different table for default routes. This commit adds a sysctl
>>> to make table number for RA default routes configurable.
>>>
>>> examples:
>>> sysctl net.ipv6.route.defrtr_table
>>> sysctl -w net.ipv6.route.defrtr_table=42
>>> ip -6 route show table 42
>>
>> How are the routing tables managed? If the netdevs are connected to a
>> VRF this just works.
> 
> The main routing table has no default route. Our scripts add routing rules
> based on interfaces. These rules use the specific routing table where the RA
> (when using SLAAC) installs the default route. The rest just works.

Could this be a devconf property instead of a global property? seems 
like the difference would be minor to your patch but the benefit is that 
setups using different routing tables for different policies could 
benefit (as mentioned when not using vrfs).

Eyal.
