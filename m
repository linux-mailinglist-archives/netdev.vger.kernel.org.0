Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5042C731C
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389398AbgK1VuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:50:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387626AbgK1T7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 14:59:02 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAF21221FF;
        Sat, 28 Nov 2020 19:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606593501;
        bh=3EmyCw5/ovjNwmz7PMcHck8AiiBEKqRovP4BafAmUz4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Up8/Atkoxtq0i1P2paK/Rsd6ZRU3kmg+OD7xSBb/nzwHw+963X2mTOWxbyLOdpSyg
         Pm1mJesTvoB7z9kZwvTsn1X9zglmFkSLhTDEV72mFXveIpz/T5CWJeHu5qbZjvxYkq
         +f0O1J4JgrpKB3w2Iao20I60Z8lBzH1hc9gOBplY=
Date:   Sat, 28 Nov 2020 11:58:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/3] pull request for net: batman-adv 2020-11-27
Message-ID: <20201128115820.081b16d7@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127173849.19208-1-sw@simonwunderlich.de>
References: <20201127173849.19208-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 18:38:46 +0100 Simon Wunderlich wrote:
> here are some more bugfixes for batman-adv which we would like to have integrated into net.
> 
> Please pull or let me know of any problem!> 
> ----------------------------------------------------------------
> Here are some batman-adv bugfixes:
> 
>  - Fix head/tailroom issues for fragments, by Sven Eckelmann (3 patches)

Pulled, thanks!
