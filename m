Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DE933E03D
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhCPVQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232817AbhCPVQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 17:16:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FB5F64F94;
        Tue, 16 Mar 2021 21:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615929382;
        bh=DYmmL0+J/1MLOIAz8nsNuBrSOWeZ80Elhpmcap7Ayoo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b52/yg3Hwo8dmRsj5CBok+P4ozVQwOom/6Nun+EE60OSUmPKHP/18azlHXAW3A2d7
         BWUF2ZFjfnU6DfZL4jH5cBbl/A+nARj6O6/7i80TJ/N11Ebdu+ndFBQfi6ndicDs1T
         gd0QdM4Qh0rPLWsCkIhAOY83qLw2liTRdWNQq2ZFCf1x8jDDoiTi1xdQhUcpC9YYvZ
         /CL8xkroN98Lq21Ts8UBczR6kiKL6tQCZy9OtnX/6ifii82UGS0yvTgsmyFl/79vQK
         hyyh0wFikJmP8yQUhzymm0BtIbOn4A968GFr31Rt3DEql9Glq5fra/RMEycWwZgZFo
         cZSkAyYc+k5fg==
Date:   Tue, 16 Mar 2021 14:16:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Martin Willi <martin@strongswan.org>
Subject: Re: [net 01/11] can: dev: Move device back to init netns on owning
 netns delete
Message-ID: <20210316141621.1d1bd26d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316082104.4027260-2-mkl@pengutronix.de>
References: <20210316082104.4027260-1-mkl@pengutronix.de>
        <20210316082104.4027260-2-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 09:20:54 +0100 Marc Kleine-Budde wrote:
> + *	@netns_refund: Physical device, move to init_net on netns exit

I feel like we could do better with the name, and the kdoc (not sure
what constitutes a physical device these days)... but I have no better
suggestion right now :)

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
