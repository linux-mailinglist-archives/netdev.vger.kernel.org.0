Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0A3304363
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 17:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392779AbhAZQIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 11:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404563AbhAZQGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 11:06:45 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073BFC061A31
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 08:05:27 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id r199so4243584oor.2
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 08:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QoEPIyyerWsun5xACWrYqq/tLeXdDiZbjDb5fNhFuKk=;
        b=jH3EWf/bq1zjjviYak1J0GEDQC+18a3NqAgszbQ+plI6AK75g7V+RbJjfmwsL2BjBQ
         e1y2HUG7SrgHn4W5GpDlfM7H3/7XgXNE1vl5X8E2JtXDESXIJuCjzjS0XUOK7+ulmVES
         Wvc0Ow5bF9CaYILwpY7YYAL/0CFgsTmCJY7VkSMWp6VP5VeCytzJ+14Qds4Z/GoRVRT2
         kQ100Zz7dSCb1jiTjUgjRaCDcgshNuMIBJgii/uTNPm9B4iQ+Ldy2FgBaOwKTPcJgyNd
         Tzrrvp/n4xWNdABHqZ3Ix6tsUujPyCLR5vcn+P2x68YpoNtL7dwwgnlrRyekUxdZ2tjN
         EdAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QoEPIyyerWsun5xACWrYqq/tLeXdDiZbjDb5fNhFuKk=;
        b=rW99EmQS9e7eQrcEtoDuR6Z87mZjPYlhu/74FJeyGh0rnp216AAvD9t1flkvoAHW9d
         +Rq1nLq7DsC9WEPOoxcrdnpAbL95jNWAY7ISobtUSGyVoN4gA1rd4/ycBBO5l5rL4dRq
         DP3gdQhD1a3PdwZKLuDxFs0MvA+je7NsLM6X/hgHTHMDeT07So3bXK6vUEZD6RQl0TFs
         12WLGQTrO4rcLCXJXUOnSuxDQ+tXQt34o80PrRCcfFVbqolm2SA3YQTIg1FWXbzBHu6z
         9efXaezUGvhZm7Zbv3fhv1mY7sMxiydfgZv7FzXTeUCH7ARlIEZTMSnYf4aL7hhcEmnr
         hlSQ==
X-Gm-Message-State: AOAM5320Q1YA1xZRgjpjxpOkbwyVfmrY2+oE/OpknWRZIW6GUNCcN4Y+
        n2HfEQQOM/YhBL0fct3Fo7Q=
X-Google-Smtp-Source: ABdhPJzebxiSNQbCuwQZBUo6Ig7owumflUDVi8zJdsQne2eZosALXAtn0kE8uUHVnFUHjjF52a7fOA==
X-Received: by 2002:a4a:e9f2:: with SMTP id w18mr4447281ooc.88.1611677126243;
        Tue, 26 Jan 2021 08:05:26 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:f5f4:6dbf:d358:29ee])
        by smtp.googlemail.com with ESMTPSA id d17sm4248985oic.12.2021.01.26.08.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 08:05:25 -0800 (PST)
Subject: Re: Linux Ipv6 stats support
To:     Yogesh Ankolekar <ayogesh@juniper.net>,
        Girish Kumar S <girik@juniper.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <PH0PR05MB7557A2136390919FB11B6714AAA09@PH0PR05MB7557.namprd05.prod.outlook.com>
 <PH0PR05MB755758D4F271A5DB8897864AAABD9@PH0PR05MB7557.namprd05.prod.outlook.com>
 <PH0PR05MB77013792D0D90212B1AA0D9EBABD9@PH0PR05MB7701.namprd05.prod.outlook.com>
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a1c21b7c-c345-0f05-2db1-3f94a2ad4f6a@gmail.com>
Date:   Tue, 26 Jan 2021 09:05:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <PH0PR05MB77013792D0D90212B1AA0D9EBABD9@PH0PR05MB7701.namprd05.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/21 4:26 AM, Yogesh Ankolekar wrote:
> 
>    We are looking for below IPv6 stats support in linux. Looks below
> stats are not supported. Will these stats will be supported in future or
> it is already supported in some version. Please guide.

I am not aware of anyone working on adding more stats for IPv6. Stephen
Suryaputra attempted to add stats a few years back as I believe the
resistance was around memory and cpu usage for stats in the hot path.
