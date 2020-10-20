Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82A2293260
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389470AbgJTAgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389441AbgJTAgg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 20:36:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 489302242C;
        Tue, 20 Oct 2020 00:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603154195;
        bh=jq/u7h99KoaQMSz59H5LmVaxbG751C0Nlkv/jdx65BQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=w9B0/9D9bie9wqWfdtCkz/Uv6ZqW0Yehh6u71LocnjL0AXq6P7Qz0iw0nYQldNGjx
         rMwBa2gXoBiBtsaJ8A1WXKmEKbgGqnwrUP5QDqMWoy5YLu91Q5Fm650M6n81TtbDVY
         sJOC+JhIpfljo++f0uzJ5mfdsNOGtqFw+M4E+WPs=
Date:   Mon, 19 Oct 2020 17:36:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: tag_ksz: KSZ8795 and KSZ9477 also use
 tail tags
Message-ID: <20201019173633.5af4ab24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016172449.nvfflbbkrdbzukwz@skbuf>
References: <20201016171603.10587-1-ceggers@arri.de>
        <20201016172449.nvfflbbkrdbzukwz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 20:24:49 +0300 Vladimir Oltean wrote:
> On Fri, Oct 16, 2020 at 07:16:03PM +0200, Christian Eggers wrote:
> > I added it manually because the commit ID is not from Linus' tree. Is there any
> > value using Fixes tags with id's from other trees?  
> 
> Yes, that's what "git merge" does, it keeps sha1sums.
> You should check out "git log --oneline --graph --decorate" some time.
> Every maintainer's history is linear, and so is Linus's.

One thing to add is that we never rebase net or net-next trees
(some maintainers would do that occasionally).

Applied, thanks everyone!
