Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEBB2F5B74
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbhANHki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbhANHkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:40:37 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7E2C061794
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:39:51 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id l9so1039600ejx.3
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y17ECDOYvMNRRXcj/IFM5SVopzb9oJ0c3wuU5BxRpx4=;
        b=imQ/A3FcifZ5o4f5d1AsGfIIfKINzDVT7HmS2lstIcFv5RSchbuH5chJyeeAmZ8sjl
         zna00hOyXVKpIoqVasrCbGrjo6D+d1k3/pUv4YD5GcdkGWM9q/4ap9XOvj99oP6hEq/r
         z9FGTAwE+QtlqmnCPk1+tpAKlAhV3MfOWxU/ogWnnZ56Aa/H5nsLl5II77mwKhb2LRFE
         7QP7NMz8m5IIoYIr9AQEBFXiDAMUmoHX/sCSGIjEQC9xBO2sQl1QfCObQv9Yq5gKBiaC
         1kiHa5V9IVU7uJTfGGdayDnlsi5tdAPlqSqxWOeV4YlW7miy0ntudRPnTA/TZjUwSNOh
         C+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y17ECDOYvMNRRXcj/IFM5SVopzb9oJ0c3wuU5BxRpx4=;
        b=PjtlNuDD/p/YK0FWUJ+aT1k6tuPjSNHR3YNEFv0k4DtJ00cpoq9wG1oVimdHutC1Uk
         S2/SqL5UOKCOJbV1dOz0lC6SC53ArzYC5HvCgbn6J4z6df+es2ID4YEFI5NepSC0d+eg
         6ojFsLWZcSVyrxi6KlCOwQ9R2xOB1FwajVZrOT4hryMpAudQ4w85px5Atx5GrAPo+G3U
         O3Lcvo1pgM9/NkH9Ly7/JFJTfIrWjaBNOx4UoayeJNpCBVmbxigZd4j8zcmY6FPi2cHU
         LlDgJt3YHlJ/IHg82JPjfKUwZNG90OZuRa6TixV0Gn1M3M85hSCJoqvL40X97JRvUqUo
         5ufA==
X-Gm-Message-State: AOAM531IufbU3OyTYCdBKbKg7ZSDGY9dQVhKrizWXfYC4rhGwBr9ocJY
        dkq9Qyxg8q0MnPkSteRtt2gBeg==
X-Google-Smtp-Source: ABdhPJxRuv5NYobxhwmywgO79WjklMfv0P5q3q9dDLXgs4b+H8z9LFlKItXFWboty53NkWGcR41P0g==
X-Received: by 2002:a17:907:20a4:: with SMTP id pw4mr4216778ejb.499.1610609989838;
        Wed, 13 Jan 2021 23:39:49 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id bm25sm1830300edb.73.2021.01.13.23.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 23:39:49 -0800 (PST)
Date:   Thu, 14 Jan 2021 08:39:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210114073948.GJ3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/+nVtRrC2lconET@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 14, 2021 at 03:07:18AM CET, andrew@lunn.ch wrote:
>> $ devlink lc provision netdevsim/netdevsim10 lc 0 type card4ports
>> $ devlink lc
>> netdevsim/netdevsim10:
>>   lc 0 state provisioned type card4ports
>>     supported_types:
>>        card1port card2ports card4ports
>>   lc 1 state unprovisioned
>>     supported_types:
>>        card1port card2ports card4ports
>
>Hi Jiri
>
>> # Now activate the line card using debugfs. That emulates plug-in event
>> # on real hardware:
>> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
>> $ ip link show eni10nl0p1
>> 165: eni10nl0p1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
>> # The carrier is UP now.
>
>What is missing from the devlink lc view is what line card is actually
>in the slot. Say if i provision for a card4port, but actually insert a
>card2port. It would be nice to have something like:
>
> $ devlink lc
> netdevsim/netdevsim10:
>   lc 0 state provisioned type card4ports
>     supported_types:
>        card1port card2ports card4ports
>     inserted_type:
>        card2ports;
>   lc 1 state unprovisioned
>     supported_types:
>        card1port card2ports card4ports
>     inserted_type:
>        None

I see. Yes, that might be doable. I'm noting this down.


>
>I assume if i prevision for card4ports but actually install a
>card2ports, all the interfaces stay down?

Yes, the card won't get activated in case or provision mismatch.


>
>Maybe
>
>> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
>
>should actually be
>    echo "card2ports" > /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
>
>so you can emulate somebody putting the wrong card in the slot?

Got you.

Thanks!

>
>    Andrew
