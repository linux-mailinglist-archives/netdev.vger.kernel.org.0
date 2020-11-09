Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF57B2AC2D6
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 18:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgKIRuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 12:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgKIRuo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 12:50:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F11992067C;
        Mon,  9 Nov 2020 17:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604944243;
        bh=hiqngZoBv41M6Rqel9OTiQHwa8j+UG2pi+kA4rnVhX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pC77bcxvGDIC7X4gP2TG6b3TXJEc2mRHhEBuscdq0tvrRoT9CXDDesfiuXRiFCySk
         QlFh6WPCJQ3Pf0x4lX9brNyK5Nv7KWzC7nOmBpN5d29Y+qaob+1tahK+gf29SuRZwj
         dZ6sop7TOPX3ZGGxGWvuO/211NLGKd8LmVtprlYE=
Date:   Mon, 9 Nov 2020 09:50:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Thomas Deutschmann <whissi@gentoo.org>,
        Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christian Hesse <list@eworm.de>
Subject: Re: [PATCH] mac80211: fix regression where EAPOL frames were sent
 in plaintext
Message-ID: <20201109095041.628039d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <61cee15bf9f317c0ad2761c7f08a6bca1d2f2531.camel@sipsolutions.net>
References: <20201019160113.350912-1-Mathy.Vanhoef@kuleuven.be>
        <259a6efa-da48-c946-3008-3c2edaf1a3d0@gentoo.org>
        <61cee15bf9f317c0ad2761c7f08a6bca1d2f2531.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 08 Nov 2020 22:01:51 +0100 Johannes Berg wrote:
> On Sun, 2020-11-08 at 20:34 +0100, Thomas Deutschmann wrote:
> > 
> > 
> > Can we please get this applied to linux-5.10 and linux-5.9?  
> 
> It's tagged for that, so once it enters mainline will get picked up.
> Should be soon now, I assume.

It should be in mainline since Thu, FWIW, so it should be part of
5.10-rc3 and the next crop of stable kernels.
