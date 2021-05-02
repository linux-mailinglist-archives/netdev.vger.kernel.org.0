Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1500370AC3
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 10:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhEBIBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 04:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbhEBIBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 04:01:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 924BF613C1;
        Sun,  2 May 2021 08:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619942425;
        bh=FvPNNQmHx/5ViY0BlcSbkGWkBsE1eFh33r5eB7qN3rM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T70XiNqVzzpbmhxjlA916/n3aUMVJUiaKVPZeDqzi/csFdSpCvfMpUvGwNjv/967n
         Co6TvacrsVYdbccPn0xsH978JaUK5JmWzimXAwkrdUHnRKh335BzEEAaLkWOv2xdgT
         R5VQmBdCkuyn0kTt0ggX+Tv7qLkO79Bt8mxEA/SMqsvZlZOOgEtzlAcgJEv0P0w0f7
         h6i4Os6uiWMo1UERyrZ7VZztAXN9M4gR7/ICcp0DEdwvN/2PkRsqNr4HouT8Z68Tuh
         eTFdGw+22gLt1kKfCez3v9G1eVzYKjT4UKe/878GkqBR0EzD5q/z3axlKoaOFuDTca
         utTbNHVqOg/bw==
Date:   Sun, 2 May 2021 11:00:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        Chris Snook <chris.snook@gmail.com>
Subject: Re: [PATCH] net: atheros: nic-devel@qualcomm.com is dead
Message-ID: <YI5cFTvqmiRsvtCm@unreal>
References: <20210430141142.28d49433b7a0.Ibcb12b70ce4d7d1c3a7a3b69200e1eea5f59e842@changeid>
 <20210430103454.0e35269f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430103454.0e35269f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 10:34:54AM -0700, Jakub Kicinski wrote:
> On Fri, 30 Apr 2021 14:11:42 +0200 Johannes Berg wrote:
> > Remove it from the MODULE_AUTHOR statements referencing it.
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> FWIW I subscribe to the belief that corporations can't be authors,
> so I'd personally opt to remove these MODULE_AUTHOR()s completely.
> They serve no purpose, strange legal aberrations aside, corporations
> are not persons and not being sentient can't take pride in their work. 

+1, this cargo cult should die.

Thanks
