Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B7942743B
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 01:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243833AbhJHXhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 19:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243802AbhJHXhS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 19:37:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E48F60F5E;
        Fri,  8 Oct 2021 23:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633736122;
        bh=R8aWBW3RoRI7Q191griAGtDNFzUIoe989+jNqJ3syK0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ezZGDDfAnI66L4lOqBvJsAJ3bwKXt157P/D38budzAsPUqXwClMCCS8QZ9oZpQFNW
         PLuPcy4Q5rsy4lqH2b7Zu8PXswCF2hCHhNESZ2bp8zfDLCiyj0RZkbJgLDdzkx+lIc
         mapI8H2ZDNWliDguvEr6Ppe1oEDn1m3v+rRo03AuP54BoHVpzI7XTM2g+zTj7fyqSS
         iwm5wxby68rG6Lm2kgZ43rjz0TuDpDeeM4xnIhX9UPYbUe+aoCdJ2NELXGKt+DrNEs
         uK+YLdpDyKG9pKGVCYX8geYIQG7XjaV69rxYXyt3rRNEcGJSdvXeSUQelr520EQ7Gy
         SO7L0AU0MPTBQ==
Date:   Fri, 8 Oct 2021 16:35:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH net-next 2/4] gen_stats: Add instead Set the value in
 __gnet_stats_copy_basic().
Message-ID: <20211008163520.48220154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211007175000.2334713-3-bigeasy@linutronix.de>
References: <20211007175000.2334713-1-bigeasy@linutronix.de>
        <20211007175000.2334713-3-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Oct 2021 19:49:58 +0200 Sebastian Andrzej Siewior wrote:
> +	__u64 bytes = 0;
> +	__u64 packets = 0;

u64 is fine, no need to perpetuate the over-use of the user space types.
