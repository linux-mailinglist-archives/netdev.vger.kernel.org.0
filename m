Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5519250BE3
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgHXWu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:50:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48014 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgHXWu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 18:50:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kALIk-00BhXX-Uf; Tue, 25 Aug 2020 00:50:54 +0200
Date:   Tue, 25 Aug 2020 00:50:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 6/8] net: dsa: hellcreek: Add PTP status LEDs
Message-ID: <20200824225054.GL2403519@lunn.ch>
References: <20200820081118.10105-1-kurt@linutronix.de>
 <20200820081118.10105-7-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820081118.10105-7-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 10:11:16AM +0200, Kurt Kanzenbach wrote:
> The switch has two controllable I/Os which are usually connected to LEDs. This
> is useful to immediately visually see the PTP status.
> 
> These provide two signals:
> 
>  * is_gm
> 
>    This LED can be activated if the current device is the grand master in that
>    PTP domain.
> 
>  * sync_good
> 
>    This LED can be activated if the current device is in sync with the network
>    time.
> 
> Expose these via the LED framework to be controlled via user space
> e.g. linuxptp.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
