Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC28E17C89A
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 23:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCFW5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 17:57:33 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38024 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgCFW5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 17:57:32 -0500
Received: by mail-pf1-f194.google.com with SMTP id g21so1809895pfb.5
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 14:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=H8PEBuN12OFR6vza26a2YTZGgmcC3T+qMA5Ba5HaJew=;
        b=DwXWz2qz13knqaGjpq2Zh7pa/p5CWNz50ayGugdAXy22e3HQ/pGWWGen3CyomXmJRU
         msNwG2F/uOn3CpZnI/6EBgNbMkrkNhKtPHc8bofYqSfXzBXBF2Y00Cy97qHes/R7LVox
         0l+YcPndZLwDw+GcldZkSIvKGAAuBIpRc/Nh1OPc284Rilemg4jzgKkrsnmBfEPF5+zr
         uJovMYT4FZGlOVi6fbREE2oJtXPHfG1PyfCMUrV6h21DkTu6pzT6KLOs4JdIir3Je5mk
         UllaslL1XUqK2YIKMNpvgyafLSfO3xnzMz5cCh7Fj8kx8t/H3aDdX+q8pHkgaIZDrii3
         x1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=H8PEBuN12OFR6vza26a2YTZGgmcC3T+qMA5Ba5HaJew=;
        b=c34rn9iPS7tHhK4ML/itmFOP7oEaKc0OwcVwgBShCmGh3jimcsydB8doKQZsRKc83t
         x4adgRE2A6S5RH++Zwm30M/Er74oT7RMnBJzo7fhUtdleXKoRpztoKCQz3ZlgvfbS7vO
         eZqEH3t3uUDwp4M9r7HHBOjr8VzUIPW5v7jWwW80SDMX97dGBN7m++MECcMlO+sQBnU+
         3gVjUk/7wKQqCgRCls1cSlA9z/eoULLxSu2C6nvE2p5h3PA2AiwHLQ0Wg3qo9Vp+q/US
         7xDsRYNm/utROJmmiPqsB4rIcsjyZE0ZkrUdK6JyC1LU4preJDXoVpNX+7r+rmjYDsBp
         FtBA==
X-Gm-Message-State: ANhLgQ3zaZRZJczTIss/xxax8lgc9UdY45ZLv3MiO8MSdT7vDUq+4Nds
        Vh92jjhBK5YuAqFRO/yHVWKORV5WN0I=
X-Google-Smtp-Source: ADFU+vveSNBxjoora2J+vCjSbv7ZcTgNRGh0PW+Y2uIGjp/WvfH6NmO/3uMRJFBE5oxD8aSPngj31Q==
X-Received: by 2002:a63:1459:: with SMTP id 25mr5562079pgu.427.1583535451253;
        Fri, 06 Mar 2020 14:57:31 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id 7sm10312181pjm.35.2020.03.06.14.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 14:57:30 -0800 (PST)
Subject: Re: [PATCH v3 net-next 7/8] ionic: add support for device id 0x1004
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jiri Pirko <jiri@resnulli.us>
References: <20200305052319.14682-1-snelson@pensando.io>
 <20200305052319.14682-8-snelson@pensando.io>
 <20200305140322.2dc86db0@kicinski-fedora-PC1C0HJN>
 <d9df0828-91d6-9089-e1b4-d82c6479d44c@pensando.io>
 <20200305171834.6c52b5e9@kicinski-fedora-PC1C0HJN>
 <3b85a630-8387-2dc6-2f8c-8543102d8572@pensando.io>
 <20200306102009.0817bb06@kicinski-fedora-PC1C0HJN>
 <5ac3562b-47b1-a684-c7f2-61da1a233859@pensando.io>
 <20200306132825.2568127a@kicinski-fedora-PC1C0HJN>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <b9351a60-3722-5b5c-a521-219a9e43ecfb@pensando.io>
Date:   Fri, 6 Mar 2020 14:57:29 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200306132825.2568127a@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/6/20 1:28 PM, Jakub Kicinski wrote:
> On Fri, 6 Mar 2020 12:32:51 -0800 Shannon Nelson wrote:
>>>> However, this device id does exist on some of the DSC configurations,
>>>> and I'd prefer to explicitly acknowledge its existence in the driver and
>>>> perhaps keep better control over it, whether or not it gets used by our
>>>> 3rd party tool, rather than leave it as some obscure port for someone to
>>>> "discover".
>>> I understand, but disagree. Your driver can certainly bind to that
>>> management device but it has to be for the internal use of the kernel.
>>> You shouldn't just expose that FW interface right out to user space as
>>> a netdev.
>> So for now the driver should simply capture and configure the PCI
>> device, but stop at that point and not setup a netdev.  This would leave
>> the device available for devlink commands.
>>
>> If that sounds reasonable to you, I'll add it and respin the patchset.
> I presume the driver currently creates a devlink instance per PCI
> function? (Given we have no real infrastructure in place to combine
> them.) It still feels a little strange to have a devlink instance that
> doesn't represent any entity user would care about, but a communication
> channel. It'd be better if other functions made use of the
> communication channel behind the scene. That said AFAIU driver with just
> a devlink instance won't allow passing arbitrary commands, so that would
> indeed address my biggest concern.
>
> What operations would that devlink instance expose?

Being as this is still a new idea for us and we aren't up to speed yet 
on what all devlink offers, I don't have a good answer at the moment.  
For now, nothing more than already exposed, which is simple device info.

sln

