Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 578FB6EE29
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 09:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfGTHRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 03:17:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40140 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfGTHRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 03:17:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so34251857wrl.7
        for <netdev@vger.kernel.org>; Sat, 20 Jul 2019 00:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WCDo/saf4DoXXfbNI30WSiXapySlL4OsaoORhxrvV/I=;
        b=TYe4lNvFj/+ppuuRSCW5RBI6WqXBRmzrHfR3N1wOBYtkqGHuJ0jUnAJ5Xyskt+zvDc
         musZFGXCCkURwVX9usZTjyEvgrqh5p12HpttTbTRTNxc/7ox4SVgbAYgowOT+vixoa8I
         dhoPwqwV1E+0CnFfF6D+nLACUeuBFpPvPR3BMbvppgi0BSkRqk1Q43O7pFeCx7VFbHMQ
         K1I9+Hl2uAAtDk0ijUQoEV7EEixgpfYV4g4FgfFPqp+s/48LFT196cnjjKEB2gl8wwBB
         scETSD6Y7FIz3XySxHctFcszT3fIGp+TLGEcxb/IdCYBYa5mTlqt8k2QMDPR0jy24J3j
         CcUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WCDo/saf4DoXXfbNI30WSiXapySlL4OsaoORhxrvV/I=;
        b=PBttB3f7Eo3dWfycTNvuplh6l9XSoIcolwSQWNVVh502aB6Cm3lPAcWqAsdSOzUvX0
         OW9SC3YrF3gevX3SZgDiGb+Mq4ochO0RsQnG6jZaIQIBGw+O19CsmqzHjt7MELlMKmUZ
         i03pr4R4sltYk0Gnzwib219s0ZFEu8ScSYEgN0KJoq31rxrxhB7Osf3ivjft3JttCXkp
         T34VtZIkJ803xnLBHDTOk5CU7W2K2Y5QUcwFdrfgBGzJg/wb3hTtL9NZ9OikcZmekiTO
         4d4uIvRmVMPzFM/DaQYgpoXY0y8tF077ptjJdNyfqYIQIzBs+I9NqR4CsxqOzvjNAhzi
         8nWg==
X-Gm-Message-State: APjAAAUy987TgdDqzOvcGTmdy3xz1fXHsMNqiKHELIaxXLu6uykXLi8Z
        PlpxtgmV5W2oBPqB3Pha0gw=
X-Google-Smtp-Source: APXvYqxqjeqaGkYmD+vUOWOT2/+MmHFWkX3q0jhEYKtJj87nzG78mcFF9GfQBiNvXTZ6ZEwo5ieaFw==
X-Received: by 2002:adf:dfc4:: with SMTP id q4mr59568738wrn.54.1563607026336;
        Sat, 20 Jul 2019 00:17:06 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id w24sm26131365wmc.30.2019.07.20.00.17.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 20 Jul 2019 00:17:05 -0700 (PDT)
Date:   Sat, 20 Jul 2019 09:17:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 4/7] net: rtnetlink: put alternative names
 to getlink message
Message-ID: <20190720071705.GH2230@nanopsycho>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-5-jiri@resnulli.us>
 <20190719205914.3fc786f6@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719205914.3fc786f6@cakuba>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 20, 2019 at 05:59:14AM CEST, jakub.kicinski@netronome.com wrote:
>On Fri, 19 Jul 2019 13:00:26 +0200, Jiri Pirko wrote:
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> index 7a2010b16e10..f11a2367037d 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
>> @@ -980,6 +980,18 @@ static size_t rtnl_xdp_size(void)
>>  	return xdp_size;
>>  }
>>  
>> +static size_t rtnl_alt_ifname_list_size(const struct net_device *dev)
>> +{
>> +	struct netdev_name_node *name_node;
>> +	size_t size = nla_total_size(0);
>> +
>> +	if (list_empty(&dev->name_node->list))
>> +		return 0;
>
>Nit: it would make the intent a tiny bit clearer if 
>
>	size = nla_total_size(0);
>
>was after this early return.

Sure.


>
>> +	list_for_each_entry(name_node, &dev->name_node->list, list)
>> +		size += nla_total_size(ALTIFNAMSIZ);
>
>Since we have the structure I wonder if it would be worthwhile to store

Which structure?


>the exact size in it?
>
>> +	return size;
>> +}
>> +
