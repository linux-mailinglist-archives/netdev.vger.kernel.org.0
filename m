Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC58C423F8B
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 15:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237884AbhJFNmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230023AbhJFNmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 09:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F36D86112D;
        Wed,  6 Oct 2021 13:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633527628;
        bh=OvBOGaOailrQNKiicS6cbvIk75k4YdFQP3tmaqToGhk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WFi82ZTkk1IxgHBxBxLbPT0UJ2vSz2TUm6OG0rS73v7exd2P3NjByyspez6zog1mg
         pB5iOlOp6eu19AOkOuL29mXZDKsqF0xgivZ2mik8kcV3hlo03Nnga3kFX6cUs9MGa0
         /1fsu9U81bA7Pk+K++oV0tuGP68m/WEj0SmDl5ySiGQ6AhNIyCkIjiG4ZvjQe6jk28
         Pi7HbJS7/ZReIF8k+3lrr8NjmaHryTL76fz4JrLc6h+Iki4uN9aDhdaZ9ITFxMEidT
         hVANVZLu98vlIBodNXV4xzjl3BtLlv+k5nHekN+Z2ybArbuniZezJCdRMewBPfAGVo
         ZDAMzCYPbH04w==
Date:   Wed, 6 Oct 2021 06:40:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: Re: [net-next PATCH 2/3] octeontx2-pf: Add devlink param to vary
 cqe size
Message-ID: <20211006064027.66a22a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALHRZupNJC7EJAir+0iN6p4UGR0oU0by=N2Hf+zWaj2U8RrE4A@mail.gmail.com>
References: <1633454136-14679-1-git-send-email-sbhatta@marvell.com>
        <1633454136-14679-3-git-send-email-sbhatta@marvell.com>
        <20211005181157.6af1e3e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZupNJC7EJAir+0iN6p4UGR0oU0by=N2Hf+zWaj2U8RrE4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 12:29:51 +0530 sundeep subbaraya wrote:
> We do use ethtool -G for setting the number of receive buffers to
> allocate from the kernel and give those pointers to hardware memory pool(NPA).

You can extend the ethtool API.
