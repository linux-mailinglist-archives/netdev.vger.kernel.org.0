Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138BFECF3B
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 15:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKBOnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 10:43:07 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:46655 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfKBOnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 10:43:07 -0400
Received: by mail-il1-f194.google.com with SMTP id m16so11058083iln.13
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 07:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PNfMppRnfBPjQ2MipVIJS//sorDAEwbfSERf3uwRgbw=;
        b=RUSdtqsOF04/lKYpQY7iw0L8mDM+U2PTK9f4mWqD7FTbUY91NoQxYeH7n+ka6uHJbD
         PWN5oR3ZumpZ8kkZQ6z3MX7LXYHl/tm0Qdieiw0JAeO9Ixbs+ZAYYl7VZbrBwiI32VKg
         0xqh9Fs/r6/sF6/MbMTwHZfN9MWFIB3EDumKWagPfb2lkT+AeUFVT2Gfi0vQ7a/YldCz
         prUnzAU6HXJGiUx4ZY8tvKkXCzQb7Wx4q0PIq2Ec/f2hnZITI7wW7TAAzEt7gPMdO/nW
         eU46jkfrD9cRRHoAFOxi5XnRIiqmRlaGeDBHPDxiFUQj8Q7Lt8g34KZATrizuMbhj/Mo
         5J0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PNfMppRnfBPjQ2MipVIJS//sorDAEwbfSERf3uwRgbw=;
        b=cpvLkfX7ZVVSmOa3rGmFhFFaWF/zfEKiTuna4Qt6OGZSUzPLi1C8DK0yMrgIkX4KMA
         /jCMjtD6n+AsKq9AZJCuTcLsYfKhOiPkfSl0+tuDB8WX3TbV3g8NkUwndWyYvp1kQHk2
         MwG0BuiSAXbrWzgegwCRPmqSgzmzppSftFgNgXJpDS+MgbuAvoinTvCuB7ym4wc3hZeU
         p14FaZ6tw9MhzCz6uejwOUgsibgvpwXJYlDo6YdO7s9l/nqglh7yqiacx04Ef0EMD6c7
         rq8kFVu0f+cwL1audedwnQlRU4MMlxsj53hjaXd6MQ6S82Ykiycuo7oCYCtCuRH0fqD4
         q9ww==
X-Gm-Message-State: APjAAAVqJ/sAMlotLByoCd/0zGz803/UdyQQ1xF6DhT6sdy12uuArpDz
        OE4N2lPULA4VdGj6u2gTk8o=
X-Google-Smtp-Source: APXvYqxtyodIpFn+nxbAlfn5HJ3jJ5tpcFmlVlD77JTjof5hQgB27EEzqhZqOQYvSlXRWDgQlxJirQ==
X-Received: by 2002:a92:3a88:: with SMTP id i8mr2660959ilf.254.1572705786704;
        Sat, 02 Nov 2019 07:43:06 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:d194:3543:ed5:37ec])
        by smtp.googlemail.com with ESMTPSA id g4sm922667iof.56.2019.11.02.07.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Nov 2019 07:43:05 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next v2] tc: implement support for action
 flags
To:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com
References: <20191030140907.18561-1-vladbu@mellanox.com>
 <20191030142040.19404-1-vladbu@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c546debd-221a-73e4-2c1b-4aecd58376df@gmail.com>
Date:   Sat, 2 Nov 2019 08:43:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191030142040.19404-1-vladbu@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/19 8:20 AM, Vlad Buslov wrote:
> Implement setting and printing of action flags with single available flag
> value "no_percpu" that translates to kernel UAPI TCA_ACT_FLAGS value
> TCA_ACT_FLAGS_NO_PERCPU_STATS. Update man page with information regarding
> usage of action flags.
> 
> Example usage:
> 
>  # tc actions add action gact drop no_percpu
>  # sudo tc actions list action gact
>  total acts 1
> 
>         action order 0: gact action drop
>          random type none pass val 0
>          index 1 ref 1 bind 0
>         no_percpu
> 
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Applied to iproute2-next. Thanks,


