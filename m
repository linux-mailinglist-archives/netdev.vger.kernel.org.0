Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05FEF2E638
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 22:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfE2Uf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 16:35:28 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44648 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfE2Uf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 16:35:28 -0400
Received: by mail-ot1-f66.google.com with SMTP id g18so3400388otj.11;
        Wed, 29 May 2019 13:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JZf/KUpVGbO+aa71myahG/LJYO4Ln8SWPddjSV6CGEY=;
        b=IkL1IQvBWqwF8FOA+9slLTyMLLisFAftKB2uSB5DQM/RTA5jjJBkS8uBpGkz9Oa7no
         1WTxwPpJZz5gz5fJUdpUyNFrgULoYOJE6pQcSUtWDvf+DA9K2FPSr42EDnmpqycVdWGw
         JWsW1qV4FgcyoB+dcarPRqnoEGYoWNA7UTVpER66vaGBfoRAYgPm4X9hOq0WVCdZPj0x
         Wl84urzicC4p/K/LayIFbbjt7fJOQ4ybeXwK/V6mRICzWWTcKTcyRSywpyjpMN40/jzS
         YulM+ZWsWZGkMt12ep/EWeuQoPZYuxUwJ0jb1EJfEq/80og9X2KOzf0jWUlxwTZAV5/0
         Qpzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JZf/KUpVGbO+aa71myahG/LJYO4Ln8SWPddjSV6CGEY=;
        b=tCPC8McoFyecDPZP6HBZWlpcFO6+ORflCWK5HjtQYDKVCqRqwZm/ztaytwQwLpNGAg
         trvbe0lU176Icv30cRt8iwBwn0Dwi3wfMfz/FIhvBnv3BuYOrGhlzHyMCZQ6ou373lb/
         drrsxlKAe0ql7AZup2FA1SuaVleP+25n9IiP13H9GxK7Nuxzp1PfvLYxVWDmHPFocY0b
         CEmPFm9aURjbrPbCnPEkuzQ++loBisoEMZsNHvvTfR4YcbvxBSdahbz4Da1TW50tIxhz
         rVTbZ8ubgGCaydx4EstdNVTjEPAYn7o9l9fLll5oex9apNxl5TuC2LGp0RCKuadRTSG0
         8M2A==
X-Gm-Message-State: APjAAAV9SdTyy7BGz0Ox9CZ1n6n5qz5KvswlmKpJn6AUwUqQSNbtI8Jf
        9ZMxG8Uo9YgZYUMiyXf1QNs=
X-Google-Smtp-Source: APXvYqyZZ2DA3L96zPN0AYVjNJ5gQHvl0/JpFog0zHMJOkooeNjgiqw1YwiBXFN4EcG+1SUSg3hjIQ==
X-Received: by 2002:a9d:3de1:: with SMTP id l88mr11469320otc.222.1559162127529;
        Wed, 29 May 2019 13:35:27 -0700 (PDT)
Received: from [192.168.1.249] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id r7sm202279oia.22.2019.05.29.13.35.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 13:35:26 -0700 (PDT)
Subject: Re: cellular modem APIs - take 2
To:     Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
References: <b59be15f1d0caa4eaa4476bbd8457afc44d57089.camel@sipsolutions.net>
 <cb2ef612be9e347a7cbceb26831f8d5ebea4eacf.camel@redhat.com>
 <58bc88b7eda912133ad0fc4718ac917adc8fa63b.camel@sipsolutions.net>
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <350b9aad-7b08-2f77-6000-095538f32abc@gmail.com>
Date:   Wed, 29 May 2019 15:35:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <58bc88b7eda912133ad0fc4718ac917adc8fa63b.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

> 
> It just seemed that people do want to have a netdev (if only to see that
> their driver loaded and use ethtool to dump the firmware version), and
> then you can reassign it to some actual context later?

I can see that this is useful for developers, but really 
counterproductive in production.  You have a bunch of services (systemd, 
NM, ConnMan, dhcpcd, etc, etc, etc) all observing the newly created 
devices and trying to 'own' them.  Which makes no freaking sense to do 
until those devices are really usable.  Just because it is a netdev, 
doesn't mean it is ethernet or behaves like it.

That also leads to expectations from users that want stuff like 
udev-consistent-naming to work, even though udev has no idea wtf a given 
device is, when it is ready or not ready, etc.  And the flip side, there 
may be systems that do not use systemd/udevd, so the daemons responsible 
for management of such devices cannot sanely assume anything.  It is 
just pure chaos.

And then there's hotplug/unplug to worry about ;)

So I would like to reiterate Marcel's point: creating unmanaged devices 
should not be the default behavior.

> 
> It doesn't really matter much. If you have a control channel and higher-
> level abstraction (wwan device) then having the netdev is probably more
> of a nuisance and mostly irrelevant, just might be useful for legacy
> reasons.

Which we should be trying to eradicate, not encourage ;)

>> Should you really need to account for these specially, or would some
>> kind of sysfs linkage like SET_NETDEV_DEV() be more appropriate?
>>
>> Really all you want to do is (a) identify which WWAN device a given
>> control/data channel is for and (b) perhaps tag different control/data
>> channels with attributes like primary/secondary/gps/sim/etc often
>> through USB attributes or hardcoded data on SoCs.

Userspace can also choose to do its own multiplexing, so you can't even 
really assume the above is what you 'want'.

Regards,
-Denis
