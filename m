Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6692607DC
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 02:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgIHAyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 20:54:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48840 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgIHAyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 20:54:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kFRuN-00DiAC-QE; Tue, 08 Sep 2020 02:54:51 +0200
Date:   Tue, 8 Sep 2020 02:54:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: dsa: change PHY error message again
Message-ID: <20200908005451.GA3267902@lunn.ch>
References: <20200907230656.1666974-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907230656.1666974-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 02:06:56AM +0300, Vladimir Oltean wrote:
> slave_dev->name is only populated at this stage if it was specified
> through a label in the device tree. However that is not mandatory.
> When it isn't, the error message looks like this:
> 
> [    5.037057] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> [    5.044672] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> [    5.052275] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> [    5.059877] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> 
> which is especially confusing since the error gets printed on behalf of
> the DSA master (fsl_enetc in this case).
> 
> Printing an error message that contains a valid reference to the DSA
> port's name is difficult at this point in the initialization stage, so
> at least we should print some info that is more reliable, even if less
> user-friendly. That may be the driver name and the hardware port index.
> 
> After this change, the error is printed as:
> 
> [    6.051587] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 0
> [    6.061192] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 1
> [    6.070765] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 2
> [    6.080324] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 3
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
