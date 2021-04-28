Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB19736D975
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 16:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239805AbhD1OTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 10:19:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44582 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230050AbhD1OTn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 10:19:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lbl1g-001WIT-Dq; Wed, 28 Apr 2021 16:18:52 +0200
Date:   Wed, 28 Apr 2021 16:18:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH net-next 1/3] net: marvell: prestera: bump supported
 firmware version to 3.0
Message-ID: <YIluzFlPtSRvS/dR@lunn.ch>
References: <20210423155933.29787-1-vadym.kochan@plvision.eu>
 <20210423155933.29787-2-vadym.kochan@plvision.eu>
 <YIL6feaar8Y/yOaZ@lunn.ch>
 <20210423170437.GC17656@plvision.eu>
 <YIMLcsstbpY215oJ@lunn.ch>
 <20210428134724.GA405@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428134724.GA405@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Regarding the distribution issue when the driver version might be released
> earlier than the firmware, it looks like that the probability of such
> case is very low because the distributor of the target Linux system will
> keep track (actually this is how I see it) that driver and firmware
> versions are aligned.

You really expect Debian, Redhat, openWRT, SuSE to keep a close eye on
your kernel driver and update their packages at a time you suggest?

I'm also not sure your management port argument is valid. This is an
enterprise switch, not a TOR. It is probably installed in some broom
cupboard at a satellite facility. The management port is not likely to
have its own dedicated link back to the central management
site. Upgrades are going to be applied over the network, and you have
a real danger of turning it into a remote brick, needing local access
to restore it.

I really think you need to support two firmware generations.

  Andrew
