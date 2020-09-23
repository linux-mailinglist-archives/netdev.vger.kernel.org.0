Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35370276181
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 21:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIWT7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 15:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWT7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 15:59:10 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C673C0613CE;
        Wed, 23 Sep 2020 12:59:10 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x14so1275926wrl.12;
        Wed, 23 Sep 2020 12:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wmckwTRXRvwQPVN9iH8EtFcdLmuwcKJsSJQfHvWc6QA=;
        b=o84bTiU0vqCk8XXCH5L4VxLBL1T+vJsaC4axNiyRlTtxnhGFoJ6Zn6OW9PJpWWkVMM
         /7KCWAkro1wKfRJtBI9RuTvp1vjAJ9v3Ov1/DZTqhlqaJa4l2OXpXy2B/zTwcYHalCGb
         ACCiOmXDpXRZEbpdWtjJxtfHLYP0mCg/FJRlFvbG4zLKJCKqbX8JSY3G38ZVQ4KchUNw
         KfYuwgMb1G7yd4Rp0q1KjPjD3LWn/jz7MYZbmx9FPwDiCISI1aPceUn0XbBr/yMwXnLK
         TgihhXGO8OX/KUDlspz4F8n5aobr2BbGgCf+IgaM2kwTLYza1CJoOcclOLcLUlvD7d8L
         MEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wmckwTRXRvwQPVN9iH8EtFcdLmuwcKJsSJQfHvWc6QA=;
        b=oIqQsVmrYxPWRLvsfLkTaMKeQqNcoaHIeiMzitp9WzqneGDKjCksGJX8keQzgSRSb5
         1U+mJOLR3e+eE4ot8iyq123+SQ5bwTaVLtKEaQVQujbvmmBI2lADO50Y/ffndPeCuvu+
         NRyigNKgZYhYXmB5+cNDq9Q+iyDKxBbzI84afH6pILxsS5rs2N5QiAxicrql2FbHoRq8
         uZyI6tlmHgZRouPEqnPm9qTwscN6PrTCgqQhyKzWYVRmZLS/823tFTNqLDbpcQ9TsmL2
         K+GuM2RsUXqXWex+rO02R3/PPKj/xJhRkeV2Ea4YuMc585j7CSSuJXK8honuDNVL4FvL
         uZQg==
X-Gm-Message-State: AOAM532W5Ave3/IwtHCnz5RwVoGAQ/O4WzklrgXkQ0iaSP32OMt9zr0U
        ctsTFLFQrwzoZuNQP6Wj5vTMuh6RgWU=
X-Google-Smtp-Source: ABdhPJy2z/Hrts/zKxyRH/xTHeWNyCPxMQZw5ecoJ/QD4Prcgxb8eBJLN8/cP/vkQSC9Z3I6ycjNAw==
X-Received: by 2002:adf:fa52:: with SMTP id y18mr1339142wrr.264.1600891147751;
        Wed, 23 Sep 2020 12:59:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:9dd1:2d79:8cda:7fd2? (p200300ea8f2357009dd12d798cda7fd2.dip0.t-ipconnect.de. [2003:ea:8f23:5700:9dd1:2d79:8cda:7fd2])
        by smtp.googlemail.com with ESMTPSA id v17sm1044439wrc.23.2020.09.23.12.59.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 12:59:07 -0700 (PDT)
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
To:     Saeed Mahameed <saeed@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Gaku Inami <gaku.inami.xh@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200901150237.15302-1-geert+renesas@glider.be>
 <7bfebfdc0d7345c4612124ff00e20eebb0ff6cd9.camel@kernel.org>
 <3d9176a6-c93e-481c-5877-786f5e6aaef8@gmail.com>
 <28da797abe486e783547c60a25db44be0c030d86.camel@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <14f41724-ce45-c2c0-a49c-1e379dba0cb5@gmail.com>
