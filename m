Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC842E145F
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730721AbgLWCip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:38:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730115AbgLWCin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:38:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58CE72245C;
        Wed, 23 Dec 2020 02:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608691082;
        bh=aDwJGnKtC5b+/IhpLBbDVnB03LBgSAU4U6/zGDqihoY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c2+RnXuYXJy0qyj0d6ajKFyiB4IyWrrYH5wGApxtEFESZ1YNFveJslWiUN2/S7KeG
         bB/fjo3eG4MD7u1t4xQslNTfBQiXM63XAF15S+qe2ZQ4y169r5VNX5KXA+Jeol3NYN
         QmViRpKk7HSDR3u1gZaRj5QcBXa2nr2oofD8kFGxqEBgrhLQ88I9U6AS7lzjTxzzS5
         lmAw7I5YOTJojBruphP5xlgqJh6nj4wuP+NiSL+1lhBBe73mbtsEFaHS52y2GIIUdr
         WaHNM6pec7h2h9BQ4+kJObVC9U6y8Jiufue6lX7+/lO8Wsbz7jQK3NKOW/gX+ezd/W
         8PXIO6d1qGZ8A==
Date:   Tue, 22 Dec 2020 18:38:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 03/38] staging: wimax: depends on NET
Message-ID: <20201222183801.327b964f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201223022516.2794471-3-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
        <20201223022516.2794471-3-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Dec 2020 21:24:41 -0500 Sasha Levin wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> [ Upstream commit 9364a2cf567187c0a075942c22d1f434c758de5d ]
> 
> Fix build errors when CONFIG_NET is not enabled. E.g. (trimmed):

This one can be dropped, before wimax moved to staging the dependency
was met thru the directory structure.
