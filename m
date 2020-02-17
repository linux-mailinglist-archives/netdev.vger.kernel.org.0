Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD805160BBF
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 08:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgBQHjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 02:39:45 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36509 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726558AbgBQHjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 02:39:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CF9AF21F18;
        Mon, 17 Feb 2020 02:39:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 17 Feb 2020 02:39:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gwCsj+
        1nqTOy3NhgDPOyq7Nn79sX4J52tVBrquvqCvE=; b=h3mrlA0Dv8V8sgwhJxN71D
        9HcIzaZ25ltHaybESs2I24C/Em9znGMtmbTZNRy0fTlBRHHo+ybMW0IWQlm7QJAP
        SClDj3cJkAV3Zv8+CEqgNGdTOL5qQvF/nqYatPClzUpewRm5jn+9oLWNKW/dPGtN
        YqAwmFBGY7GuS6pEUBLj9q5qXp0w176NsEWD1yOrg21I4jLxGOu4slQ3X8EpE6w/
        bgBnEdkCv2vuOQWbfVb7lnBLbGSoeJ79uZqrAdNS2ti/ba51PrGcJkObcSFTS2Lk
        F0Y1ANwmG/jqZdmUoLLhQ6HaGWbh1+wjiMm9sxonxJDxJxBLZSvhqVLhqddDuO9Q
        ==
X-ME-Sender: <xms:P0NKXigrKUn0tLCwwXWAONTuo0iysl-Zo2H2F0rcIVOrF3-jX8fQRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeehgdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrghinh
    epkhgvrhhnvghlrdhorhhgnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesih
    guohhstghhrdhorhhg
X-ME-Proxy: <xmx:P0NKXtX22i4-GfVdatx0Fglh_ZQVikIBXWq8l0AZS_z1DSIBsC94YA>
    <xmx:P0NKXhln7TGPjV-iSDsikv407nVX_K0mcf3-4eX1fv0ljMP3HcVL8g>
    <xmx:P0NKXqCQcRllEtYJmierCodsJJrFQIGSMM_ClsC-coToaMsYS75qeA>
    <xmx:P0NKXq8UkHjG6m8r9UQlABxhYiaG2VlH0HrVupxcEW8tMAC6FnYW5w>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 271CC3280062;
        Mon, 17 Feb 2020 02:39:43 -0500 (EST)
Date:   Mon, 17 Feb 2020 09:39:41 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Stephen Hemminger <stephen@networkplumber.org>, dsahern@gmail.com,
        rm+bko@romanrm.net
Cc:     netdev@vger.kernel.org
Subject: Re: Fw: [Bug 206523] New: Can no longer add routes while the link is
 down, RTNETLINK answers: Network is down
Message-ID: <20200217073941.GA289986@splinter>
References: <20200216094307.55a66c52@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200216094307.55a66c52@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 09:43:07AM -0800, Stephen Hemminger wrote:
> 
> 
> Begin forwarded message:
> 
> Date: Thu, 13 Feb 2020 18:04:40 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 206523] New: Can no longer add routes while the link is down, RTNETLINK answers: Network is down
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=206523
> 
>             Bug ID: 206523
>            Summary: Can no longer add routes while the link is down,
>                     RTNETLINK answers: Network is down
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.4.19
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: rm+bko@romanrm.net
>         Regression: No
> 
> Hello,
> 
> I'm upgrading my machines from kernel 4.14 to the 5.4 series, and noticed quite
> a significant behavior change, so I was wondering if this was intentional or a
> side effect of something, or a bug. It already broke my network connectivity
> for a while and required troubleshooting, to figure out that a certain script
> that I had, used to set up all routes before, and only then putting the
> interface up.
> 
> On 4.14.170 this works:
> 
> # ip link add dummy100 type dummy
> # ip route add fd99::/128 dev dummy100
> # ip -6 route | grep dummy
> fd99:: dev dummy100 metric 1024 linkdown  pref medium
> #
> 
> On 5.4.19 however:
> 
> # ip link add dummy100 type dummy
> # ip route add fd99::/128 dev dummy100
> RTNETLINK answers: Network is down
> # ip -6 route | grep dummy
> #
> 
> Sorry for not narrowing it down more precisely between 4.14 and 5.4, but I'm
> sure for the right people this will be easily either an "oh shit" or "yeah,
> that", even without any more precise version information :)

Hi,

This was added over two years ago in commit 955ec4cb3b54 ("net/ipv6: Do
not allow route add with a device that is down"), kernel 4.16

With recent iproute2 you can get extended ack from the kernel:
# ip route add fd99::/128 dev dummy10
Error: Nexthop device is not up.

IMO, it's better to keep it consistent with IPv4. We can also add a
sysctl, but I would like to avoid it if possible.

Adding David in case he has other suggestions.
