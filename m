Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A602D4EB7
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733152AbgLIXY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:24:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47492 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLIXY5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:24:57 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kn8oZ-00B8Oc-0L; Thu, 10 Dec 2020 00:24:07 +0100
Date:   Thu, 10 Dec 2020 00:24:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     ashkan.boldaji@digi.com, clang-built-linux@googlegroups.com,
        davem@davemloft.net, devicetree@vger.kernel.org,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com, marek.behun@nic.cz,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v11 3/4] net: dsa: mv88e6xxx: Change serdes lane
 parameter type  from u8 type to int
Message-ID: <20201209232406.GH2649111@lunn.ch>
References: <cover.1607488953.git.pavana.sharma@digi.com>
 <cc16a07f381973b0f4c987090bc307c8f854181d.1607488953.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc16a07f381973b0f4c987090bc307c8f854181d.1607488953.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Wed, Dec 09, 2020 at 03:05:17PM +1000, Pavana Sharma wrote:
> Returning 0 is no more an error case with MV88E6393 family
> which has serdes lane numbers 0, 9 or 10.
> So with this change .serdes_get_lane will return lane number
> or -errno (-ENODEV or -EOPNOTSUPP).
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>

I see here you did actually act on my comment. Thanks.

But i also said:

> Other than that:
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Please add such tags to new versions of the patches. It then makes it
easier for everybody to know the review state of the patches, which
have been reviewed and deemed O.K, and which need more review.

     Thanks
	Andrew
