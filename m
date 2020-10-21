Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B267294E54
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 16:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443346AbgJUONo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 10:13:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38250 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2442621AbgJUONo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 10:13:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kVEs2-002pNa-MP; Wed, 21 Oct 2020 16:13:42 +0200
Date:   Wed, 21 Oct 2020 16:13:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <ardeleanalex@gmail.com>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alexaundru.ardelean@analog.com,
        Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        David Miller <davem@davemloft.net>, kuba@kernel.org
Subject: Re: [PATCH 1/2] net: phy: adin: clear the diag clock and set
 LINKING_EN during autoneg
Message-ID: <20201021141342.GO139700@lunn.ch>
References: <20201021135140.51300-1-alexandru.ardelean@analog.com>
 <20201021135802.GM139700@lunn.ch>
 <CA+U=DsoRVt66cANFJD896R-aOJseAF-1VkgcvLZHQ1rUTks3Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+U=DsoRVt66cANFJD896R-aOJseAF-1VkgcvLZHQ1rUTks3Eg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The frame-generator is an interesting feature of the PHY, that's not
> useful for the current phylib; the PHY can send packages [like a
> signal generator], and then these can be looped back, or sent over the
> wire.

Many PHYs that that. I posted some patches to the list a few years ago
adding basic support for the Marvell PHY frame generator. They got
NACKed. The netlink API, and some of the infrastructure i added for
cable testing would make it possible to fix the issues that caused the
NACK.

> Having said this, I'll include some comments for these in a V2 of this patchset.

Thanks.

	Andrew

P.S.

Your mail is broken somehow:

Delivery has failed to these recipients or groups:

alexaundru.ardelean@analog.com
The email address you entered couldn't be found. Please check the recipient's
email address and try to resend the message. If the problem continues, please
contact your email admin.
