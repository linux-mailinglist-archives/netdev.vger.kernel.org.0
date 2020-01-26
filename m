Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35D92149D57
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 23:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgAZWVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 17:21:04 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40010 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgAZWVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 17:21:03 -0500
Received: by mail-pf1-f196.google.com with SMTP id q8so3990292pfh.7
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 14:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=2qobJGOl3MqPUo0qYrlkgJ1xbb0O4O5NLS5Pl3hJ6Vo=;
        b=jTJEVZTJN5JzjCcn/+aEMT53FdikonofqgsVYj4+hq8ZfN+inHKpuLJgFIpWwJvL+B
         YEsZoqJF+b23tKyZ+TxMfGanZCsPhy4TQKA4rtf+tzheB60SItIJaQwiTwCL83l1nAHN
         gyZuJ85/mZWPwlBeDFwpL/nzJ4Blabr5/B3MvR4BBY7FX+m2FhM/ryf1ZNGq2umb5rs/
         Fy/4C7GsttdZGh1j1nupa9VxsENjy7q5w3ASCtzMBxSzu5l8z40zAhR9U25v1J+LA/eB
         1JSAjzmiFdLR0fAcdz99r3+qZigEqueagIzuG/rHQLIvvTCuiqTz0ir42sxhrfoNR41i
         Ln2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2qobJGOl3MqPUo0qYrlkgJ1xbb0O4O5NLS5Pl3hJ6Vo=;
        b=Nu+kwTfiJ1ik9eQVIPrWHkfO2UWHsOTgMXI9KvRJU1HVd8/MeoP3jpjOb/THC1A52h
         908ZGaRnFwirpCgqV894zD6aDmHbASBHX2GctGVhPuX/C8skCDENuvWMQuP/tZs0BfAO
         yKgqLVEdjhNiJhROeYbUNJaygDRXZURMIq6Aq0dsh3fCZW4SPRWEsGThMmi5yTnAdQcW
         guB9iZv18yh/osERzwnvAO3xnNAcusNB0hy9zHNBV3CkQKx73hmawIvv0F1AgNl/0JFr
         lT2JVXjHY22YIUgKils06mhrzLExla3yO6D3vckEjCJoEGBsZBuqwXKIM4JuUfk6dhcF
         ME2Q==
X-Gm-Message-State: APjAAAXE+02I3V+WvDYcQK+n0DW8Ie/vXbkK+JUU374F/dMt7LFJCS61
        PsdqoAl3cxJotJfVH1opbCM8tw==
X-Google-Smtp-Source: APXvYqwVt2LxgzEZ1Lsk1j8EUmd5N/BVRa7rhbtUJodcmaNr3MYdiDdXPUvBH/r5fwvR2euOvxKZfA==
X-Received: by 2002:a62:64d8:: with SMTP id y207mr6594094pfb.208.1580077263076;
        Sun, 26 Jan 2020 14:21:03 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id i2sm13597220pgi.94.2020.01.26.14.21.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 14:21:02 -0800 (PST)
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
To:     Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal> <20200126124957.78a31463@cakuba>
 <20200126210850.GB3870@unreal> <20200126133353.77f5cb7e@cakuba>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <2a8d0845-9e6d-30ab-03d9-44817a7c2848@pensando.io>
Date:   Sun, 26 Jan 2020 14:21:58 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200126133353.77f5cb7e@cakuba>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/20 1:33 PM, Jakub Kicinski wrote
>> The long-standing policy in kernel that we don't really care about
>> out-of-tree code.
> Yeah... we all know it's not that simple :)
>
> The in-tree driver versions are meaningless and cause annoying churn
> when people arbitrarily bump them. If we can get people to stop doing
> that we'll be happy, that's all there is to it.
>
Perhaps it would be helpful if this standard was applied to all the 
drivers equally?  For example, I see that this week's ice driver update 
from Intel was accepted with no comment on their driver version bump.

Look, if we want to stamp all in-kernel drivers with the kernel version, 
fine.  But let's do it in a way that doesn't break the out-of-tree 
driver ability to report something else.  Can we set up a macro for 
in-kernel drivers to use in their get_drvinfo callback and require 
drivers to use that macro?  Then the out-of-tree drivers are able to 
replace that macro with whatever they need.  Just don't forcibly bash 
the value from higher up in the stack.

sln

