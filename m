Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 398DF615B7
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 19:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfGGRkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 13:40:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59070 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbfGGRkY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jul 2019 13:40:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KNrQZUwQbs9unI6KF4K4Pczrms+Rdr/eZr6E2o3xov0=; b=YoWPSP6ELkSWLHjstJ9zwmzQJp
        BhKs/L7Jwuz2S29yVUtvAF9Pxd5edteiAZA4rKEUZXd/dPjOlLzVuJYCcUEUrpbMbjx7anGs44OZ2
        uVM87xN9kI28+xnJE54ihl44yegQVSWviTGlAfJ3UxLGxbw2xk7UzKiT1vz04vcIMBcA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkB8h-0005pv-7O; Sun, 07 Jul 2019 19:39:51 +0200
Date:   Sun, 7 Jul 2019 19:39:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 2/6] taprio: Add support for hardware
 offloading
Message-ID: <20190707173951.GB21188@lunn.ch>
References: <20190707172921.17731-1-olteanv@gmail.com>
 <20190707172921.17731-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190707172921.17731-3-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 07, 2019 at 08:29:17PM +0300, Vladimir Oltean wrote:
> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> 
> This allows taprio to offload the schedule enforcement to capable
> network cards, resulting in more precise windows and less CPU usage.
> 
> The important detail here is the difference between the gate_mask in
> taprio and gate_mask for the network driver. For the driver, each bit
> in gate_mask references a transmission queue: bit 0 for queue 0, bit 1
> for queue 1, and so on. This is done so the driver doesn't need to
> know about traffic classes.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

Hi Vladimir

Your SOB is also needed here.

     Andrew
