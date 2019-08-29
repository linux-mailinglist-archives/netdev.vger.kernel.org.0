Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D23A1C41
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 16:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbfH2OCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 10:02:43 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37848 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfH2OCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 10:02:42 -0400
Received: by mail-wm1-f65.google.com with SMTP id d16so4007690wme.2
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 07:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qrBpEGRf7/rGsZ16n9Vo/n95RvgOFzVSzsma/Sa+edE=;
        b=NLOHGFa3+ZPTl40JrnAahrodQCgZtDlhqxXvi+3++WpnQeBXit0u9KhUR8iW4xf0YE
         3shSj73Hu7GfvJwWVSCwSyotNHTvjHu/wTiiFwtDRUi6kW+pI+zUgqAWylw8KPpmzxwR
         qVLeCAmR/IqKLG0p622Kp1tTOHz4JW4tyiArPPrpNdHAvlzekjAqjO4pEthgx3tlWm8l
         uUGm+itGmkihNBClZ8ruYpO4cvtOjE0lLBhkrw2P3nlov9/z9O4QwN8RyJyLkuoc+H1l
         ZCEtlbMEGKfTUvY38KUwcpxGkod8z6KITfLg4h1ikjfvPHfnSLu5gJS5cso+WG4x2Gqs
         B4Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qrBpEGRf7/rGsZ16n9Vo/n95RvgOFzVSzsma/Sa+edE=;
        b=eFOmnLTUKyqSjNftipGxeIDAEZXaLbe0PhxfhIHaToTbNFKJgjly8PD1NUA4oTS5o9
         3XQYgZCOKFpn2x1NjdsxVFILgh8yUvxRWtbVgu2SDvUMOJXxs45rjp9vOoqEBROZnTK/
         XKJOjMft3r9jrwLCP+PZFcuO6PgGan+i5/MbE0guP4r8hSbFiF4sL4OaiIyfkKlsriju
         3/evqotIHzEcyx+WXrYkvIO0dwzH/zlbkTpjQLAxCoY30BPGb59YzyTkFBGqrOg9nPj/
         EEHPWNFPdLVE93WjYy1OV4YHIC4qtv/recvCH5Z/gMW309/zr8iiI8Hujos4ZQkJ9244
         FGEA==
X-Gm-Message-State: APjAAAX2W8GL5Mt1BHK8seerFo04PEi/H+H2/uhXGKQ4sb8B0T+uJqjt
        NxweQN0MubSg2Lke37yXvJ2zIQ==
X-Google-Smtp-Source: APXvYqw9izHHo9zFBzEGq1asn/te+8oYttrgm0JwQYWACt216WRY3+SSdV/lhWAnwEYakLbiVK+yFA==
X-Received: by 2002:a7b:cbcf:: with SMTP id n15mr11982505wmi.48.1567087361171;
        Thu, 29 Aug 2019 07:02:41 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id r6sm2928879wmf.0.2019.08.29.07.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 07:02:40 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:02:39 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
Message-ID: <20190829140239.GK2312@nanopsycho>
References: <20190806191517.8713-1-dsahern@kernel.org>
 <20190828103718.GF2312@nanopsycho>
 <2c561928-1052-4c33-848d-ed7b81e920cf@gmail.com>
 <20190829062850.GG2312@nanopsycho>
 <87432763-769b-be25-6e5c-a15f8ebfd654@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87432763-769b-be25-6e5c-a15f8ebfd654@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 29, 2019 at 02:54:39PM CEST, dsahern@gmail.com wrote:
>On 8/29/19 12:28 AM, Jiri Pirko wrote:
>> Wed, Aug 28, 2019 at 11:26:03PM CEST, dsahern@gmail.com wrote:
>>> On 8/28/19 4:37 AM, Jiri Pirko wrote:
>>>> Tue, Aug 06, 2019 at 09:15:17PM CEST, dsahern@kernel.org wrote:
>>>>> From: David Ahern <dsahern@gmail.com>
>>>>>
>>>>> Prior to the commit in the fixes tag, the resource controller in netdevsim
>>>>> tracked fib entries and rules per network namespace. Restore that behavior.
>>>>
>>>> David, please help me understand. If the counters are per-device, not
>>>> per-netns, they are both the same. If we have device (devlink instance)
>>>> is in a netns and take only things happening in this netns into account,
>>>> it should count exactly the same amount of fib entries, doesn't it?
>>>
>>> if you are only changing where the counters are stored - net_generic vs
>>> devlink private - then yes, they should be equivalent.
>> 
>> Okay.
>> 
>>>
>>>>
>>>> I re-thinked the devlink netns patchset and currently I'm going in
>>>> slightly different direction. I'm having netns as an attribute of
>>>> devlink reload. So all the port netdevices and everything gets
>>>> re-instantiated into new netns. Works fine with mlxsw. There we also
>>>> re-register the fib notifier.
>>>>
>>>> I think that this can work for your usecase in netdevsim too:
>>>> 1) devlink instance is registering a fib notifier to track all fib
>>>>    entries in a namespace it belongs to. The counters are per-device -
>>>>    counting fib entries in a namespace the device is in.
>>>> 2) another devlink instance can do the same tracking in the same
>>>>    namespace. No problem, it's a separate counter, but the numbers are
>>>>    the same. One can set different limits to different devlink
>>>>    instances, but you can have only one. That is the bahaviour you have
>>>>    now.
>>>> 3) on devlink reload, netdevsim re-instantiates ports and re-registers
>>>>    fib notifier
>>>> 4) on devlink reload with netns change, all should be fine as the
>>>>    re-registered fib nofitier replays the entries. The ports are
>>>>    re-instatiated in new netns.
>>>>
>>>> This way, we would get consistent behaviour between netdevsim and real
>>>> devices (mlxsw), correct devlink-netns implementation (you also
>>>> suggested to move ports to the namespace). Everyone should be happy.
>>>>
>>>> What do you think?
>>>>
>>>
>>> Right now, registering the fib notifier walks all namespaces. That is
>>> not a scalable solution. Are you changing that to replay only a given
>>> netns? Are you changing the notifiers to be per-namespace?
>> 
>> Eventually, that seems like good idea. Currently I want to do
>> if (net==nsim_dev->mynet)
>> 	done
>> check at the beginning of the notifier.
>> 
>
>The per-namespace replay should be done as part of this re-work. It
>should not be that big of a change. Add 'struct net' arg to
>register_fib_notifier. If set, call fib_net_dump only for that
>namespace. The seq check should be made per-namespace.
>
>You mentioned mlxsw works fine with moving ports to a new network
>namespace, so that will be a 'real' example with a known scalability
>problem that should be addressed now.

Fair enough. Will include this now.

Thanks!
