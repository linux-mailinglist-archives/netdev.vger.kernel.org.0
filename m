Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571D240EF26
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 04:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242675AbhIQCRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 22:17:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhIQCRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 22:17:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C36C26113E;
        Fri, 17 Sep 2021 02:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631844962;
        bh=nXVNUoIpyIhOvK44T9X6RXZK+HO80RuNBYsb6hRckzg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EAv0o/5DrtQklsTyY4KMWqSC3OdtqiDipB90Whq7GxeKqFPiGVjAahZ8ywXK+bhYV
         QkE/9CKmFoJXEk1sOFlnkfCp4JmIXEECvzLhaNUNGOJdLT6Y/7tdRANMmbwGrPrQq5
         mKwxqCbtdwN8iZHMU9Z24cbjxzK2O8w3JlAp13M8S32uGaHOnBxqetObVM6jv4GBHt
         HyOvitGxUMzCNQYgQuD1YagJj9dF36y8XKxY51AbVKjpZWAaG+Oh2D/qmwyClw8J7Q
         I88RqXoR/rZWAWB7+1lw3hMWOn017z7KM700tpwJNNUcpW83MIdUTYxLo/yHrYHF+N
         4d6crcGCNUbRg==
Date:   Thu, 16 Sep 2021 19:16:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toms Atteka <cpp.code.lv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4] net: openvswitch: IPv6: Add IPv6 extension
 header support
Message-ID: <20210916191601.76e63d5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210916191449.668dea06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210916204409.1453878-1-cpp.code.lv@gmail.com>
        <20210916191449.668dea06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 19:14:49 -0700 Jakub Kicinski wrote:
> On Thu, 16 Sep 2021 13:44:09 -0700 Toms Atteka wrote:
> > +/**
> > + * Parses packet and sets IPv6 extension header flags.
> > + *
> > + * skb          buffer where extension header data starts in packet
> > + * nh           ipv6 header
> > + * ext_hdrs     flags are stored here
> > + *
> > + * OFPIEH12_UNREP is set if more than one of a given IPv6 extension header
> > + * is unexpectedly encountered. (Two destination options headers may be
> > + * expected and would not cause this bit to be set.)
> > + *
> > + * OFPIEH12_UNSEQ is set if IPv6 extension headers were not in the order
> > + * preferred (but not required) by RFC 2460:
> > + *
> > + * When more than one extension header is used in the same packet, it is
> > + * recommended that those headers appear in the following order:
> > + *      IPv6 header
> > + *      Hop-by-Hop Options header
> > + *      Destination Options header
> > + *      Routing header
> > + *      Fragment header
> > + *      Authentication header
> > + *      Encapsulating Security Payload header
> > + *      Destination Options header
> > + *      upper-layer header
> > + */  
> 
> This is not a valid kdoc format, please read
> Documentation/doc-guide/kernel-doc.rst and double check for warnings
> with scripts/kernel-doc -none.

Also please make sure to CC appropriate maintainers on v5.
scripts/get_maintainers.pl is your friend there.
