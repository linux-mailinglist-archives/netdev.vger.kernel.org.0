Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE7E2C33B4
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388976AbgKXWLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:11:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728523AbgKXWLV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 17:11:21 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E26A20715;
        Tue, 24 Nov 2020 22:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606255880;
        bh=2dwrTnBapMpeeKOlbFjCouY1RJBlpScC7T+FqQWSpjo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IV98qterQcQMxMoALBJYPCpjEbCIXf+g5DQQkP6ym0AhK77rDsK769R0GsezSZWBq
         g+AGgdxu7OPiW99q555tMlIFoqE1C45PvxjWn2b9qsMJHj527810ehoumvuDjBmuLH
         PWAm71QLH5pKQkFLg9uorIfMRIJMWppCznzdfKCE=
Date:   Tue, 24 Nov 2020 14:11:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: warn if gso_type isn't set for a GSO SKB
Message-ID: <20201124141119.49972889@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <97c78d21-7f0b-d843-df17-3589f224d2cf@gmail.com>
References: <97c78d21-7f0b-d843-df17-3589f224d2cf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 00:22:20 +0100 Heiner Kallweit wrote:
> In bug report [0] a warning in r8169 driver was reported that was
> caused by an invalid GSO SKB (gso_type was 0). See [1] for a discussion
> about this issue. Still the origin of the invalid GSO SKB isn't clear.
> 
> It shouldn't be a network drivers task to check for invalid GSO SKB's.
> Also, even if issue [0] can be fixed, we can't be sure that a
> similar issue doesn't pop up again at another place.
> Therefore let gso_features_check() check for such invalid GSO SKB's.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209423
> [1] https://www.spinics.net/lists/netdev/msg690794.html
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks!
