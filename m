Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A192F0460
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 00:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbhAIXRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 18:17:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbhAIXRu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 18:17:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B906623998;
        Sat,  9 Jan 2021 23:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610234229;
        bh=kWYfWQJ02NtR+dF/89+ZF9nMdvoyKB0O84xQNShtkxE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YFAyEM1yG81TD1Gm5uPuqYpvpHBPOseHwCFbqiuIa2fdnOw1EXai2gVeLe6EDmL0D
         KlBzFmBgNTj/po+N1kkSiot9LNBzjHWSrbfR1OAqIhZRmFfbdSE0T3+QfeiYP0TI1t
         EMhpqaqaq0ZZQdi/tX0gi6O+WKsxJqgkSWebns5OZB7K714N5UPs/YSWzYmRt1HgIm
         iomOEZAYz7fjE3GtktBzokUJH/gH1ouo6h8dKALdtDqap9Z23ESHOmESRqPz1cC41E
         pm6ZaKiBukkCAqPoKarFJYbEX4C/DzhB8g8hFJlZ2G/h8QBrrn5Xb5BtWZwKL7BYk+
         3xwHK78gU1H/w==
Date:   Sat, 9 Jan 2021 15:17:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, schoen@loyalty.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 00/11] selftests: Updates to allow single instance of
 nettest for client and server
Message-ID: <20210109151708.09454f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9bb81496-25a8-42cf-0dee-1be4625a515e@gmail.com>
References: <20210109185358.34616-1-dsahern@kernel.org>
        <036b819f-57ad-972e-6728-b1ef87a31efe@gmail.com>
        <20210109110202.13d04aeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210109150440.33b7ffe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9bb81496-25a8-42cf-0dee-1be4625a515e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Jan 2021 16:12:22 -0700 David Ahern wrote:
> On 1/9/21 4:04 PM, Jakub Kicinski wrote:
> > Do you want to address the checkpatch issues, tho?  
> 
> Yes, I thought I had fixed those. Evidently missed a few.

Thanks, I'm never sure if people intentionally use different style
rules in selftests or just forget to checkpatch, so I never push back
on style :S
