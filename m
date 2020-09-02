Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F0A25A24B
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 02:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIBAeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 20:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgIBAeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 20:34:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AEC5206F0;
        Wed,  2 Sep 2020 00:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599006852;
        bh=BJCwtehX6z9w2UvcPOxbidGKqFuMHUbubKLJ9kSOoAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZYRYF9ED4jKcw1R55JLXOSgmMDw/kSf72WQ+JfT9HKv/O4sRw3pdolJXwf8QLUB1T
         cvGytp3+/1e66cHu4NIfAmJYpOugVZGFxsxibx8PrtHj3T9n2zDVHh26v4IatPjnrv
         6coG0qutacX507cVfxIavz0HCtRB4R42Q5VJyydo=
Date:   Tue, 1 Sep 2020 17:34:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v2 4/9] gve: Add support for dma_mask register
Message-ID: <20200901173410.5ce6a087@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200901215149.2685117-5-awogbemila@google.com>
References: <20200901215149.2685117-1-awogbemila@google.com>
        <20200901215149.2685117-5-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Sep 2020 14:51:44 -0700 David Awogbemila wrote:
> From: Catherine Sullivan <csully@google.com>
> 
> Add the dma_mask register and read it to set the dma_masks.
> gve_alloc_page will alloc_page with:
>  GFP_DMA if priv->dma_mask is 24,
>  GFP_DMA32 if priv->dma_mask is 32.

What about Andrew's request to CC someone who can review this for
correctness?

What's your use case here? Do you really have devices with 24bit
addressing?
