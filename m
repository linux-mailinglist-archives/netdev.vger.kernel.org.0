Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FC727BA71
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgI2BqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2BqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:46:19 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5D8C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 18:46:19 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q4so1803731pjh.5
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 18:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IHWeMwuA+cdmG/atyv2u/4fMfgQD87kJfeErjhyYSlk=;
        b=sFpbbP/VVVirvIZfkThUJwTA58KbGJlkob6nQFt1tGo/+WWzl78wmTy4n/v/3cUT/K
         nMHK2Ssx+jQV3bgdkdsa+61+Co+GKZeHdUDWd2eCyh1+/BLakGyG/FA73afmn2wg6ebM
         btrAC8+U+2iN62OIZyKi1ru56wbnnsjZGaWsMXlZhI4Myc/85Mps42StHg1ts6togqhe
         bwwqYgcyqWJnas1fLYTJ+wFi+C9o4X6xDkgg308lhQkG1mbs8xxnJoR6FgmGGTTss4NL
         xtk1ocCiiZHlaadTQzx2C/tMWEQvBnuu6EGyWphfAzgY8Gipjkcdvq7SnHswXQ47sT9P
         iLcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IHWeMwuA+cdmG/atyv2u/4fMfgQD87kJfeErjhyYSlk=;
        b=mFOFfMLZfTt+H6RxXrpOpeDFqClZhLCrj2CxD++O6jGu4IrA6FqTxoKwHmyFqyQYaF
         NXWPJK04BvuB5431oC+OiWa/BxSj9pAQjPtYJcRH7ojUKQGmmnurapVjt3M4mmbFmmyB
         Z65DBEIXvhFfEOjkyQIbJD/CxusqzXJ6zKfp66vAO3Z4IK4gNZLVq9mcuevWxPOOk470
         5OedJesRYU3EUz6jF0VHR9reG5qHG0cNoCHRsmx4tjSPiQyPDg9twvN+VeiO398rhH5P
         aU3lIOUthBXXO7+i/zlGK1A1i2h405gs/hRJ9HYmnV30GE3Tty4/0+lBMfGiCwXpF5YN
         TNWg==
X-Gm-Message-State: AOAM531GiaSDv3wrDO8PdYffiy+ah3bAamN31zxNl1wWMh92is0LYqvM
        F1zX5rcAkw8iIVJcKo7shxM=
X-Google-Smtp-Source: ABdhPJwovrpZKJ6LSJYvH7Mpl2JekuTW5bWiYx5kZ+DdNqi4HPiVUWv6SHJYbyK+vNzrP3Bet7ymRQ==
X-Received: by 2002:a17:90b:1211:: with SMTP id gl17mr1785010pjb.87.1601343978764;
        Mon, 28 Sep 2020 18:46:18 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e17sm3137726pff.6.2020.09.28.18.46.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 18:46:17 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-2-andrew@lunn.ch>
 <20200928143155.4b12419d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200928220507.olh77t464bqsc4ll@skbuf> <20200928220730.GD3950513@lunn.ch>
 <20200928153504.1b39a65d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
 <20200928163936.1bdacb89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c877bda0-140c-dce1-49ff-61fac47a66bc@gmail.com>
Date:   Mon, 28 Sep 2020 18:46:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200928163936.1bdacb89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/28/2020 4:39 PM, Jakub Kicinski wrote:
> On Mon, 28 Sep 2020 15:36:50 -0700 Florian Fainelli wrote:
>> On 9/28/2020 3:35 PM, Jakub Kicinski wrote:
>>> On Tue, 29 Sep 2020 00:07:30 +0200 Andrew Lunn wrote:
>>>> On Mon, Sep 28, 2020 at 10:05:08PM +0000, Vladimir Oltean wrote:
>>>>> On Mon, Sep 28, 2020 at 02:31:55PM -0700, Jakub Kicinski wrote:
>>>>>> On Sat, 26 Sep 2020 23:06:26 +0200 Andrew Lunn wrote:
>>>>>>> Not all ports of a switch need to be used, particularly in embedded
>>>>>>> systems. Add a port flavour for ports which physically exist in the
>>>>>>> switch, but are not connected to the front panel etc, and so are
>>>>>>> unused.
>>>>>>
>>>>>> This is missing the explanation of why reporting such ports makes sense.
>>>>>
>>>>> Because this is a core devlink patch, we're talking really generalistic
>>>>> here.
>>>>
>>>> Hi Vladimir
>>>>
>>>> I don't think Jakub is questioning the why. He just wants it in the
>>>> commit message.
>>>
>>> Ack, I think we need to clearly say when those should be exposed.
>>> Most ASICs will have disabled ports, and we don't expect NICs to
>>> suddenly start reporting ports for all PCI PFs they may have.
>>>
>>> Also I keep thinking that these ports and all their objects should
>>> be hidden under some switch from user space perspective because they
>>> are unlikely to be valuable to see for a normal user. Thoughts?
>>
>> Hidden in what sense? They are already hidden in that there is no
>> net_device object being created for them. Are you asking for adding
>> another option to say, devlink show like:
>>
>> devlink show -a
>>
>> which would also show the ports that are disabled during a dump?
> 
> Yup, exactly. Looks like ip uses -a for something I don't quite
> understand - but some switch along those lines. We already have
> -d for hiding less-relevant attributes.
> 
> Do you think this is an overkill? I don't feel strongly.

That makes sense to me as it would be confusing to suddenly show unused 
port flavors after this patch series land. Andrew, Vladimir, does that 
work for you as well?
-- 
Florian
