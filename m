Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DACD613DCAC
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgAPN4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:56:54 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51663 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgAPN4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:56:53 -0500
Received: by mail-wm1-f68.google.com with SMTP id d73so3868495wmd.1
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 05:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TPojsvsruBFkmh5R4Sn2XZhT/gn9UgC49vEV8/Pvqyk=;
        b=OKOV+7nDclQZcHlC42CU/LwNwZwIwaXsbY5Un7nFvh6eGOkX4phM36EChliLcKVD78
         3hZCLEMgeB6A+6mU+WlVGCP6e3kXGZCvznaigQX+XGe/Ar/QCe5gid+xLUEFNmB+GfPz
         nkd5V/dyKioDUmxgIiOuVC7iuSR9uewOUbA9EX3vwS0mATL094PH2NuOJ/KNIKeqXhHm
         pBLlgB1S+yYTrAfbi+piEsik/kr42AUV3VDiAU9H8RcrdnZnTop5qP567HNrIOAMWn8g
         QKnQWkuAZ/eaA1CEQYj1iIBZmI8cLbhqr+95teO2IfHUugB3KFB3qSalGCpWTGUWl6cD
         YjeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TPojsvsruBFkmh5R4Sn2XZhT/gn9UgC49vEV8/Pvqyk=;
        b=PkQxpEKEKjPBHnVo0noweC+bEQahBunMkecUiJ6fL1/4i3NGf8s/TbRRGCXQINf1Tf
         j62v8RRWq2paAPPasfuxuFZ9/vPga+Yd2TQBpsJG8EMMu2/wNWTeYWSvRtoxkJ2B4qm7
         YwSpHivm60hEsoJ5UDWmvVwXo6Pfn9xt0UIwenAdq6stt90TjH7Y82QmiytRKN9YLaDc
         Y78bRHhkWcllWQ7+NoYI09JpNWzObLn+r19rIu3sEITZD9wCTjAjXnakXt3nghiwtNH0
         YVeTdeCrJ9Bdrw+q7nI9Ai23z2+6FxLQe3PaFow3dAW35NnWO6ejkBi6gVe1lL7O46XM
         j5kA==
X-Gm-Message-State: APjAAAUEy84orxKneUfqmKyUMpYvBHQNKTJyVYBVXG6G3ZA83hT/srL9
        lzv55eVEsLy4VZh9+nd5CjkCmQ==
X-Google-Smtp-Source: APXvYqwoKtV8ypKcPYIpChsk/BEL1BfpInAw53YPmsQP5BcLMFZJCiv9X66zQ81XYiGvcUMyZqXw4g==
X-Received: by 2002:a1c:41c4:: with SMTP id o187mr6345016wma.24.1579183012065;
        Thu, 16 Jan 2020 05:56:52 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id 60sm30094751wrn.86.2020.01.16.05.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 05:56:51 -0800 (PST)
Date:   Thu, 16 Jan 2020 14:56:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hongbo Yao <yaohongbo@huawei.com>, chenzhou10@huawei.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlxsw@mellanox.com
Subject: Re: [PATCH v2 -next] drivers/net: netdevsim depends on INET
Message-ID: <20200116135412.GK2131@nanopsycho>
References: <20200116131404.169423-1-yaohongbo@huawei.com>
 <20200116053137.4b9f9ff9@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116053137.4b9f9ff9@cakuba.hsd1.ca.comcast.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 16, 2020 at 02:31:37PM CET, kuba@kernel.org wrote:
>On Thu, 16 Jan 2020 21:14:04 +0800, Hongbo Yao wrote:
>> If CONFIG_INET is not set and CONFIG_NETDEVSIM=y.
>> Building drivers/net/netdevsim/fib.o will get the following error:
>> 
>> drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_hw_flags_set':
>> fib.c:(.text+0x12b): undefined reference to `fib_alias_hw_flags_set'
>> drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_destroy':
>> fib.c:(.text+0xb11): undefined reference to `free_fib_info'
>> 
>> Correct the Kconfig for netdevsim.
>> 
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Fixes: 48bb9eb47b270("netdevsim: fib: Add dummy implementation for FIB offload")
>
>Looks better :) Still missing a space between the hash and the bracket,
>but:
>
>Acked-by: Jakub Kicinski <kuba@kernel.org>
>
>While at it - does mlxsw have the same problem by any chance?

Looks like it does.
