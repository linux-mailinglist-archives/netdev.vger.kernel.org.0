Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E16275772
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 13:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgIWLtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 07:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgIWLtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 07:49:43 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A00C0613CE;
        Wed, 23 Sep 2020 04:49:42 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id y15so6801332wmi.0;
        Wed, 23 Sep 2020 04:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p4sMBWzXBxVz4HvD3n4l2QIDm0SxypO/fE8nCP81NYo=;
        b=hVurwq/6/XhFXJ6RoPXK1EGdTYQ6vzFdgejDABeebl0RtKDkmGFD+KdNAxd8/A9JjX
         ir1KTle+zPq8HVtGgHOCF1NbP340ypt9arNONJOVxUYZquWaqnxmcQ3gb8StBWVA8Dfx
         v+Lh4dW0ZkzbMTMKpV1Ge813iSjzUYfYJkEl+r1GXJUIWNZxkwLL+CBWP8VYSRtATc/B
         5aFvcuMf4SiOPuuhVdVTkUtv7Psy3nn1U3MarmiWquAVZX2jGZcyJ5wMdcqiRck5Yaqx
         j9tHaigvMiCHJ2lEK5xbq4EFENaf/BSnFna2XopimZ0iURvIzc/UaOIbxIZrLsgIJLPJ
         U06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p4sMBWzXBxVz4HvD3n4l2QIDm0SxypO/fE8nCP81NYo=;
        b=I29Xphixsqtqa74TJL7gYYcJUlrpMsqKdGaGn4dPZbJUF9agfGbYsFJJ6snMU4cJHG
         vXxnR7SNKjv4xuq5SA4w/KHto0MgG6+/FXuNDHSdVdVdssZRD9G8dwY06/0ETuGx2QCT
         fjYY6gHbUGckREVu2PnasFyjxhbiae45Cchgb+OFaE5YtV+hYLO7M8LPZmayZH4Kg+Do
         O5nLXH8vH+frQnDCdrF53NWjgy1J8eJ2F4YJKjUK+0KdZ55Ffjs9zqBbf9V8l4mAav47
         YsDkLJ5cZt+ISkj/ogcYA4hjtqVYKuGL/Id3kMnjiwWGtyhQf+M+oFAJ+NRjj6fLyHmZ
         DVCA==
X-Gm-Message-State: AOAM531LbAa31uo288aFm+KKxM08G8WZb7/4T7wwlkQ2FgfrfC+WS7j2
        ijiG0XTZM9es8N32G+1r3D8gpKZN2Js=
X-Google-Smtp-Source: ABdhPJwSy8djRzattquH/FjML2gk62PklGKieE8AHEPIh5I6VIm/LdLDkYCYpQ99B8eNnnr/FZ2mRA==
X-Received: by 2002:a7b:c4d9:: with SMTP id g25mr6072703wmk.15.1600861781360;
        Wed, 23 Sep 2020 04:49:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:c43a:de91:4527:c1ba? (p200300ea8f235700c43ade914527c1ba.dip0.t-ipconnect.de. [2003:ea:8f23:5700:c43a:de91:4527:c1ba])
        by smtp.googlemail.com with ESMTPSA id i14sm241690wml.24.2020.09.23.04.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 04:49:40 -0700 (PDT)
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3d9176a6-c93e-481c-5877-786f5e6aaef8@gmail.com>
Date:   Wed, 23 Sep 2020 13:49:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <7bfebfdc0d7345c4612124ff00e20eebb0ff6cd9.camel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.09.2020 19:58, Saeed Mahameed wrote:
> On Tue, 2020-09-01 at 17:02 +0200, Geert Uytterhoeven wrote:
>> This reverts commit 124eee3f6955f7aa19b9e6ff5c9b6d37cb3d1e2c.
>>
>> Inami-san reported that this commit breaks bridge support in a Xen
>> environment, and that reverting it fixes this.
>>
>> During system resume, bridge ports are no longer enabled, as that
>> relies
>> on the receipt of the NETDEV_CHANGE notification.  This notification
>> is
>> not sent, as netdev_state_change() is no longer called.
>>
>> Note that the condition this commit intended to fix never existed
>> upstream, as the patch triggering it and referenced in the commit was
>> never applied upstream.  Hence I can confirm s2ram on r8a73a4/ape6evm
>> and sh73a0/kzm9g works fine before/after this revert.
>>
>> Reported-by Gaku Inami <gaku.inami.xh@renesas.com>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> ---
>>  net/core/link_watch.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/core/link_watch.c b/net/core/link_watch.c
>> index 75431ca9300fb9c4..c24574493ecf95e6 100644
>> --- a/net/core/link_watch.c
>> +++ b/net/core/link_watch.c
>> @@ -158,7 +158,7 @@ static void linkwatch_do_dev(struct net_device
>> *dev)
>>  	clear_bit(__LINK_STATE_LINKWATCH_PENDING, &dev->state);
>>  
>>  	rfc2863_policy(dev);
>> -	if (dev->flags & IFF_UP && netif_device_present(dev)) {
>> +	if (dev->flags & IFF_UP) {
> 
> So with your issue the devices is both IFF_UP and !present ? how so ?
> I think you should look into that.
> 
> I am ok with removing the "dev present" check from here just because we
> shouldn't  be expecting IFF_UP && !present .. such thing must be a bug
> somewhere else.
> 
>>  		if (netif_carrier_ok(dev))
>>  			dev_activate(dev);
>>  		else
> 


In __dev_close_many() we call ndo_stop() whilst IFF_UP is still set.
ndo_stop() may detach the device and bring down the PHY, resulting in an
async link change event that calls dev_get_stats(). The latter call may
have a problem if the device is detached. In a first place I'd consider
such a case a network driver bug (ndo_get_stats/64 should check for
device presence if depending on it).
The additional check in linkwatch_do_dev() was meant to protect from such
driver issues.
