Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1B717D0C2
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 01:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCHAwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 19:52:14 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42963 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgCHAwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 19:52:14 -0500
Received: by mail-qt1-f193.google.com with SMTP id r6so4562467qtt.9
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 16:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tBAJTB+QQyFklXC2hcIupA7kPP8px1zjy8Uy0IHVv/E=;
        b=HTr5OvAt/bKQheeWqoJgYFd3n045e2/0WqAmcma3RClKDIlRK/lV7b0IZ4k9ou0k1L
         WXMCyL70MeztkjchRVwfRzi58i31SqHUgUJnxixNQO/0xN6fcZUVVm2uiYG9U2M8I+M/
         uLeuR3xg0Ye3v6Tgxxs+hwmzwQbRKU2JQGCZidq5aP9TYVXkohhXZTPVXkZorRx9RaLA
         G7qwEBRjhO7nq4huTLfmctwH6UHM8QeCihw1MeML17ngW31Yvkvwid0UJALG9cYS2f97
         9chVHi0Ury97G8K3sVaWkt6jJCK4T3ll0oiy5mJcl4wTqPpcHl61gtxkOqGFZQz8zDZ0
         0xPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tBAJTB+QQyFklXC2hcIupA7kPP8px1zjy8Uy0IHVv/E=;
        b=Cr6PCzEMtnbztzmLjutTgvPNnizWhpdEHyg77NYaH1I55x94rY3OIlt2fej7enutgk
         17aOmsJvua9cDM4RSWTJF+jF+BlNvgVjTDXJ+aeFrwb7HRpyB4DmLOG9GFQzZGYcVUsZ
         KELjOTq1siG3150cwCmEt1Kw5KPOb7sesvAyPDuO8JB2V5dQjFSt8fD1X0Wx+ot5ZzHM
         VzesqW9Ao1007OOm3AUmEiuMUiX4+MdVAb3majqVLhQsM+8lfp8+Onz4nqh4aggQHFAh
         vMK3FuD18DdbXKsi5FGA6j26oiU8N0pqZLT6quosHx4c04aHDD318Fitx+SMRFHAWw3j
         p5FQ==
X-Gm-Message-State: ANhLgQ3F/BqAJKbN1vMH3xW4tthuJxjPwUfofsqJ3bVix/R9RDAwGDHZ
        qD9iaxu2/96aHMTgq30N6aeZlMZi
X-Google-Smtp-Source: ADFU+vvVXxriPT/Gu9tdTf/04WgbYUZy29mEOO8tLgsUGODHtlnQP9ZMoguqVygSw6b6H34f4zMgcQ==
X-Received: by 2002:ac8:7695:: with SMTP id g21mr9035517qtr.152.1583628733111;
        Sat, 07 Mar 2020 16:52:13 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:54d7:a956:162c:3e8? ([2601:282:803:7700:54d7:a956:162c:3e8])
        by smtp.googlemail.com with ESMTPSA id y10sm412055qtf.77.2020.03.07.16.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Mar 2020 16:52:12 -0800 (PST)
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
To:     Alarig Le Lay <alarig@swordarmor.fr>, netdev@vger.kernel.org,
        jack@basilfillan.uk, Vincent Bernat <bernat@debian.org>
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
Date:   Sat, 7 Mar 2020 17:52:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/20 1:17 AM, Alarig Le Lay wrote:
> Hi,
> 
> On the bird users ML, we discussed a bug we’re facing when having a
> full table: from time to time all the IPv6 traffic is dropped (and all
> neighbors are invalidated), after a while it comes back again, then wait
> a few minutes and it’s dropped again, and so on.

Kernel version?

you are monitoring neighbor states with 'ip monitor' or something else?


> 
> Basil Fillan determined that it comes from the commit
> 3b6761d18bc11f2af2a6fc494e9026d39593f22c.
> 


...

> We've also experienced this after upgrading a few routers to Debian Buster.
> With a kernel bisect we found that a bug was introduced in the following
> commit:
> 
> 3b6761d18bc11f2af2a6fc494e9026d39593f22c
> 
> This bug was still present in master as of a few weeks ago.
> 
> It appears entries are added to the IPv6 route cache which aren't visible from
> "ip -6 route show cache", but are causing the route cache garbage collection
> system to trigger extremely often (every packet?) once it exceeds the value of
> net.ipv6.route.max_size. Our original symptom was extreme forwarding jitter
> caused within the ip6_dst_gc function (identified by some spelunking with
> systemtap & perf) worsening as the size of the cache increased. This was due
> to our max_size sysctl inadvertently being set to 1 million. Reducing this
> value to the default 4096 broke IPv6 forwarding entirely on our test system
> under affected kernels. Our documentation had this sysctl marked as the
> maximum number of IPv6 routes, so it looks like the use changed at some point.
> 
> We've rolled our routers back to kernel 4.9 (with the sysctl set to 4096) for
> now, which fixed our immediate issue.
> 
> You can reproduce this by adding more than 4096 (default value of the sysctl)
> routes to the kernel and running "ip route get" for each of them. Once the
> route cache is filled, the error "RTNETLINK answers: Network is unreachable"
> will be received for each subsequent "ip route get" incantation, and v6
> connectivity will be interrupted.
> 

The above does not reproduce for me on 5.6 or 4.19, and I would have
been really surprised if it had, so I have to question the git bisect
result.

There is no limit on fib entries, and the number of FIB entries has no
impact on the sysctl in question, net.ipv6.route.max_size. That sysctl
limits the number of dst_entry instances. When the threshold is exceeded
(and the gc_thesh for ipv6 defaults to 1024), each new alloc attempts to
free one via gc. There are many legitimate reasons for why 4k entries
have been created - mtu exceptions, redirects, per-cpu caching, vrfs, ...

In 4.9 FIB entries are created as an rt6_info which is a v6 wrapper
around dst_entry. That changed in 4.15 or 4.16 - I forget which now, and
the commit you reference above is part of the refactoring to make IPv6
more like IPv4 with a different, smaller data structure for fib entries.
A lot of other changes have also gone into IPv6 between 4.9 and top of
tree, and at this point the whole gc thing can probably go away for v6
like it was removed for ipv4.

Try the 5.4 LTS and see if you still hit a problem.
