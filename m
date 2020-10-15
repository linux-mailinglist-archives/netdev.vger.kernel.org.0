Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B1528E978
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 02:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732151AbgJOAYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 20:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728617AbgJOAYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 20:24:17 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 058642223F;
        Thu, 15 Oct 2020 00:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602721457;
        bh=Xey4zQhBNv/J5a2JLBvAXKtB17xeVR+0afr6hb53bSI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U7x9AdzulI/LLzSNlxR3ffJAhM6+sl1z1+OuzEG3kiaQbvOmYkp5f1DZxU5G+z/o4
         cs/twMGM79t2vw3YUldgw3GlkqQVdH2+C1xIpyZ8yKWAU7XYgKHz46N6IKp8fs/g/U
         OnApSeCaRgmpFAraEuFCL0i2zzIKZHgy2a3Qx2qg=
Date:   Wed, 14 Oct 2020 17:24:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] l3mdev icmp error route lookup fixes
Message-ID: <20201014172415.4c7c1e2c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012145016.2023-1-mathieu.desnoyers@efficios.com>
References: <20201012145016.2023-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 10:50:13 -0400 Mathieu Desnoyers wrote:
> Here is a series of fixes for ipv4 and ipv6 which ensure the route
> lookup is performed on the right routing table in VRF configurations
> when sending TTL expired icmp errors (useful for traceroute).
> 
> It includes tests for both ipv4 and ipv6.
> 
> These fixes address specifically address the code paths involved in
> sending TTL expired icmp errors. As detailed in the individual commit
> messages, those fixes do not address similar icmp errors related to
> network namespaces and unreachable / fragmentation needed messages,
> which appear to use different code paths.

Applied, thank you!
