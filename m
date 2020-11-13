Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097102B24E7
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgKMTvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:51:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgKMTvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 14:51:20 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0107206A1;
        Fri, 13 Nov 2020 19:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605297080;
        bh=Yaba0wfKJ3Rh00ovTXjYCvG+pfoCtC87673MJwW6jx8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O4IjcH4Fjs1i7x3cHbSKk4Lr7boCO5KQ3ET0kWKJpacDUN/+vledcyX0rX8nccmet
         v0orvpMxU9puW9ScZDxEJQinNy2Ua7r/+O+7RakDohPwd4r4EG9+qaTeMfhPn0qTRu
         p+Ykpt2uxMikk9zS8Jyo/ytIDQLzaWQYuLDbhDl0=
Date:   Fri, 13 Nov 2020 11:51:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lev Stipakov <lstipakov@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lev Stipakov <lev@openvpn.net>
Subject: Re: [PATCH v2 1/3] net: mac80211: use core API for updating TX/RX
 stats
Message-ID: <20201113115118.618f57de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAGyAFMUrNRAiDZuNa2QCJQ-JuQAUdDq3nOB17+M=wc2xNknqmQ@mail.gmail.com>
References: <44c8b5ae-3630-9d98-1ab4-5f57bfe0886c@gmail.com>
        <20201113085804.115806-1-lev@openvpn.net>
        <53474f83c4185caf2e7237f023cf0456afcc55cc.camel@sipsolutions.net>
        <CAGyAFMUrNRAiDZuNa2QCJQ-JuQAUdDq3nOB17+M=wc2xNknqmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 14:25:25 +0200 Lev Stipakov wrote:
> > Seems I should take this through my tree, any objections?

Go for it, you may need to pull net-next first but that should happen
soonish anyway, when I get to your pr.

> The rest are similar changes for openvswitch and xfrm subsystems, so
> I've sent those to the list of maintainers I got from
> scripts/get_maintainer.pl.

Lev, please either post the patches separately (non-series) or make
them a proper series which has a cover letter etc. and CC folks on all
the patches.

Since there are no dependencies between the patches here you could have
gone for separate patches here.
