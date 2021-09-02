Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B5C3FF2AD
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 19:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347202AbhIBRm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 13:42:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53780 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346632AbhIBRmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 13:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VtDdRsvYXvPM91L9W6La/FIYqWBh7JU22fy4eU4q8YI=; b=SIxlOcdujqgPVHNPYQx7mBMoYR
        k8Y5DQyburGjlxK0llEtHbv+mUjHVW5BxcEVjzVUlqjm8B/DO0maHJMtimq7PVLJL75z2fmBrPBjJ
        DI29J//drW58AM0CWof/L3TDPpOUJzLpxqUaQglBvzFp/i6dMXFXb1Z1WLGb2z+XR5fI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mLqi3-0051nR-1E; Thu, 02 Sep 2021 19:41:07 +0200
Date:   Thu, 2 Sep 2021 19:41:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YTEMs1mMIT/Z0c4H@lunn.ch>
References: <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch>
 <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch>
 <20210831231804.zozyenear45ljemd@skbuf>
 <CAGETcx-ktuU1RqXwj_qV8tCOLAg3DXU-wCAm6+NukyxRencSjw@mail.gmail.com>
 <20210901084625.sqzh3oacwgdbhc7f@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901084625.sqzh3oacwgdbhc7f@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>   How would this be avoided? Or are you thinking of some kind of two-level
>   component driver system:
>   - the DSA switch is a component master, with components being its
>     sub-devices such as internal PHYs etc
>   - the DSA switch is also a component of the DSA switch tree

I think you might be missing a level. Think about the automotive
reference design system you posted the DT for a couple of days
ago. Don't you have cascaded switches, which are not members of the
same DSA tree. You might need a component for that whole group of
switches, above what you suggest here.

Can you nest components? How deep can you nest them?

    Andrew
