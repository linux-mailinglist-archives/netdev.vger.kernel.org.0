Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F26244D7D8
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbhKKOLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:11:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233454AbhKKOLS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 09:11:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F47D610D2;
        Thu, 11 Nov 2021 14:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636639709;
        bh=8SciwiBUurX7UBj/r+pnfhqMxdpUkkt+kyMGNbLrCiQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UXekuvzagVx7pAhqOAcQ1QxZVO8v+YnCvzCigI6ZusOQmPMew/uJrVtvIzMmExewQ
         W+dlaHawVKk9eh3/TkG1ukuDbc/rV2dnfwKqrDXLmKAT37GDYiruil2ERMV9d5Hh4O
         adGYMSkw+HE45K/C9kKyQV6bZrhpVDfG7gyrMt6g/0SwEpUgDVSmWfZB9yZeyNew77
         U+X9517iN8h/JeMzPvFsbLQU+QbS+ZOWwDw5MbzdIeRdp/5jlfBGTY3ObgRNJPMWrh
         zbZi3gVTHKTvjbYOqMoo4BCOJ1Kg8hkPhSLQTFAP2COQqSL0igcze+mfxcP6SvoVmc
         /pLsiDU7/VoiQ==
Date:   Thu, 11 Nov 2021 06:08:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: snmp: tracepoint support for snmp
Message-ID: <20211111060827.5906a2f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211111133530.2156478-1-imagedong@tencent.com>
References: <20211111133530.2156478-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 21:35:28 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> snmp is the network package statistics module in kernel, and it is
> useful in network issue diagnosis, such as packet drop.
> 
> However, it is hard to get the detail information about the packet.
> For example, we can know that there is something wrong with the
> checksum of udp packet though 'InCsumErrors' of UDP protocol in
> /proc/net/snmp, but we can't figure out the ip and port of the packet
> that this error is happening on.
> 
> Add tracepoint for snmp. Therefor, users can use some tools (such as
> eBPF) to get the information of the exceptional packet.
> 
> In the first patch, the frame of snmp-tracepoint is created. And in
> the second patch, tracepoint for udp-snmp is introduced.

I feel like I have seen this idea before. Is this your first posting?

Would you mind including links to previous discussion if you're aware
of any?

Regardless:


# Form letter - net-next is closed

We have already sent the networking pull request for 5.16
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.16-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
