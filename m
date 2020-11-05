Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25AB2A866B
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731867AbgKESuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgKESuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:50:16 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DCCC0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:50:15 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id z1so1205024plo.12
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=bPKYCL8xU14/g6oZU6y9vkVdCvoG1XfVBiWdvRGOkwo=;
        b=zWqJmsYYvOmArSyJL52SgNHgeE2IyCgh2y7c6GUhb2foVVe/nUJX2OyNFTE+8FYuCQ
         2eeLkvBuhVi5QPnw4Ve8h7kGM4hknvFcfdn+rlODeEmsnEJOkDco8Sw2XpaiStf1G6OL
         HDbic26GKd8T3YbFy5l7cjy1Ztrf4kMw9J0e2/OGsrDGhcvq7nSEgAywcURE8I9bPVSI
         FiwI5MhA/cLBxG6vXhMr1cQdIn16DsVaEH5LqK4qALCSK8oTxpXUj5E9JnEisAsWHn2t
         f/4uKE30OVrBmbuZCrk0XEevKue/7DQiYkSzVFHcRErBFpCTDXJMy3skJG5dfedEIrUi
         lesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bPKYCL8xU14/g6oZU6y9vkVdCvoG1XfVBiWdvRGOkwo=;
        b=rltM4eVS9D2W2bD8f5Jrtjho7njC4dkoMCnhMDBw+iyFyoSUWHELMli+R9iRmVX7/g
         0qsxYK+ySkcI4161/2Z+aW0VXY4XPv0FiqjMs1CiSbNUjcWYDhVQ6Vli2gGWn9evy/rq
         iwHqnztdubRAmCfVFkuY7dM9qBNbVsMGy6k7GSMDz9l9gozxxmxLGFFpM8g9hf0yFfOy
         W/YfXMmVImdaocMnp1qv7Liq0Mwu0DD0qnJiCVF7YUcgDjFWzuclwWjo5oPbbVYR+eb6
         ZYajfDP3Yfu4K/MoXF52aTkQqT+c/yPu9MDrizWHtNSqmrfz+udKb030D5xGJ0YBXkNz
         +t8w==
X-Gm-Message-State: AOAM5307SFjApIc3Kb7QRNqjWCGs/PAU93rTEGQ25iMnkJNHQz1co6G9
        akgD9YLAcFZT+ikdmWfKLBfPFQ==
X-Google-Smtp-Source: ABdhPJwF0koPG7cQetuK/DZgXYYwaitUK1Q7zSWegK4gBXeoVL8cyZeU2uLMWxkRH5AZNbWRhitvAA==
X-Received: by 2002:a17:902:b492:b029:d4:d88c:d1a7 with SMTP id y18-20020a170902b492b02900d4d88cd1a7mr3496352plr.15.1604602214934;
        Thu, 05 Nov 2020 10:50:14 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id w13sm3334631pfd.49.2020.11.05.10.50.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 10:50:14 -0800 (PST)
Subject: Re: [PATCH net-next 6/6] ionic: useful names for booleans
To:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
References: <20201104223354.63856-1-snelson@pensando.io>
 <20201104223354.63856-7-snelson@pensando.io>
 <fd2d2c3ec2fd7a34c9c74098d85da9f06f47821f.camel@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <7163f799-d728-8672-9487-d69aa62754ae@pensando.io>
Date:   Thu, 5 Nov 2020 10:50:13 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <fd2d2c3ec2fd7a34c9c74098d85da9f06f47821f.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/20 5:21 PM, Saeed Mahameed wrote:
> On Wed, 2020-11-04 at 14:33 -0800, Shannon Nelson wrote:
>> With a few more uses of true and false in function calls, we
>> need to give them some useful names so we can tell from the
>> calling point what we're doing.
>>
> Aha! The root cause of the issue is passing booleans to functions in
> first place, it is usually a bad idea that could lead to complication
> and overloading the design for no reason, please see my suggestion in
> the previous patch maybe you can apply the same approach on some of the
> booleans below.

Yes, this is similar to what I was commenting on when I responded to the 
in_interrupt() patches.  However, when the code around Add and Delete is 
identicle and called from multiple places, it is handy to put it in one 
place with a boolean so as to not have multiple instances to maintain.  
Yes, it's a tradeoff, and these #defines are meant to help ease the 
readability.

The v2 for patch 5/6 in this patchset might help this a little, I'll see 
what I can do.

Thanks for you time in looking through these patches.

Cheers,
sln


