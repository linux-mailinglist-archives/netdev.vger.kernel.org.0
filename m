Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6043FE622
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhIAXh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 19:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229989AbhIAXh4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 19:37:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF0C761026;
        Wed,  1 Sep 2021 23:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630539419;
        bh=EykNW2FhkEmnRMJz9o70p95envALD1NRfW3x6JldVno=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qLn/hzTwSp+SM82jsyjhMtnQDzt3cwG3ziFnix+rpXth+629a0ZWnGw7+EWlvgOFL
         nAhxjvvQBScUFttrJu82AdslNQnrWYrfbm/v/DjTVaQIhxKDGqEtqDSSlymxfyeTly
         CnjL4tGH4p+JACPh0cxPie7bKnuZDVBnI6tWF6zeAK0G/qxJYOKVsei+kXQ+qAhkk4
         he4DjmPqMMVH69ieGySuj0CYYe45/xVkHHa1CLIshTm9INNP1KXNOqZmUH9/sVcLEW
         jTBuVzsY+xI5S+ev6ME5fEFN3IyA1DE8r8Os3i9fU4+WIdR2Hwkz8Aszoa+9dKdBy8
         2aH35pwxm96Sw==
Date:   Wed, 1 Sep 2021 16:36:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        stable@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: b53: Set correct number of ports in
 the DSA struct
Message-ID: <20210901163657.74f39079@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ba35e7b8-4f90-9870-3e9e-f8666f5ebd0f@gmail.com>
References: <20210901092141.6451-1-zajec5@gmail.com>
        <20210901092141.6451-2-zajec5@gmail.com>
        <ba35e7b8-4f90-9870-3e9e-f8666f5ebd0f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Sep 2021 10:21:55 -0700 Florian Fainelli wrote:
> On 9/1/2021 2:21 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >=20
> > Setting DSA_MAX_PORTS caused DSA to call b53 callbacks (e.g.
> > b53_disable_port() during dsa_register_switch()) for invalid
> > (non-existent) ports. That made b53 modify unrelated registers and is
> > one of reasons for a broken BCM5301x support.
> >=20
> > This problem exists for years but DSA_MAX_PORTS usage has changed few
> > times so it's hard to specify a single commit this change fixes. =20
>=20
> You should still try to identify the relevant tags that this is fixing=20
> such that this gets back ported to the appropriate trees. We could use=20
> Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper"), to=20
> minimize the amount of work doing the back port.

To be clear are you okay with the fixes tag you provided or should we
wait for Rafa=C5=82 to double check?
