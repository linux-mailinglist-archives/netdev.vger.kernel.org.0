Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A01D3432F4
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 15:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhCUOPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 10:15:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39148 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229973AbhCUOP3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 10:15:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lNyrW-00CFBs-Gb; Sun, 21 Mar 2021 15:15:26 +0100
Date:   Sun, 21 Mar 2021 15:15:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com
Subject: Re: [net-next PATCH 0/8] configuration support for switch headers &
 phy
Message-ID: <YFdU/g/0irQkCOuW@lunn.ch>
References: <20210321120958.17531-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210321120958.17531-1-hkelam@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 05:39:50PM +0530, Hariprasad Kelam wrote:
> This series of patches add support for parsing switch headers and
> configuration support for phy modulation type(NRZ or PAM4).
> 
> PHYs that support changing modulation type ,user can configure it
> through private flags pam4.
> 
> Marvell switches support DSA(distributed switch architecture) with
> different switch headers like FDSA and EDSA. This patch series adds
> private flags to enable user to configure interface in fdsa/edsa
> mode such that flow steering (forwading packets to pf/vf depending on
> switch header fields) and packet parsing can be acheived.

Hi Hariprasad 

Private flags sound very wrong here. I would expect to see some
integration between the switchdev/DSA driver and the MAC driver.
Please show how this works in combination with
drivers/net/dsa/mv88e6xxx or drivers/net/ethernet/marvell/prestera.

	  Andrew
