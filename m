Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4790A1FFA7D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 19:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgFRRqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 13:46:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729509AbgFRRqz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 13:46:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jlyck-0019PJ-30; Thu, 18 Jun 2020 19:46:50 +0200
Date:   Thu, 18 Jun 2020 19:46:50 +0200
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
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 7/9] net: dsa: hellcreek: Add PTP status LEDs
Message-ID: <20200618174650.GI240559@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de>
 <20200618064029.32168-8-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618064029.32168-8-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 08:40:27AM +0200, Kurt Kanzenbach wrote:
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

Hi Kurt

Is the hardware driving these signals at all? Or are these just
suggested names in the documentation? It would not be an issue to have
user space to configure them to use the heartbeat trigger, etc?

     Andrew
