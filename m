Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E32A30186E
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbhAWUxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:53:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbhAWUxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 15:53:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE9DC22CA0;
        Sat, 23 Jan 2021 20:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611435142;
        bh=879HMQITkOOhgY0AwLQC/xU742SNiNTRIKQGUflXl1k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SyAXmYNcxiGldVjkkrAfjoc2LK+vMSSA3Wq/pfImnJpRV0hW9VxM9QUAeL6skBxjH
         jiryOo/eNTb1pRDR87BSOCCA6Hb6YbQOXXSuSUK4kZcA/XJPhcSG3GBiduSGN2B3NO
         sAddDhw1TEM/UuH6keKIbVr8HEyaAo3v10caYA5Oc4AXY8ow4hX3nw3CYRLnI1s9Xq
         zWBI9sswTDlYwxJDZZQpvJf5D07fV+n1YJR21HIJbZVjxEFuNy1cZrU9V8X9FA7wAo
         AJPCK0IcCHIT2MNQWMwGxsHyWtgee9vWgqXishBomUkxgvgpY51TL64jXG478yLlkl
         MoDsIyTztBZzQ==
Date:   Sat, 23 Jan 2021 12:52:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH net-next 1/4] mm: page_frag: Introduce
 page_frag_alloc_align()
Message-ID: <20210123125221.528cd9e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123115903.31302-2-haokexin@gmail.com>
References: <20210123115903.31302-1-haokexin@gmail.com>
        <20210123115903.31302-2-haokexin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jan 2021 19:59:00 +0800 Kevin Hao wrote:
> +void *page_frag_alloc(struct page_frag_cache *nc,
> +		      unsigned int fragsz, gfp_t gfp_mask)
> +{
> +	return page_frag_alloc_align(nc, fragsz, gfp_mask, 0);
> +}
>  EXPORT_SYMBOL(page_frag_alloc);

Isn't it better to make this a static inline now?

Either way you'll need to repost after net is merged into net-next
(probably ~this Friday), please mark the posting as RFC before that.
Please make sure you CC the author of the code.
