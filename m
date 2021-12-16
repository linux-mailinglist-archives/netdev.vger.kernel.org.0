Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64384476850
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 03:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbhLPCvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 21:51:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50366 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhLPCvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 21:51:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0303B82276
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 02:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68122C36AE0;
        Thu, 16 Dec 2021 02:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639623082;
        bh=7co+n7necqNTEN7qZ4Y2aV2akHFgUIikRgNLkSISbz0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=td/aFyTPu5Ekc/30dOd7EADyZKa+JZ06pO59B/iVTSHW4kVXteyzzzJcnG500ehn8
         7DhyJjcb4ib0GTw375DnCH0BxLYMK/0vq3TNjpzpbZFYs/4Ho/zEvPGYSHLyoJz/UL
         iD93zHjFFHoN03fNQi/k8aWTO6iICIWcilkVEbwQzmEALyCwqYgGYklnzBguW2Ploj
         uxdXcil1gTfKNkBbAoXBDs+XyiZTjAm5pt8iiMsI1dtsV8PEXVkLsjcqIlQdaMFajE
         OK3UWqG+/oQHy9gBFKP9sHDtCo82IIlTtxap3kwsoZ3MJawGm3s60GS4HAjd/dzLiz
         AaoRxZU/6kKWA==
Date:   Wed, 15 Dec 2021 18:51:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netdev@vger.kernel.org>, davem@davemloft.net, dsahern@kernel.org
Subject: Re: [PATCH v3 net-next 0/4] fib: merge nl policies
Message-ID: <20211215185121.1ffe768a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211215113242.8224-1-fw@strlen.de>
References: <20211215113242.8224-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 12:32:40 +0100 Florian Westphal wrote:
> v3: drop first two patches, otherwise unchanged.
> 
> This series merges the different (largely identical) nla policies.
> 
> v2 also squashed the ->suppress() implementation, I've dropped this.
> Problem is that it needs ugly ifdef'ry to avoid build breakage
> with CONFIG_INET=n || IPV6=n.
> 
> Given that even microbenchmark doesn't show any noticeable improvement
> when ->suppress is inlined (it uses INDIRECT_CALLABLE) i decided to toss
> the patch instead of adding more ifdefs.

Would you mind resending? Patchwork thinks the series is incomplete
because the cover letter says 0/4 instead of 0/2.
