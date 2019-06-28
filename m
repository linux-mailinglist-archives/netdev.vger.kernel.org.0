Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A744659AEC
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfF1MZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:25:30 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:43381 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbfF1MZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 08:25:29 -0400
Received: by mail-wr1-f52.google.com with SMTP id p13so6068970wru.10
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 05:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yIBZ+9JwWP2Adda8DkwYgy0Z9MpMMAJohaJE2DGlt48=;
        b=k7oecDyWX+oedJUDu08IgySvK/KMDWkE1FBfEpEL930qHb8zfDFbymVXCrguh3dso1
         WofLwcMwdy3g82ySkmpVFK5lbVMUp7932me0fQ8WqJI04T8KObvQ1sm8UlV8xQIIOpiO
         FLN0KA+wrkDh8HE4lnJyyn2OVa4nIsMD6rAdwFpBNFmSTJiC1GwFEX7hwzQVYvTW1Exz
         hjRNPaxd70dn4tAYkPqKtRe7cP7R5FzueyNt+aQyngYqYGSWmJbGZUJYXV4726HKGtIq
         jxultS+OhMHzPUeu4/4TlP98wDi2iDK8qqGHP15+HEI3ldo7t1MJyE+in+jkVRSsR+hd
         MkOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yIBZ+9JwWP2Adda8DkwYgy0Z9MpMMAJohaJE2DGlt48=;
        b=ujiRT+8C0fmrS2aDXg7UdYWSwZEAAsYxMKw0Bhsw0U2hF0dcFNQo/MvSGXZvlWgMDB
         PGI+VvZTvkbEG2NXs2ieMZ9jsbHN6nc7Ecf12NNPe6GqRPRmquMsDN2Ru3GEY/93/SyP
         iQj2ZGc6/od39Ksajd+Vkl8jfXmmvSXHkE9pqVan7yEgO9MPbepJ9ng232O7NJD/Y68R
         WH0+G+4Y5n+/Yga2flwXhekY2egPb/nYRmCADxyhVeNqwYMNJVNLL0/3eL4NwJxINSh/
         Og1AdHyQFivh2iI1Tv2aYhDqhe6Ut1lwBcMiJ92A2+sCbCENbv4D6MXecVZ74t+LiKDs
         XfCw==
X-Gm-Message-State: APjAAAVIs4tuWGiGS6cCiNYR9guFpHCKajFOOqXziScl/kNhyqCuk9Wl
        RyaQ/+FPUyDpqOBGrAZDExyifg==
X-Google-Smtp-Source: APXvYqytrxO6kLfpnbqNOyK3auJiD5TDSr7CG7I0EQjyl8zKCkT3wQD6o5f1yqvFa6i+9IBoGqJ8Og==
X-Received: by 2002:adf:f649:: with SMTP id x9mr7125725wrp.86.1561724727580;
        Fri, 28 Jun 2019 05:25:27 -0700 (PDT)
Received: from localhost (ip-89-176-222-26.net.upcbroadband.cz. [89.176.222.26])
        by smtp.gmail.com with ESMTPSA id h8sm2007171wmf.12.2019.06.28.05.25.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 05:25:27 -0700 (PDT)
Date:   Fri, 28 Jun 2019 14:25:26 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Lunn <andrew@lunn.ch>, David Ahern <dsahern@gmail.com>,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190628122526.GA2304@nanopsycho>
References: <20190627094327.GF2424@nanopsycho>
 <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
 <20190627180803.GJ27240@unicorn.suse.cz>
 <20190627112305.7e05e210@hermes.lan>
 <20190627183538.GI31189@lunn.ch>
 <20190627183948.GK27240@unicorn.suse.cz>
 <20190627122041.18c46daf@hermes.lan>
 <20190628111216.GA2568@nanopsycho>
 <20190628114212.GE29149@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628114212.GE29149@unicorn.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jun 28, 2019 at 01:42:12PM CEST, mkubecek@suse.cz wrote:
>On Fri, Jun 28, 2019 at 01:12:16PM +0200, Jiri Pirko wrote:
>> 
>> I think that it is desired for kernel to work with "real alias" as a
>> handle. Userspace could either pass ifindex, IFLA_NAME or "real alias".
>> Userspace mapping like you did here might be perhaps okay for iproute2,
>> but I think that we need something and easy to use for all.
>> 
>> Let's call it "altname". Get would return:
>> 
>> IFLA_NAME  eth0
>> IFLA_ALT_NAME_LIST
>>    IFLA_ALT_NAME  eth0
>>    IFLA_ALT_NAME  somethingelse
>>    IFLA_ALT_NAME  somenamethatisreallylong
>> 
>> then userspace would pass with a request (get/set/del):
>> IFLA_ALT_NAME eth0/somethingelse/somenamethatisreallylong
>> or
>> IFLA_NAME eth0 if it is talking with older kernel
>> 
>> Then following would do exactly the same:
>> ip link set eth0 addr 11:22:33:44:55:66
>> ip link set somethingelse addr 11:22:33:44:55:66
>> ip link set somenamethatisreallylong addr 11:22:33:44:55:66
>
>Yes, this sounds nice.
>
>> We would have to figure out the iproute2 iface to add/del altnames:
>> ip link add eth0 altname somethingelse
>> ip link del eth0 altname somethingelse
>>   this might be also:
>>   ip link del somethingelse altname somethingelse
>
>This would be a bit confusing, IMHO, as so far
>
>  ip link add $name ...
>
>always means we want to add or delete new device $name which would not
>be the case here. How about the other way around:
>
>  ip link add somethingelse altname_for eth0
>
>(preferrably with a better keyword than "altname_for" :-) ). Or maybe
>
>  ip altname add somethingelse dev eth0
>  ip altname del somethingelse dev eth0

Yeah, I like this.

Let's see how it will work during the implementation.

