Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF533432FC
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 15:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCUO2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 10:28:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhCUO16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 10:27:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lNz3c-00CFKs-QF; Sun, 21 Mar 2021 15:27:56 +0100
Date:   Sun, 21 Mar 2021 15:27:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com
Subject: Re: [net-next PATCH 2/8] octeontx2-pf: Add ethtool priv flag to
 control PAM4 on/off
Message-ID: <YFdX7HNaZXUjb37e@lunn.ch>
References: <20210321120958.17531-1-hkelam@marvell.com>
 <20210321120958.17531-3-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210321120958.17531-3-hkelam@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 05:39:52PM +0530, Hariprasad Kelam wrote:
> From: Felix Manlunas <fmanlunas@marvell.com>
> 
> For PHYs that support changing modulation type (NRZ or PAM4), enable these
> commands:
> 
>         ethtool --set-priv-flags  ethX pam4 on
>         ethtool --set-priv-flags  ethX pam4 off    # means NRZ modulation
>         ethtool --show-priv-flags ethX

Why is this not derived from the link mode? How do other Vendors
support this in their high speed MAC/PHY combinations.

Please stop using priv flags like this. This is not a Marvell specific
problem. Any high speed MAC/PHY combination is going to need some way
to configure this. So please think about the best generic solution.

This combined with your DSA changes give me a bad feeling. It seems
like you are just trying to dump your SDK features into the kernel,
without properly integrating the features in a vendor neutral way.

	Andrew
