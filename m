Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63802E217B
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgLWUfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:35:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45099 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728824AbgLWUfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 15:35:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608755643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OGTIr6a89HgqbH7yTRjoe+GO8SUBG8fEbsZOo6NPZe4=;
        b=UK22Bbb6WxFFJ2bTePNoUuCcezffrjWBmpRA9yVvu4HUMTzoSlqoaXDKWHLsBbvFO1CVMR
        mx3oyBhonQTE6T4ORdzapqcaT+97pSbidWEruYoS9lWdlJ1PuFnWej4QO/pBlv24sVlePE
        kWrUrT1LGnaLhVfKOkvoDuua2WgHOoQ=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-f0QXIDZBMPGsQ9-exTV2qQ-1; Wed, 23 Dec 2020 15:34:00 -0500
X-MC-Unique: f0QXIDZBMPGsQ9-exTV2qQ-1
Received: by mail-ot1-f71.google.com with SMTP id v15so109821otp.10
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 12:34:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=OGTIr6a89HgqbH7yTRjoe+GO8SUBG8fEbsZOo6NPZe4=;
        b=Y9wJX08S1UqDCL6pS7ea05TajufX/hwtxaMWOhM7QLOtlj6SSjslsJwMGmujn5KzUl
         tsG+s31k7W8tKkopbo3qYB1lC9e5p5CZRbDpkX4KBbOezO/eKaZMYE4Guj1hkieB5T94
         W3wKKwdXzaHJJeNByNP3USewQirWtuIwRLZqch3QHIJOGJDnUGbQ77bF768UOSitd1iG
         T6UQl2H+WQuf1J/IuVOKfWevNdkG2GDG5AsfQ8mv6WSLO4EXUPzr1EZHASWagy72jgbs
         hSmYQ5PYbMnI6qGiuvBV51UvkTPvXBSTPkyV+P5EK8gbZSSefo3u2NtUecw9meE1+aJo
         Ewcg==
X-Gm-Message-State: AOAM531eBWy1d1tcCacFSCfCsuuSZSoPAVW0lYDoD6RXH31DQjQhFWdj
        W8OZNu1gD09E5kAapRqUaFObOIOc5uvoBm1F4nsh40fCUcVbzC+8GM6UNOCbucJmi/ZleMeBQct
        rTmsS5PXUaNOx1gVO
X-Received: by 2002:a4a:c503:: with SMTP id i3mr18716555ooq.6.1608755639509;
        Wed, 23 Dec 2020 12:33:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJztzzfuO6HS1xto1fsgsDfbSz1aW7zP99Tr8269WBaPCFtrQ4oY+gCF7HuJrdOsZ5o4XkjCBA==
X-Received: by 2002:a4a:c503:: with SMTP id i3mr18716549ooq.6.1608755639308;
        Wed, 23 Dec 2020 12:33:59 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id r204sm6128940oif.0.2020.12.23.12.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 12:33:58 -0800 (PST)
Subject: Re: [PATCH] amd-xgbe: remove h from printk format specifier
To:     Joe Perches <joe@perches.com>, thomas.lendacky@amd.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201223194345.125205-1-trix@redhat.com>
 <46b3bba25d09e89471048ae119a2c3b460b6b7be.camel@perches.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <d1257604-c462-8fbc-612e-41ec2f552ff8@redhat.com>
Date:   Wed, 23 Dec 2020 12:33:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <46b3bba25d09e89471048ae119a2c3b460b6b7be.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/23/20 12:14 PM, Joe Perches wrote:
> On Wed, 2020-12-23 at 11:43 -0800, trix@redhat.com wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> This change fixes the checkpatch warning described in this commit
>> commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary %h[xudi] and %hh[xudi]")
>>
>> Standard integer promotion is already done and %hx and %hhx is useless
>> so do not encourage the use of %hh[xudi] or %h[xudi].
> Why only xgbe-ethtool?
>
> Perhaps your script only converts direct uses of functions
> marked with __printf and not any uses of the same functions
> via macros.

The fixer may have issues.

A works as designed by not desired is it only fixes what it compiles and if a

macro is #if-def away then it will not do the fix.  This is troublesome for the

the *_debug() routines.  So I am rejecting files with partial fixes.

It is also likely I missed adding __printf attributes.

There will be enough changes for this pass through to count as my feat of strength for today.

Tom

> $ git grep -P '%[\w\d\.]*h\w' drivers/net/ethernet/amd/xgbe/
> drivers/net/ethernet/amd/xgbe/xgbe-dcb.c:                         "TC%u: tx_bw=%hhu, rx_bw=%hhu, tsa=%hhu\n", i,
> drivers/net/ethernet/amd/xgbe/xgbe-dcb.c:               netif_dbg(pdata, drv, netdev, "PRIO%u: TC=%hhu\n", i,
> drivers/net/ethernet/amd/xgbe/xgbe-dcb.c:                                 "unsupported TSA algorithm (%hhu)\n",
> drivers/net/ethernet/amd/xgbe/xgbe-dcb.c:                 "cap=%hhu, en=%#hhx, mbc=%hhu, delay=%hhu\n",
> drivers/net/ethernet/amd/xgbe/xgbe-dev.c:       netif_dbg(pdata, drv, pdata->netdev, "VXLAN tunnel id set to %hx\n",
> drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c:           netdev_err(netdev, "invalid phy address %hhu\n",
> drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c:           netdev_err(netdev, "unsupported autoneg %hhu\n",
> drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c:                   netdev_err(netdev, "unsupported duplex %hhu\n",
>
>> Signed-off-by: Tom Rix <trix@redhat.com>
>> ---
>>  drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
>> index 61f39a0e04f9..3c18f26bf2a5 100644
>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
>> @@ -339,14 +339,14 @@ static int xgbe_set_link_ksettings(struct net_device *netdev,
>>  	speed = cmd->base.speed;
>>  
>>
>>  	if (cmd->base.phy_address != pdata->phy.address) {
>> -		netdev_err(netdev, "invalid phy address %hhu\n",
>> +		netdev_err(netdev, "invalid phy address %u\n",
>>  			   cmd->base.phy_address);
>>  		return -EINVAL;
>>  	}
>>  
>>
>>  	if ((cmd->base.autoneg != AUTONEG_ENABLE) &&
>>  	    (cmd->base.autoneg != AUTONEG_DISABLE)) {
>> -		netdev_err(netdev, "unsupported autoneg %hhu\n",
>> +		netdev_err(netdev, "unsupported autoneg %u\n",
>>  			   cmd->base.autoneg);
>>  		return -EINVAL;
>>  	}
>> @@ -358,7 +358,7 @@ static int xgbe_set_link_ksettings(struct net_device *netdev,
>>  		}
>>  
>>
>>  		if (cmd->base.duplex != DUPLEX_FULL) {
>> -			netdev_err(netdev, "unsupported duplex %hhu\n",
>> +			netdev_err(netdev, "unsupported duplex %u\n",
>>  				   cmd->base.duplex);
>>  			return -EINVAL;
>>  		}
>

