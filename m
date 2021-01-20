Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879292FDFBD
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404650AbhATXzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:55:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404189AbhATXdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 18:33:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5A8122B2A;
        Wed, 20 Jan 2021 23:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611185580;
        bh=t2Zln7DBJVyoGoKcei8JH3sZLU0upaVxfgzcLoCEak4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IzFlscfenbfXq3lZ44nay0YFMe3UwqmavlsSN6E94KeAJamdbc6Xc1cJiB3HERtgE
         0WBwCVJdOO+nfa4vxRDGvV6vK8R+H2+5xoFDT5BIOmNSkGF1nsLWWbzDaUV5GkbtjN
         wox04NN9fc0tEX/akjnaJgktQGG0Z+srQbXojsz/bDKCa3e1gm50c4O7hNnotLXH/B
         RjUryg38Slzs+lJwdSB5p2FZNodS64mqnMJoeuLBomclL4labcgVwxbVlcYDN30Z5s
         rwkaCnva15hu2Dr3tLFKTIMoRwvegZsP7YOVsnXaMo24etbpai46WrjjJogFZW9FbA
         1lXsiY4NcOjNA==
Date:   Wed, 20 Jan 2021 15:32:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, krishna.c.sudi@intel.com
Subject: Re: [PATCH 17/18] net: iosm: readme file
Message-ID: <20210120153255.4fcf7e32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YAiF2/lMGZ0mPUSK@lunn.ch>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
        <20210107170523.26531-18-m.chetan.kumar@intel.com>
        <X/eJ/rl4U6edWr3i@lunn.ch>
        <87turftqxt.fsf@miraculix.mork.no>
        <YAiF2/lMGZ0mPUSK@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 20:34:51 +0100 Andrew Lunn wrote:
> On Sun, Jan 17, 2021 at 06:26:54PM +0100, Bj=C3=B8rn Mork wrote:
> > I was young and stupid. Now I'm not that young anymore ;-) =20
>=20
> We all make mistakes, when we don't have the knowledge there are other
> ways. That is partially what code review is about.
>=20
> > Never ever imagined that this would be replicated in another driver,
> > though.  That doesn't really make much sense.  We have learned by now,
> > haven't we?  This subject has been discussed a few times in the past,
> > and Johannes summary is my understanding as well:
> > "I don't think anyone likes that" =20
>=20
> So there seems to be agreement there. But what is not clear, is
> anybody willing to do the work to fix this, and is there enough ROI.
>=20
> Do we expect more devices like this? Will 6G, 7G modems look very
> different?=20

Didn't Intel sell its 5G stuff off to Apple?

> Be real network devices and not need any of this odd stuff?
> Or will they be just be incrementally better but mostly the same?
>=20
> I went into the review thinking it was an Ethernet driver, and kept
> having WTF moments. Now i know it is not an Ethernet driver, i can say
> it is not my domain, i don't know the field well enough to say if all
> these hacks are acceptable or not.
>=20
> It probably needs David and Jakub to set the direction to be followed.

AFAIU all those cellar modems are relatively slow and FW-heavy, so the
ideal solution IMO is not even a common kernel interface but actually
a common device interface, like NVMe (or virtio for lack of better
examples).
