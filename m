Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A47C594E6
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfF1H3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 03:29:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37972 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfF1H3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:29:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so5145354wrs.5
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 00:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fbuCbGZRqw8LybBMiAoI5vLTLfegKglzTkcswkYy5NQ=;
        b=VPc2TobF5YMTewEECcODydkAxH6Q0KIUETEAQ50KgyDS/V6N5KVzoBR8aw9Jy1MYwd
         PlEniOxp6mtWPP10nwSZBGFGmOnbJNUaqvMi/ZYId8bukZzuUA0HFCR5PYtQErSmBIAX
         f4JZWA0frBYby7/sdKp6/Jw5jkeFXJhg1Xbdu81alvEKq9hnktLAf72+HSCqnO16K/dY
         ELOtp9EoAPR6CXYoObJJEa2MKWJ3zNTYaJNjbXPi7v3Jp6i9+ljpPsyI4XhxmrACAV+W
         /y9ZueochCJT2e1SWt68wjmZcLPn36iOVtUHC14d9WVL5OGdIeqkGebPHuOD/hOL1ann
         C1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fbuCbGZRqw8LybBMiAoI5vLTLfegKglzTkcswkYy5NQ=;
        b=U67GgbxvSnugNworwP4++XQ9jeBmHIidEbBsp4BxLYs9tf1PHZuGDktjQxxsKWUmX/
         6ZISteH50cuQrOOGTwVDER4hOVwgmXQD+lEvD9Pvl806USeabTEpXYeCfn0wthxpHMiR
         WHpNUAFl+lhLmZj0kf8SPiJBqTC5huiFbmkJ+CTGN9lGbZtg2DFRb41bHh2aGgUxhhIB
         t+0SAPWItC2woJ+DE8HxSRsdKPWqzbmsTu730HtwOPfPYgGZ6+zUrl6mo/LFH2PcH1To
         wQz/Hmq/GptsduE5g5tnlSfRxyrt96i6VA+YWbDvLpRY4zszNeXcH1ZEt1RT8r9XEv05
         lYcQ==
X-Gm-Message-State: APjAAAU/kACsHQwUyPftgAFu0guzzPrzgKlBlxebMTclAXLBrS7M78hV
        RiRKooXB5oIditQ64Rj9d4utQw==
X-Google-Smtp-Source: APXvYqwYTMzcK6MbCZqDb5uKZGW++n0O0rx8SZjD3JmmvmKzDd9vHM4SsJOKX3EHc5rdn61CdkruCQ==
X-Received: by 2002:a5d:62c9:: with SMTP id o9mr6190209wrv.186.1561706986905;
        Fri, 28 Jun 2019 00:29:46 -0700 (PDT)
Received: from localhost ([212.89.239.228])
        by smtp.gmail.com with ESMTPSA id p3sm1044420wrd.47.2019.06.28.00.29.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 00:29:46 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:29:45 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190628072945.GA2236@nanopsycho>
References: <20190627094327.GF2424@nanopsycho>
 <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 27, 2019 at 07:14:31PM CEST, dsahern@gmail.com wrote:
>On 6/27/19 3:43 AM, Jiri Pirko wrote:
>> Hi all.
>> 
>> In the past, there was repeatedly discussed the IFNAMSIZ (16) limit for
>> netdevice name length. Now when we have PF and VF representors
>> with port names like "pfXvfY", it became quite common to hit this limit:
>> 0123456789012345
>> enp131s0f1npf0vf6
>> enp131s0f1npf0vf22
>
>QinQ (stacked vlans) is another example.

There are more usecases for this, yes.


>
>> 
>> Since IFLA_NAME is just a string, I though it might be possible to use
>> it to carry longer names as it is. However, the userspace tools, like
>> iproute2, are doing checks before print out. So for example in output of
>> "ip addr" when IFLA_NAME is longer than IFNAMSIZE, the netdevice is
>> completely avoided.
>> 
>> So here is a proposal that might work:
>> 1) Add a new attribute IFLA_NAME_EXT that could carry names longer than
>>    IFNAMSIZE, say 64 bytes. The max size should be only defined in kernel,
>>    user should be prepared for any string size.
>> 2) Add a file in sysfs that would indicate that NAME_EXT is supported by
>>    the kernel.
>
>no sysfs files.
>
>Johannes added infrastructure to retrieve the policy. That is a more
>flexible and robust option for determining what the kernel supports.

Sure, udev can query rtnetlink. I just proposed it as an option, anyway,
it's implementation detail.


>
>
>> 3) Udev is going to look for the sysfs indication file. In case when
>>    kernel supports long names, it will do rename to longer name, setting
>>    IFLA_NAME_EXT. If not, it does what it does now - fail.
>> 4) There are two cases that can happen during rename:
>>    A) The name is shorter than IFNAMSIZ
>>       -> both IFLA_NAME and IFLA_NAME_EXT would contain the same string:
>>          original IFLA_NAME     = eth0
>>          original IFLA_NAME_EXT = eth0
>>          renamed  IFLA_NAME     = enp5s0f1npf0vf1
>>          renamed  IFLA_NAME_EXT = enp5s0f1npf0vf1
>>    B) The name is longer tha IFNAMSIZ
>>       -> IFLA_NAME would contain the original one, IFLA_NAME_EXT would 
>>          contain the new one:
>>          original IFLA_NAME     = eth0
>>          original IFLA_NAME_EXT = eth0
>>          renamed  IFLA_NAME     = eth0
>>          renamed  IFLA_NAME_EXT = enp131s0f1npf0vf22
>
>so kernel side there will be 2 names for the same net_device?

Yes. However, updated tools (which would be eventually all) are going to
show only the ext one.



>
>> 
>> This would allow the old tools to work with "eth0" and the new
>> tools would work with "enp131s0f1npf0vf22". In sysfs, there would
>> be symlink from one name to another.
>
>I would prefer a solution that does not rely on sysfs hooks.

Please note that this /sys/class/net/ifacename dirs are already created.
What I propose is to have symlink from ext to the short name or vice
versa. The solution really does not "rely" on this...


>
>>       
>> Also, there might be a warning added to kernel if someone works
>> with IFLA_NAME that the userspace tool should be upgraded.
>
>that seems like spam and confusion for the first few years of a new api.

Spam? warn_once?


>
>> 
>> Eventually, only IFLA_NAME_EXT is going to be used by everyone.
>> 
>> I'm aware there are other places where similar new attribute
>> would have to be introduced too (ip rule for example).
>> I'm not saying this is a simple work.
>> 
>> Question is what to do with the ioctl api (get ifindex etc). I would
>> probably leave it as is and push tools to use rtnetlink instead.
>
>The ioctl API is going to be a limiter here. ifconfig is still quite
>prevalent and net-snmp still uses ioctl (as just 2 common examples).
>snmp showing one set of names and rtnetlink s/w showing another is going
>to be really confusing.

I don't see other way though, do you? The ioctl names are unextendable :/

