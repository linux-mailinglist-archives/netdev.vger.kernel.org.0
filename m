Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4A23A7468
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhFOCwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbhFOCwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:52:22 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F8DC061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 19:50:17 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id e10so18331106ybb.7
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 19:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dO2zKjQgOYNb8kIwhY3Xjl+i565QvEIDd9SypJe2j6w=;
        b=t0CKR8CF/c4KL8EPcZXrtsqPUq9bjdZwXhcnSLC+guGK7EkJYEpqI+DkN6AAF7GxV4
         NVkTDRZqLFFd7d/Ai+l1Wzpo7M4P+9WS4BE3WMKqgZ19e9jOxGqQHq10G2PMv0OB0APq
         +E6H+4fF8KhI33VTGqKa0KAQlAG9sBt6g4xWdN4BrB6oUl1rw1zTAwLAtpq9JLQAWdeT
         vSxXdohvGfpY//WlprELu+V1y1ircg0caSq7duQFsdB0hhFfdYz+RdL9HAVfGZXTwYVx
         p9h8kIOkV60y5E9xiiiIO8AI9BhXDsbXN4cvrsL+LUX/GhXnHO5pjdvdtro9ZxUPGwZp
         m5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dO2zKjQgOYNb8kIwhY3Xjl+i565QvEIDd9SypJe2j6w=;
        b=paBY/WUb9Ki0V83wITklFODcPZBre8OxbKWy8+f/XIxm9IJVrNeo+/C6v7Y4//O5vM
         w4Ca/wOabJ9wA15n4lH2YNawMLXAKugJKPXc1vXo0OK+R1S6fGFt0FCSilHf5rHh+l1O
         pLc3v3fOKCXIsQtSb+gb+PTi26fNpKAGntaGOcGXJJwjZBp3F90Pfk2agjvVIQk4phV1
         BWP4AyKctraylKsHl8vQNfvDyh6UthlUsqjMJ6WKmNFPfovQqp2JPSaW9BpWcAnOMBW0
         IQOw1m4L7qXcoQIfK0QnKw78zJcLPk0xvkWP/chKSqK9AJnW6xyguoZtys7GjIg9UMsG
         4hkg==
X-Gm-Message-State: AOAM533mvqUS57UjAniIWWte2M1M4zP8rUo/4VkHWpd8co1MArk1Q4dU
        I9djgvdFfkD57YR+I4gQ8y+iPfPLmKg=
X-Google-Smtp-Source: ABdhPJwoZESId6VJmypYxhvoVS9/gCfzgRPbkoV6L5EhXXNPeX0X3F8PSfm4Xv/qqYTDKdrNFGjzQw==
X-Received: by 2002:a9d:7f0f:: with SMTP id j15mr15989869otq.14.1623719018898;
        Mon, 14 Jun 2021 18:03:38 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id p7sm3443317otq.9.2021.06.14.18.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 18:03:37 -0700 (PDT)
Subject: Re: [PATCH iproute2] uapi: add missing virtio related headers
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210423174011.11309-1-stephen@networkplumber.org>
 <DM8PR12MB5480D92EE39584EDCFF2ECFBDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
 <41c8cf83-6b7d-1d55-fd88-5b84732f9d70@gmail.com>
 <20210611092132.5f66f710@hermes.local>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <78f32159-24d7-0ea6-6be3-add0186b97c2@gmail.com>
Date:   Mon, 14 Jun 2021 19:03:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210611092132.5f66f710@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/21 10:21 AM, Stephen Hemminger wrote:
> On Thu, 10 Jun 2021 20:54:45 -0600
> David Ahern <dsahern@gmail.com> wrote:
> 
>> On 6/8/21 11:15 PM, Parav Pandit wrote:
>>> Hi Stephen,
>>>
>>> vdpa headers were present in commit c2ecc82b9d4c at [1].
>>>
>>> I added them at [1] after David's recommendation in [2].
>>>
>>> Should we remove [1]?
>>> Did you face compilation problem without this fix?
>>>
>>> [1] ./vdpa/include/uapi/linux/vdpa.h
>>> [2] https://lore.kernel.org/netdev/abc71731-012e-eaa4-0274-5347fc99c249@gmail.com/
>>>
>>> Parav  
>>
>> Stephen: Did you hit a compile issue? vdpa goes beyond networking and
>> features go through other trees AIUI so the decision was to put the uapi
>> file under the vdpa command similar to what rdma is doing.
>>
> 
> In iproute2, all kernel headers used during the build should come from include/uapi.
> If new command or function needs a new header, then the sanitized version should be
> included.
> 
> I update these with an automated script, and making special case for vdpa
> seems to be needless effort. Please just let iproute's include/uapi just be
> a copy of what kernel "make install_headers" generates.
> 

an exception was made for rdma because of the order in which uapi
updates hit the net-next tree. The same exception was being made for
vdpa for the same reason.
