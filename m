Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B1E2EBAA1
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 08:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbhAFHkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 02:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbhAFHkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 02:40:41 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E99C06134C
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 23:40:01 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id p22so3474323edu.11
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 23:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PWGYGshx5TBDJyjMeQbfFyl2YNL3BbLl6abgEp5RlxY=;
        b=S0r6xRvoCLR+D3FGvHawIpVidbvY4SAtsQw/sLOPr0wlvYOf2nBlwe+2ywxK93TR5x
         jFZRGLRcu1vLHvvebicB7Oc83IxHBgFJeXNBbNg6atKPbq6RsJbf6oWuGknBNCEQlpmS
         w8yU7QC7C1WNohGoN6ct3iZJBGXsjD/xzcs6JSm1EdMkC+wg18Q4cZG6a42aw+Yzi1Md
         jAkJh5gcJytjBMi2bSshOxGS34dY6Sr46aIpBNHqdKfizxnzEB0UpVu/vjGe6aCxAh/O
         sftMJz+RWajRSDoy91+fGLnQZHWh5ywNE29rM3Of56VzCoCn1QplkLLasVgtEwxABe6H
         ofRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PWGYGshx5TBDJyjMeQbfFyl2YNL3BbLl6abgEp5RlxY=;
        b=XEaq9AvzRO/PSQk20xPTTOwoSFZAN2lKSyYMXdCJ6kOWr9+Z+FU2EVgVRSyJ+WrQXh
         /jGUedafyI3V02B6RVar45yHpSHBm4o2vMcuyxZHa7U/LD1IGD+gyI+76+qAUysY+JsJ
         k0BGYN21w9aTlH0VynSD8OLsOTQn6sy02qj4G5GAib4/ul0mpvrCZBTycV3fuKmhhZrx
         akZnmZ3TUPC8HPkZvgIr6niy45rhGVypuiTMbU147BBgKS0CNAZcK2Og0fL4gSY+406s
         EhDMp8hSimOarUphMUbx7qFRSJiyMv5FaOAsT+ld2ZFFFRFdZwYgkK+W0Euqqy/JB3L6
         ejlg==
X-Gm-Message-State: AOAM532FiqoaOB9OXxf0mikg3rhc+vIubOOF7EPoyMqWsSMSlgpbHAGo
        wGnqWSPO9JHEx+x6DG/0sNo=
X-Google-Smtp-Source: ABdhPJy9VUcp96HUAEUgYNVyPIHdaup2xoUS7gnwIqoOcexC48H3sInqdneForhVGZ/zUkfKxYAjSg==
X-Received: by 2002:a05:6402:1ac4:: with SMTP id ba4mr3035604edb.383.1609918800029;
        Tue, 05 Jan 2021 23:40:00 -0800 (PST)
Received: from [192.168.0.112] ([77.126.22.168])
        by smtp.gmail.com with ESMTPSA id m24sm840223ejo.52.2021.01.05.23.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 23:39:59 -0800 (PST)
Subject: Re: [net] cxgb4: advertise NETIF_F_HW_CSUM
To:     Jakub Kicinski <kuba@kernel.org>,
        Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
References: <20210105165749.16920-1-rohitm@chelsio.com>
 <20210105122924.5bc636cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <0ea3e0c4-b16e-148b-8dea-7e1fc3dec465@gmail.com>
Date:   Wed, 6 Jan 2021 09:39:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210105122924.5bc636cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/5/2021 10:29 PM, Jakub Kicinski wrote:
> On Tue,  5 Jan 2021 22:27:49 +0530 Rohit Maheshwari wrote:
>> advertise NETIF_F_HW_CSUM instead of protocol specific values of
>> NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM. This change is added long
>> back in other drivers. This issue is seen recently when TLS offload
>> made it mandatory to enable NETIF_F_HW_CSUM.
>>
>> Fixes: 2ed28baa7076 ("net: cxgb4{,vf}: convert to hw_features")
>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> 
> Ugh, commit ae0b04b238e2 ("net: Disable NETIF_F_HW_TLS_TX when HW_CSUM
> is disabled") is buggy, it should probably use NETIF_F_CSUM_MASK.
> Can you fix that instead?
> 

The HW_TLS_TX feature is for both IPv4/6. We do not want to allow 
NETIF_F_HW_TLS_TX if only one of (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM) 
is set (of course NETIF_F_HW_CSUM is not set in this case).
Hence, using NETIF_F_CSUM_MASK would not be a strong enough condition.

I think we have two options here:
Either (1) request device drivers to move to NETIF_F_HW_CSUM if they 
want to have HW_TLS_TX (as it is today), or (2) use the following condition:
((features & NETIF_F_IP_CSUM) && (features & NETIF_F_IPV6_CSUM)) || 
(features & NETIF_F_HW_CSUM).

Thanks,
Tariq
