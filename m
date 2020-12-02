Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC1B2CB2C3
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 03:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgLBCUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 21:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbgLBCUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 21:20:14 -0500
Date:   Tue, 1 Dec 2020 18:19:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606875574;
        bh=W96GnwTM8z4iLHTRTjdCgkkytGxWyNWjbvJHPmNk8YQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=2XeNdg+kpQZYhZYcI0r00akl3LIeXkDXRAERuKWyP9f215eh8LDA/0HnB9+b2sK8+
         bG9HkHYxS7y8gbIQSi7P+mU7GhB6ps4GfSmwrKKMMZG8IRqSoGJ3Q4trbIdLB8Dw5m
         TAK7ukx7tA3sfbuB2qhO6kLaMx1EJC26gf8rmOBk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: set tc_offset only if tally counter
 reset isn't supported
Message-ID: <20201201181932.13fd5d4a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <526618b2-b1bf-1844-b82a-dab2df7bdc8f@gmail.com>
References: <526618b2-b1bf-1844-b82a-dab2df7bdc8f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 09:57:29 +0100 Heiner Kallweit wrote:
> On chip versions supporting tally counter reset we currently update
> the counters after a reset although we know all counters are zero.
> Skip this unnecessary step.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks!
