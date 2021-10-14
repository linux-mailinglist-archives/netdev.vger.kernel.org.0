Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231EB42DEEB
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhJNQL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229823AbhJNQL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 12:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4998F61056;
        Thu, 14 Oct 2021 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634227792;
        bh=pIpb8HNzZKqgxT+MxRieJbP+xzvRuhmzkrb7MV4cQK0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MeV4Iuw+20SkllR/ys9TdZxmJjSOPWSh0e6AtiTZwmNOjTSxB7SfcHa99usg5X2je
         t7wTeoqLqYbC0dUK5ajCul9uGfOWeS6U8N64tSVFxL7xGjov4BeH1BZyKDdQasDow1
         L4TmCRYSp1j3Ph4zo2fGVge7AaMfOZQZ1D93lvrpvRDTmPOvhs9GOMicnYktV6O5d1
         NNtzGO1xYr/cJ1U6KLKSVS5d5HzVbA+jrx2xBWmE0VtHKwucS4RSyvG9YEZcTry3/I
         C4OHYvNtvXPLy/foJmaGlI0iUd0XL691RceFur4rmLBxy3kH9m7ijRV5RiQdtPxhH7
         9PzY42r1I8+4w==
Date:   Thu, 14 Oct 2021 09:09:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH net-next 00/11] net/smc: introduce SMC-Rv2 support
Message-ID: <20211014090951.592e1d3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012101743.2282031-1-kgraul@linux.ibm.com>
References: <20211012101743.2282031-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 12:17:32 +0200 Karsten Graul wrote:
> Please apply the following patch series for smc to netdev's net-next tree.
> 
> SMC-Rv2 support (see https://www.ibm.com/support/pages/node/6326337)
> provides routable RoCE support for SMC-R, eliminating the current
> same-subnet restriction, by exploiting the UDP encapsulation feature
> of the RoCE adapter hardware.
> 
> Patch 1 ("net/smc: improved fix wait on already cleared link") is
> already applied on netdevs net tree but its changes are needed for
> this series on net-next. The patch is unchanged compared to the
> version on the net tree.

This series as marked as "Needs ACK" in patchwork, I think my Dave.
Maybe it is because of the RoCE part, is there a reason not to CC
linux-rdma on it?
