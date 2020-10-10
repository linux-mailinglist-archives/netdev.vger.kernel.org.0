Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D0928A211
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388635AbgJJWyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730437AbgJJS5V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 14:57:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AED312227E;
        Sat, 10 Oct 2020 17:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602351161;
        bh=6Nfiiu/X34lvAQOdoc6RiN2TjDrwhd7WB1u3kM3Ctyg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yLhcX5LPgaGcZgPC7sRf1EIKEzArXlEgDuWuL9h2+93h0sofOMBFprKRh8CYXgkqM
         tDkPqV3L97z5MiG/uyxc3MSQRA02Tmee1YzRRkijpyxcnig/Am0O+0PrPFQ2S9nvST
         /FuIOgH1lQxWvYMFK827gOYbMIoyNBKB+fpAQ+yU=
Date:   Sat, 10 Oct 2020 10:32:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can 2020-10-08
Message-ID: <20201010103240.11c8e69d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008214022.2044402-1-mkl@pengutronix.de>
References: <20201008214022.2044402-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 23:40:19 +0200 Marc Kleine-Budde wrote:
> The first patch is part of my pull request "linux-can-fixes-for-5.9-20201006",
> so consider that one obsolete and take this instead.
> 
> The first patch is by Lucas Stach and fixes m_can driver by removing an
> erroneous call to m_can_class_suspend() in runtime suspend. Which causes the
> pinctrl state to get stuck on the "sleep" state, which breaks all CAN
> functionality on SoCs where this state is defined.
> 
> The last two patches target the j1939 protocol: Cong Wang fixes a syzbot
> finding of an uninitialized variable in the j1939 transport protocol. I
> contribute a patch, that fixes the initialization of a same uninitialized
> variable in a different function.

Pulled, thanks!

Since we missed 5.9 would you like me to queue these up for stable?
