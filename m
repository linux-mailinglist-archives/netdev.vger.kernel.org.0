Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F417149D44
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 23:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgAZWLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 17:11:44 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42862 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbgAZWLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 17:11:43 -0500
Received: by mail-pl1-f195.google.com with SMTP id p9so3035406plk.9
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 14:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=n5qGcAaShVjdAONHjUZjFQvCWxD3ogfJfCSb9GV3HdM=;
        b=BkZpBnc8Aqzf7GcMo3K4eM2tl5LMLZhsEwl5daLCswd+QsoxyI5LKM9FtoyroeZptA
         uwRsGQvLlN0fLEFRVyPaG4T2Lb1eeJ0V4l5AiLSi5zN819wFgOYy7Gv9QVCgoFAScDB+
         0UtUR8tUxYyG5+jq8+Fwrj5TUo8iWO+SrmPiA7gLwSfyDm4b2Hws+J/1iB0H0yQZK6l3
         pS7i2WEMFpGSVV0lpzrYD9KzaQM5eg0ZskkZ4LWEtbl9cetkYBKdc3wbwDRiq9DLafXC
         GsnxnUO7QM+PPva5EXeOoOvwrgS7e4RaT3UPxecrlqzMPYoq6iW9rg4htdqHLu+kuC0r
         0+/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=n5qGcAaShVjdAONHjUZjFQvCWxD3ogfJfCSb9GV3HdM=;
        b=QR4tLjLKTw0dnrN56s1NsmDOw0NOewf4CHc+6nazdfbqrJHwCpE5AfAKiVxYpmxV3y
         XZpvTrZxUyYBwFmyNopnXfZa8o+kEg4wyAi5HVOSIHjgPfl+F+8NXvbWD/dI1lSw8m0P
         EzDvg2Tf7QexJQbWn8ctMzRIeugJQPUmealphbukkrP6taDUj5wU5HQ0uOlzwt7k2BZM
         IIZJd14QJs5mLzYzCxbts2AqRPN0wxEod8doBmna7K9QAqezPvSqmLeoAMv5czzSDTY/
         M63EQWx4FMX8X5mY/hkX3STFanQdHSYzJ2rTybEqKajZcWky8fW5Prjk/X9BdiVnpfrI
         QqTA==
X-Gm-Message-State: APjAAAUEZ0RaL2WKtKD/e5k47NI0AJJzBp2W/TL6LMC0v0RYolkEPs2V
        6bJ/aylMOjrbh9srko+hSLcvTg==
X-Google-Smtp-Source: APXvYqxkKXskt5nS0KLwvMKIvLpFjOfvgnrLWD7xbc/E87saaEXj7lY//x/kiOmsR9MZJqCg7pUjKQ==
X-Received: by 2002:a17:902:82cc:: with SMTP id u12mr13692479plz.342.1580076703085;
        Sun, 26 Jan 2020 14:11:43 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id u1sm12884680pfn.133.2020.01.26.14.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 14:11:42 -0800 (PST)
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal> <20200126124957.78a31463@cakuba>
 <20200126210850.GB3870@unreal>
 <31c6c46a-63b2-6397-5c75-5671ee8d41c3@pensando.io>
 <20200126212424.GD3870@unreal>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <0755f526-73cb-e926-2785-845fec0f51dd@pensando.io>
Date:   Sun, 26 Jan 2020 14:12:38 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200126212424.GD3870@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/20 1:24 PM, Leon Romanovsky wrote:
> On Sun, Jan 26, 2020 at 01:17:52PM -0800, Shannon Nelson wrote:
>> On 1/26/20 1:08 PM, Leon Romanovsky wrote:
>>> The long-standing policy in kernel that we don't really care about
>>> out-of-tree code.
>> That doesn't mean we need to be aggressively against out-of-tree code.  One
>> of the positive points about Linux and loadable modules has always been the
>> flexibility that allows and encourages innovation, and helps enable more
>> work and testing before a driver can become a fully-fledged part of the
>> kernel.  This move actively discourages part of that flexibility and I think
>> it is breaking part of the usefulness of modules.
> You are mixing definitions, nothing stops those people to innovate and
> develop their code inside kernel and as standalone modules too.
>
> It just stops them to put useless driver version string inside ethtool.
> If they feel that their life can't be without something from 90s, they
> have venerable MODULE_VERSION() macro to print anything they want.
>
Part of the pain of supporting our users is getting them to give us 
useful information about their problem.  The more commands I need them 
to run to get information about the environment, the less likely I will 
get anything useful.  We've been training our users over the years to 
use "ethtool -i" to get a good chunk of that info, with the knowledge 
that the driver version is only a hint, based upon the distro involved.  
I don't want to lose that hint.  If anything, I'd prefer that we added a 
field for UTS_RELEASE in the ethtool output, but I know that's too much 
to ask.

If the driver can put its "useless" version info into the 
MODULE_VERSION, why is it not acceptable for the ethtool driver version 
field?

... and as beauty is in the eye of the beholder, a judgement of 
"useless" is a personal thing.  Personally, I find it the driver version 
useful.

sln

