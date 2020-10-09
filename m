Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6235A289C1A
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 01:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgJIXYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 19:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgJIXXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 19:23:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BC0C2173E;
        Fri,  9 Oct 2020 23:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602285814;
        bh=vMY5K8zKP5WFbtwNx+fLrgs4+WQ9SISHUN/65Dh/+vI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h41Eewuzv7kFjtevgL9Dsc8+mrJfDJEQs1JCvsLs7SxJYglUS/7v7eu1ZH0w5em22
         uk9OF6yuo06PbtORBT959M/q2dCOLAXtlsKkayp5Oo+RAM9nZRmqm0LnaJ81eKDYIl
         hGpKmcZtdLfLBkzWWlfcKCfiJXuPa4OR7M/0CNqo=
Date:   Fri, 9 Oct 2020 16:23:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net] net:ipv6: Discard next-hop MTU less than minimum
 link MTU
Message-ID: <20201009162332.3bbdd556@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007125302.2833-1-geokohma@cisco.com>
References: <20201007125302.2833-1-geokohma@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 14:53:02 +0200 Georg Kohmann wrote:
> When a ICMPV6_PKT_TOOBIG report a next-hop MTU that is less than the IPv6
> minimum link MTU, the estimated path MTU is reduced to the minimum link
> MTU. This behaviour breaks TAHI IPv6 Core Conformance Test v6LC4.1.6:
> Packet Too Big Less than IPv6 MTU.
> 
> Referring to RFC 8201 section 4: "If a node receives a Packet Too Big
> message reporting a next-hop MTU that is less than the IPv6 minimum link
> MTU, it must discard it. A node must not reduce its estimate of the Path
> MTU below the IPv6 minimum link MTU on receipt of a Packet Too Big
> message."
> 
> Drop the path MTU update if reported MTU is less than the minimum link MTU.
> 
> Signed-off-by: Georg Kohmann <geokohma@cisco.com>

Applied, thank you!
