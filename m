Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEE515F3A
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 10:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfEGIUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 04:20:12 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39042 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfEGIUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 04:20:12 -0400
Received: by mail-pf1-f195.google.com with SMTP id z26so8258026pfg.6
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 01:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4et2WhpsHXv6e9HfQL6DjEPM5EsR+0FaZExWLDbYzvw=;
        b=LSlYzuGp3imgX5KJrjrPMiGiPyvXifMC86oQqggBOmhWv4/rUgb5uThS/+D4wKvzXs
         UyzEHl+VaEeqEUry8G2r54vXuR39dzI9VXK+MVwhvJlLUA3H2Lckpelbf1AZ2uIHCpON
         pq8w1WfEoDIjCWI1XFXjmX8mrUpYhd/p/LPSL1FDjmS8ESY5dqviQORITkBkuxJkAFl/
         mcv7gBMv6fVfUMGzRhWM0xto7IVMj3UuXVLOVHoUO1zWK7MYi9vK06quF2T6XEqf9ope
         6S6fAHh0c+6GG89zcGHDIeGHBt0KbUOuYrEpU3x3CJf33eEbaQNbcYs5CLMYMyUmBolK
         eI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4et2WhpsHXv6e9HfQL6DjEPM5EsR+0FaZExWLDbYzvw=;
        b=ZgcHUOtjii0sUj/Zx+MwQoQwdgute8nxZuqopiHwdOlVKUVSLfkxPDwIfNQoptp1pk
         4RMboYs3QumceqCN4NDghjkAtSHzYlIQX0a5gmCZ1x0OKvZ4vsFHffV6j1z2bMrWcC5L
         zgsLGW6DwzcdDZfETPuvsXACKClYabBDmEjlSJzEAjNPKHfAWxllYr01bhmPBNaJh3Ia
         5I6UD0cnuPyssmJMwvsC9s2fjwYrVYgU3GKlZX73bM7XshtapdFn2/2HokY5oOcSmpYg
         /H+SXfvEA6I2WDJGB/64dYCtmOciTszZrETIfBXpNcWtOuGyfqIYm3jGICLQBZJ1eGsa
         ONoA==
X-Gm-Message-State: APjAAAU2ErzG/QUJNJ2NRTAVnCCRYvRb4dGYOgeVMoi9gzoLREITNvNR
        z3IeAe2h3hrbdAnRsxFYgxI=
X-Google-Smtp-Source: APXvYqy0UEY2TOn5Czu7GMUJ5lBLq0lMFg/OXjxC2YMp0UP5w9xh9kwsPr+oZ9umzacd7e3bUItJ/w==
X-Received: by 2002:a63:ee01:: with SMTP id e1mr37170931pgi.20.1557217211811;
        Tue, 07 May 2019 01:20:11 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t9sm13710647pgp.66.2019.05.07.01.20.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 01:20:10 -0700 (PDT)
Date:   Tue, 7 May 2019 16:20:01 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] selftests: fib_rule_tests: Fix icmp proto with ipv6
Message-ID: <20190507082001.GL18865@dhcp-12-139.nay.redhat.com>
References: <20190429173009.8396-1-dsahern@kernel.org>
 <20190430023740.GJ18865@dhcp-12-139.nay.redhat.com>
 <dac5b0ed-fa7e-1723-0067-6c607825ec31@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dac5b0ed-fa7e-1723-0067-6c607825ec31@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 12:00:46PM -0600, David Ahern wrote:
> On 4/29/19 8:37 PM, Hangbin Liu wrote:
> > An other issue is The IPv4 rule 'from iif' check test failed while IPv6
> > passed. I haven't found out the reason yet.
> > 
> > # ip -netns testns rule add from 192.51.100.3 iif dummy0 table 100
> > # ip -netns testns route get 192.51.100.2 from 192.51.100.3 iif dummy0
> > RTNETLINK answers: No route to host
> > 
> >     TEST: rule4 check: from 192.51.100.3 iif dummy0           [FAIL]
> > 
> > # ip -netns testns -6 rule add from 2001:db8:1::3 iif dummy0 table 100
> > # ip -netns testns -6 route get 2001:db8:1::2 from 2001:db8:1::3 iif dummy0
> > 2001:db8:1::2 via 2001:db8:1::2 dev dummy0 table 100 metric 1024 iif dummy0 pref medium
> > 
> >     TEST: rule6 check: from 2001:db8:1::3 iif dummy0          [ OK ]
> 
> use perf to look at the fib lookup parameters:
>   perf record -e fib:* -- ip -netns testns route get 192.51.100.2 from
> 192.51.100.3 iif dummy0
>   perf script

Hi David, Roopa,

From the perf record the result looks good.
fib_table_lookup could get correct route.

For IPv4:
ip  7155 [001]  8442.915515: fib:fib_table_lookup: table 255 oif 0 iif 2 proto 0 192.51.100.3/0 -> 192.51.100.2/0 tos 0 scope 0 flags 0 ==> dev - gw 0.0.0.0 src 0.0.0.0 err -11
ip  7155 [001]  8442.915517: fib:fib_table_lookup: table 100 oif 0 iif 2 proto 0 192.51.100.3/0 -> 192.51.100.2/0 tos 0 scope 0 flags 0 ==> dev dummy0 gw 192.51.100.2 src 198.51.100.1 err 0

For IPv6:
ip  6950 [000]   759.328850: fib6:fib6_table_lookup: table 255 oif 0 iif 2 proto 0 2001:db8:1::3/0 -> 2001:db8:1::2/0 tos 0 scope 0 flags 0 ==> dev lo gw :: err -113
ip  6950 [000]   759.328852: fib6:fib6_table_lookup: table 100 oif 0 iif 2 proto 0 2001:db8:1::3/0 -> 2001:db8:1::2/0 tos 0 scope 0 flags 0 ==> dev dummy0 gw 2001:db8:1::2 err 0


Then I tracked the code and found in function ip_route_input_slow(),
after fib_lookup(), we got res->type == RTN_UNICAST. So if we haven't
enabled forwarding, it will return -EHOSTUNREACH.

But even we enabled forwarding, we still need to disable rp_filter as the
source/dest address are in the same subnet. The ip_mkroute_input()
-> __mkroute_input() -> fib_validate_source() -> __fib_validate_source() will
return -EXDEV if we enabled rp_filter.

So do you think if we should enable forwarding and disble rp_filter before
test "from $SRC_IP iif $DEV" or just diable this test directly?

Thanks
Hangbin
