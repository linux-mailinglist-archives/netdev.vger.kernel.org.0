Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74EAA27EF2D
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731071AbgI3Q3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3Q3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:29:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FAD02072E;
        Wed, 30 Sep 2020 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601483346;
        bh=Q2kohbBNZJFGKlgYy3iFR2ADyWAxgpSN8JBM5/gMXaM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R/Dj8wDZZPrCgDcYThNTkr78lQsxgIKlrACFifq9ToZ+Z3/AQZkph5tPuHGu5H3ns
         Z9KAn9lI3aHwUkp1GfNmRUkxC2NS/Hb6Y4JC8j25N5CN8Wqy5wNJA0UQcgJkTTjTXY
         nJ1YxiHzYWWEfhEVJpwpkV6hUiABX11Oudi9HCn0=
Date:   Wed, 30 Sep 2020 09:29:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Fabian Frederick <fabf@skynet.be>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] Revert "vxlan: move encapsulation warning"
Message-ID: <20200930092904.394d7cda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <121207656.52132.1601482805664@webmail.appsuite.proximus.be>
References: <20200926015604.3363358-1-kuba@kernel.org>
        <121207656.52132.1601482805664@webmail.appsuite.proximus.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 18:20:05 +0200 (CEST) Fabian Frederick wrote:
> Thanks a lot for explanations Jakub. udp_tunnel_nic.sh is a nice
> tool. Maybe it could also be used for remcsum testing ? I'd like to
> check net-next commit 2ae2904b5bac "vxlan: don't collect metadata if
> remote checksum is wrong" to make sure it has no impact as I had no
> ACK. Problem is ip encap-remcsum requires 'remote' specification not
> compatible with 'group' and only featuring in 'new_geneve' function
> in your script.
> 
> If both vxlan_parse_gbp_hdr() and vxlan_remcsum() require metadata
> recovery, I can reverse that patch and add some comment in vxlan_rcv()

I think it's better if you create a separate script for that.

udp_tunnel_nic is supposed to be testing the NIC driver interface.