Date:   Wed, 23 Sep 2020 21:58:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <28da797abe486e783547c60a25db44be0c030d86.camel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.09.2020 20:35, Saeed Mahameed wrote:
> On Wed, 2020-09-23 at 13:49 +0200, Heiner Kallweit wrote:
>> On 18.09.2020 19:58, Saeed Mahameed wrote:
>>> On Tue, 2020-09-01 at 17:02 +0200, Geert Uytterhoeven wrote:
>>>> This reverts commit 124eee3f6955f7aa19b9e6ff5c9b6d37cb3d1e2c.
>>>>
>>>> Inami-san reported that this commit breaks bridge support in a
>>>> Xen
>>>> environment, and that reverting it fixes this.
>>>>
>>>> During system resume, bridge ports are no longer enabled, as that
>>>> relies
>>>> on the receipt of the NETDEV_CHANGE notification.  This
>>>> notification
>>>> is
>>>> not sent, as netdev_state_change() is no longer called.
>>>>
>>>> Note that the condition this commit intended to fix never existed
>>>> upstream, as the patch triggering it and referenced in the commit
>>>> was
>>>> never applied upstream.  Hence I can confirm s2ram on
>>>> r8a73a4/ape6evm
>>>> and sh73a0/kzm9g works fine before/after this revert.
>>>>
>>>> Reported-by Gaku Inami <gaku.inami.xh@renesas.com>
>>>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>>>> ---
>>>>  net/core/link_watch.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/core/link_watch.c b/net/core/link_watch.c
>>>> index 75431ca9300fb9c4..c24574493ecf95e6 100644
>>>> --- a/net/core/link_watch.c
>>>> +++ b/net/core/link_watch.c
>>>> @@ -158,7 +158,7 @@ static void linkwatch_do_dev(struct
>>>> net_device
>>>> *dev)
>>>>  	clear_bit(__LINK_STATE_LINKWATCH_PENDING, &dev->state);
>>>>  
>>>>  	rfc2863_policy(dev);
>>>> -	if (dev->flags & IFF_UP && netif_device_present(dev)) {
>>>> +	if (dev->flags & IFF_UP) {
>>>
>>> So with your issue the devices is both IFF_UP and !present ? how so
>>> ?
>>> I think you should look into that.
>>>
>>> I am ok with removing the "dev present" check from here just
>>> because we
>>> shouldn't  be expecting IFF_UP && !present .. such thing must be a
>>> bug
>>> somewhere else.
>>>
>>>>  		if (netif_carrier_ok(dev))
>>>>  			dev_activate(dev);
>>>>  		else
>>
>> In __dev_close_many() we call ndo_stop() whilst IFF_UP is still set.
>> ndo_stop() may detach the device and bring down the PHY, resulting in
>> an
> 
> Why would a driver detach the device on ndo_stop() ?
> seems like this is the bug you need to be chasing ..
> which driver is doing this ? 
> 
Some drivers set the device to PCI D3hot at the end of ndo_stop()
to save power (using e.g. Runtime PM). Marking the device as detached
makes clear to to the net core that the device isn't accessible any
longer.

>> async link change event that calls dev_get_stats(). The latter call
>> may
>> have a problem if the device is detached. In a first place I'd
>> consider
>> such a case a network driver bug (ndo_get_stats/64 should check for
>> device presence if depending on it).
> 
> Device drivers should avoid presence check as much as possible
> especially in ndo, this check must be performed by the stack.
> 
That's a question I also stumbled across. For the ethtool ops
dev_ethtool() checks whether device is present.
But for ndo that's not always the case, e.g. dev_get_stats()
doesn't check for device presence before calling ndo_get_stats()
or ndo_get_stats64().
To a certain extent I can understand this behavior, because drivers
may just use internal data structures in ndo ops instead of accessing
the device.

>> The additional check in linkwatch_do_dev() was meant to protect from
>> such
>> driver issues.
> 

