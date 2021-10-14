Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5543742DF40
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhJNQiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232179AbhJNQiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 12:38:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 277E1603E5;
        Thu, 14 Oct 2021 16:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634229380;
        bh=/vlFPp7dcZKs9mxCpqoPog6reiJ1mYR1RV+fROkuzlI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=en7V1uqpMuhrp+E6PJWzqSr3NJcHlQMvMlXzmGHuvyl3Wk89GEawtf501VsHclgq0
         1oGVclmFsJ6LUjP/tokgPQwEBwv4PEprPEMUlgMBEtSxoMXX8q+7BFuncXtUnFb/ef
         d/7PcEUZAHWqynhBIRbyHqnfRVrDcRxe1fA2mqq/8NfGjD1l/i8FUL5nKgI1jUN4ZR
         loSjZA8E3OwkmbfnGcqHD26A1EM+mMVKNUKojVmGVeZ7ZFVEuYuKXsw+pHL35JJCzC
         dhSA1NcgiTOP0h2oIdVVu9WKzwuGTLdOeihRaurg/pokyqnNVzGIDF9bAxRUICrEem
         ipIbPKA/yqqKw==
Date:   Thu, 14 Oct 2021 09:36:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH net-next 00/11] net/smc: introduce SMC-Rv2 support
Message-ID: <20211014093619.6c8b63ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7d3e762e-12e9-bb5c-f242-785047087783@linux.ibm.com>
References: <20211012101743.2282031-1-kgraul@linux.ibm.com>
        <20211014090951.592e1d3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7d3e762e-12e9-bb5c-f242-785047087783@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 18:32:37 +0200 Karsten Graul wrote:
> On 14/10/2021 18:09, Jakub Kicinski wrote:
> > On Tue, 12 Oct 2021 12:17:32 +0200 Karsten Graul wrote:  
> >> Please apply the following patch series for smc to netdev's net-next tree.
> >>
> >> SMC-Rv2 support (see https://www.ibm.com/support/pages/node/6326337)
> >> provides routable RoCE support for SMC-R, eliminating the current
> >> same-subnet restriction, by exploiting the UDP encapsulation feature
> >> of the RoCE adapter hardware.
> >>
> >> Patch 1 ("net/smc: improved fix wait on already cleared link") is
> >> already applied on netdevs net tree but its changes are needed for
> >> this series on net-next. The patch is unchanged compared to the
> >> version on the net tree.  
> > 
> > This series as marked as "Needs ACK" in patchwork, I think my Dave.
> > Maybe it is because of the RoCE part, is there a reason not to CC
> > linux-rdma on it?  
> 
> There is no reason for that, I was not aware that I should CC linux-rdma.
> I can send a v2 with an extended CC list.

Yeah, let's do that. I'm not sure what the reason for the patchwork
designation was so let's repost with linux-rdma and if nobody complains
we can merge tomorrow morning. Thanks!