>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic_lif.c | 16 ++++++++-------
>> -
>>   drivers/net/ethernet/pensando/ionic/ionic_lif.h |  8 ++++++++
>>   2 files changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index a58bb572b23b..a0d2989a0d8d 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -1074,22 +1074,22 @@ static int ionic_lif_addr(struct ionic_lif
>> *lif, const u8 *addr, bool add,
>>   
>>   static int ionic_addr_add(struct net_device *netdev, const u8 *addr)
>>   {
>> -	return ionic_lif_addr(netdev_priv(netdev), addr, true, true);
>> +	return ionic_lif_addr(netdev_priv(netdev), addr, ADD_ADDR,
>> CAN_SLEEP);
>>   }
>>   
>>   static int ionic_ndo_addr_add(struct net_device *netdev, const u8
>> *addr)
>>   {
>> -	return ionic_lif_addr(netdev_priv(netdev), addr, true, false);
>> +	return ionic_lif_addr(netdev_priv(netdev), addr, ADD_ADDR,
>> CAN_NOT_SLEEP);
>>   }
>>   
>>   static int ionic_addr_del(struct net_device *netdev, const u8 *addr)
>>   {
>> -	return ionic_lif_addr(netdev_priv(netdev), addr, false, true);
>> +	return ionic_lif_addr(netdev_priv(netdev), addr, DEL_ADDR,
>> CAN_SLEEP);
>>   }
>>   
>>   static int ionic_ndo_addr_del(struct net_device *netdev, const u8
>> *addr)
>>   {
>> -	return ionic_lif_addr(netdev_priv(netdev), addr, false, false);
>> +	return ionic_lif_addr(netdev_priv(netdev), addr, DEL_ADDR,
>> CAN_NOT_SLEEP);
>>   }
>>   
>>   static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int
>> rx_mode)
>> @@ -1214,7 +1214,7 @@ static void ionic_set_rx_mode(struct net_device
>> *netdev, bool from_ndo)
>>   
>>   static void ionic_ndo_set_rx_mode(struct net_device *netdev)
>>   {
>> -	ionic_set_rx_mode(netdev, true);
>> +	ionic_set_rx_mode(netdev, FROM_NDO);
>>   }
>>   
>>   static __le64 ionic_netdev_features_to_nic(netdev_features_t
>> features)
>> @@ -1805,7 +1805,7 @@ static int ionic_txrx_init(struct ionic_lif
>> *lif)
>>   	if (lif->netdev->features & NETIF_F_RXHASH)
>>   		ionic_lif_rss_init(lif);
>>   
>> -	ionic_set_rx_mode(lif->netdev, false);
>> +	ionic_set_rx_mode(lif->netdev, NOT_FROM_NDO);
>>   
>>   	return 0;
>>   
>> @@ -2813,7 +2813,7 @@ static int ionic_station_set(struct ionic_lif
>> *lif)
>>   		 */
>>   		if (!ether_addr_equal(ctx.comp.lif_getattr.mac,
>>   				      netdev->dev_addr))
>> -			ionic_lif_addr(lif, netdev->dev_addr, true,
>> true);
>> +			ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR,
>> CAN_SLEEP);
>>   	} else {
>>   		/* Update the netdev mac with the device's mac */
>>   		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev-
>>> addr_len);
>> @@ -2830,7 +2830,7 @@ static int ionic_station_set(struct ionic_lif
>> *lif)
>>   
>>   	netdev_dbg(lif->netdev, "adding station MAC addr %pM\n",
>>   		   netdev->dev_addr);
>> -	ionic_lif_addr(lif, netdev->dev_addr, true, true);
>> +	ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR, CAN_SLEEP);
>>   
>>   	return 0;
>>   }
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
>> b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
>> index 0224dfd24b8a..493de679b498 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
>> @@ -13,6 +13,14 @@
>>   
>>   #define IONIC_MAX_NUM_NAPI_CNTR		(NAPI_POLL_WEIGHT + 1)
>>   #define IONIC_MAX_NUM_SG_CNTR		(IONIC_TX_MAX_SG_ELEMS
>> + 1)
>> +
>> +#define ADD_ADDR	true
>> +#define DEL_ADDR	false
>> +#define CAN_SLEEP	true
>> +#define CAN_NOT_SLEEP	false
>> +#define FROM_NDO	true
>> +#define NOT_FROM_NDO	false
>> +
>>   #define IONIC_RX_COPYBREAK_DEFAULT	256
>>   #define IONIC_TX_BUDGET_DEFAULT		256
>>   

