Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1334E2FBC57
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 17:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732388AbhASQYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 11:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731925AbhASQYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 11:24:05 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79593C061573
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 08:23:22 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id q25so21713806oij.10
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 08:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G55tkmNFXpWNF0G4kidv1LOhDwnRGHoYTqEZ1cY0Eqc=;
        b=DhVfwyqBmc1AiBf/wD+FyjYytp4BUTH2VLlJDLkVixp3J7211eK/m6O3ZTfa3exXwP
         prd3LWNj+mMSuxBVcYW4efmtcROLtTVuNAsEap/+SKMNSVBgjDX2qwlE86snW/oKz5PI
         d0n3qZoQNbYNTIh7DNl7LxzqoELOTTGtWzJL/TFPf0DLGCaDeLYHtyaXe3xSZIIMet+S
         h+NMMmcouT2HEZ5bq+V9iHLm+GZJxoVPizWltgrAZ3rAKPl1CZzq3rBiObHQwBr92wrD
         +Ka0oEa2eHkhczqna9Ah90DzkRcta2og987gRp+s7ZiWdUX4axh3aw2qozOfHC9UNOY6
         TomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G55tkmNFXpWNF0G4kidv1LOhDwnRGHoYTqEZ1cY0Eqc=;
        b=bNSxudKdhmJUhrFHybiar//zg0SxMxEHKpx8s+O/nS4g1aqo3ORkTNhtuxlv5s1S1/
         gYXv7OhEuN7Uum4ykPhYAaASraF3tROJDSL9+lIcgV5WbMF6tU9XhhkSqx1a4Y+aw+LL
         9Us2x9n01myzNRE//laLH0m2kRbpUEdJD16NhWGJbsBeu54MR8PDPuRBU3UIfG4X0GUD
         ZbvaAI8lMIpxwLzMqxZwwZJ8g0pE8KJ4B2bBOXqF33mV4G1MQvBh/td88hw34TLcw0jE
         nI24+Jndyb+R8EypOTu2UWLXg2kqw2NYpLkj1QY9G3FeBbKJsGnpYJFh9dpE33E1+4ix
         WMEQ==
X-Gm-Message-State: AOAM530WqYMKPEJxf+dk2lKPna8K72PgF7x4Gy7GtzwgErL8ARA6Wcwc
        eKM4J7WU52rwSCYgjCrrN3E=
X-Google-Smtp-Source: ABdhPJw5hSD6Jz5T7k5je3VWnZ52lO+9wjAbRth7x79j5z5tMR6ohe2URim2HMvnLJGrcWEJ3sBnlA==
X-Received: by 2002:aca:1a17:: with SMTP id a23mr294686oia.120.1611073401961;
        Tue, 19 Jan 2021 08:23:21 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.213])
        by smtp.googlemail.com with ESMTPSA id q6sm852300ota.44.2021.01.19.08.23.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 08:23:21 -0800 (PST)
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
To:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch> <20210119115610.GZ3565223@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <42b4c13b-7605-948e-a68c-dcb568680988@gmail.com>
Date:   Tue, 19 Jan 2021 09:23:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119115610.GZ3565223@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/21 4:56 AM, Jiri Pirko wrote:
> Thu, Jan 14, 2021 at 03:07:18AM CET, andrew@lunn.ch wrote:
>>> $ devlink lc provision netdevsim/netdevsim10 lc 0 type card4ports
>>> $ devlink lc
>>> netdevsim/netdevsim10:
>>>   lc 0 state provisioned type card4ports
>>>     supported_types:
>>>        card1port card2ports card4ports
>>>   lc 1 state unprovisioned
>>>     supported_types:
>>>        card1port card2ports card4ports
>>
>> Hi Jiri
>>
>>> # Now activate the line card using debugfs. That emulates plug-in event
>>> # on real hardware:
>>> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
>>> $ ip link show eni10nl0p1
>>> 165: eni10nl0p1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>>>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
>>> # The carrier is UP now.
>>
>> What is missing from the devlink lc view is what line card is actually
>> in the slot. Say if i provision for a card4port, but actually insert a
>> card2port. It would be nice to have something like:
> 
> I checked, our hw does not support that. Only provides info that
> linecard activation was/wasn't successful.
> 

There is no way for the supervisor / management card to probe and see
what card is actually inserted in a given slot? That seems like a
serious design deficiency. What about some agent running on the line
card talking to an agent on the supervisor to provide that information?
