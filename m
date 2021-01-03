Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5BE2E89FB
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 03:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbhACCKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 21:10:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46946 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbhACCKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Jan 2021 21:10:03 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kvspW-00FhfG-7a; Sun, 03 Jan 2021 03:09:14 +0100
Date:   Sun, 3 Jan 2021 03:09:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     hauke@hauke-m.de, netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] net: dsa: lantiq_gswip: Enable GSWIP_MII_CFG_EN also
 for internal PHYs
Message-ID: <X/EnSv8gyprpOWRr@lunn.ch>
References: <20210103012544.3259029-1-martin.blumenstingl@googlemail.com>
 <20210103012544.3259029-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103012544.3259029-2-martin.blumenstingl@googlemail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 03, 2021 at 02:25:43AM +0100, Martin Blumenstingl wrote:
> Enable GSWIP_MII_CFG_EN also for internal PHYs to make traffic flow.
> Without this the PHY link is detected properly and ethtool statistics
> for TX are increasing but there's no RX traffic coming in.
> 
> Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Cc: stable@vger.kernel.org

Hi Martin

No need to Cc: stable. David or Jakub will handle the backport to
stable.  You should however set the subject to [PATCH net 1/2] and
base the patches on the net tree, not net-next.

     Andrew
