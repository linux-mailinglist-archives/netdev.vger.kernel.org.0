Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5C82A1AE8
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 23:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgJaWFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 18:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgJaWFx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 18:05:53 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 266042072C;
        Sat, 31 Oct 2020 22:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604181953;
        bh=TwBG2MZkiIBLGkJRwldTwe8SJBYtE0F5tqr59nx5Bpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V1Q9w5TvVuGYi4TgBWTdbefQQ03/wra7zwtEVee2DZxDxu9khiBu0h5lr4VSPpZJ7
         4odh/BaCCJFmZ2dWRl0K7RNpX7rpSV/e89hgjREKVf+r6xpJCFLzEyV4lTbzPxMlCi
         DntQNwUago1NEK2+fvQh6eOwl34dhHUtQsmaZuh4=
Date:   Sat, 31 Oct 2020 15:05:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep.lkml@gmail.com
Cc:     davem@davemloft.net, sgoutham@marvell.com, netdev@vger.kernel.org,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [v2 net-next PATCH 00/10] Support for OcteonTx2 98xx silcion
Message-ID: <20201031150552.006e2c93@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
References: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 10:45:39 +0530 sundeep.lkml@gmail.com wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> OcteonTx2 series of silicons have multiple variants, the
> 98xx variant has two network interface controllers (NIX blocks)
> each of which supports upto 100Gbps. Similarly 98xx supports
> two crypto blocks (CPT) to double the crypto performance.
> The current RVU drivers support a single NIX and
> CPT blocks, this patchset adds support for multiple
> blocks of same type to be active at the same time.
> 
> Also the number of serdes controllers (CGX) have increased
> from three to five on 98xx. Each of the CGX block supports
> upto 4 physical interfaces depending on the serdes mode ie
> upto 20 physical interfaces. At a time each CGX block can
> be mapped to a single NIX. The HW configuration to map CGX
> and NIX blocks is done by firmware.
> 
> NPC has two new interfaces added NIX1_RX and NIX1_TX
> similar to NIX0 interfaces. Also MCAM entries is increased
> from 4k to 16k. To support the 16k entries extended set
> is added in hardware which are at completely different
> register offsets. Fortunately new constant registers
> can be read to figure out the extended set is present
> or not.

Applied, thanks!
