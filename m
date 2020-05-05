Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AB41C5E30
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgEEQ7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729553AbgEEQ7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:59:31 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92ED6C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 09:59:31 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id di6so1345857qvb.10
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 09:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f7thmUG1F50yL1gfq5N1CCp+yuL87PgVlu/WLQkv+Vw=;
        b=FlbsHplJiwJFfuTymhSw8XZMnhB/8T/X9qVwbn+jYFZxDiDyyFozR4M9fQKpXC0o6n
         mMr84kRANPFhRzSxIJxuDDbJERH+xxY011uiDHI8BVBEb2SJbpN5dRn1RqbaNffF3gp6
         3CR5+WsooFjYkxCn+XvJ6NBXDu4HS0wJJQsEcDXmkAJlELzTi/ymx+DkZuAU/Wm+jpU5
         gTEVOZJjkn4jhYx5UhQVdoWSYvJWZdtXo099R6tR2CC46CgKQXI8d1aNvVfNkzsX7ATC
         6oQkGWhyglZw9pAXl8VHCGgLw57U3LzqouUen8W9nSHt5JRknPkFX77IoKefmbxYJPa/
         8Ybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f7thmUG1F50yL1gfq5N1CCp+yuL87PgVlu/WLQkv+Vw=;
        b=mIP5JGbzek+Y5WfFYJdw+4q0A91lguoK3t5maUuYOTWA9b9/WPbXNqlq5f/XD580oF
         H+vhk877tE2UibsI98IxM/+w33kmYl3NkPe99LHWd/u4upvkpydwK57hO4k+K9/k2wIp
         mK5AVEGYasM8nYiyHb0mM55YMbiVdpoteUZyOAZV7oTYlbuvKxpXnEe0J3juJLi9ZgYp
         D/vh7Nk8rvZZSLDhVID5R5Q/5A8SA660HE1s2fCHkxyroRLs4UlY3z1gHCYJ2atssX0p
         GAG9eRttuZzL9cI/+ntaZHLvsjUYVkxMJ/RzGzNfYo9TfmZ71bUuGvokQXipEN9qaIeJ
         beqA==
X-Gm-Message-State: AGi0Puauv/5vtoelT8rSlqUuDJdDbM+njgDf9hoylMK1GN08sVCK4kYi
        FbTcni+ffmYe+guu4BsqZDzouIoA
X-Google-Smtp-Source: APiQypJJ+0YjJyDBDGWjr5QDhI6y16YjBSqlG1QNqG3U53xGpmb3jE29kjPCGS1EILJQSRlY5h79Uw==
X-Received: by 2002:a0c:8324:: with SMTP id j33mr3793470qva.23.1588697970848;
        Tue, 05 May 2020 09:59:30 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19:a884:3b89:d8b6? ([2601:282:803:7700:c19:a884:3b89:d8b6])
        by smtp.googlemail.com with ESMTPSA id d207sm2081880qkc.49.2020.05.05.09.59.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 09:59:30 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3] devlink: support kernel-side snapshot id
 allocation
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, jiri@resnulli.us, netdev@vger.kernel.org,
        kernel-team@fb.com, jacob.e.keller@intel.com
References: <20200430175759.1301789-1-kuba@kernel.org>
 <20200430175759.1301789-5-kuba@kernel.org>
 <af7fae65-1187-65c5-9c40-0b0703cf4053@gmail.com>
 <20200505092009.1cfe01c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <76a99d9c-3574-1c8d-07cb-1f16e1bf9cca@gmail.com>
Date:   Tue, 5 May 2020 10:59:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505092009.1cfe01c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/20 10:20 AM, Jakub Kicinski wrote:
> On Tue, 5 May 2020 10:14:24 -0600 David Ahern wrote:
>> On 4/30/20 11:57 AM, Jakub Kicinski wrote:
>>> Make ID argument optional and read the snapshot info
>>> that kernel sends us.
>>>
>>> $ devlink region new netdevsim/netdevsim1/dummy
>>> netdevsim/netdevsim1/dummy: snapshot 0
>>> $ devlink -jp region new netdevsim/netdevsim1/dummy
>>> {
>>>     "regions": {
>>>         "netdevsim/netdevsim1/dummy": {
>>>             "snapshot": [ 1 ]
>>>         }
>>>     }
>>> }
>>> $ devlink region show netdevsim/netdevsim1/dummy
>>> netdevsim/netdevsim1/dummy: size 32768 snapshot [0 1]
>>>
>>> v3: back to v1..
>>>
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>> ---
>>>  devlink/devlink.c | 26 +++++++++++++++++++++++---
>>>  1 file changed, 23 insertions(+), 3 deletions(-)  
>>
>> this does not apply to current iproute2-next
> 
> Hm. This was on top of Jake's patch, but Stephen took that one into
> iproute2, since the kernel feature is in 5.7 already. What is the
> protocol here? Can you merge iproute2 into iproute2-next? :S
> 

merged and pushed. can you resend? I deleted it after it failed to apply
and now has vanished.
