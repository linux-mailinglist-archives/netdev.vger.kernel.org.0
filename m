Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F8D30E83
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 15:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfEaNEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 09:04:39 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47269 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfEaNEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 09:04:38 -0400
Received: from kresse.hi.pengutronix.de ([2001:67c:670:100:1d::2a])
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <l.stach@pengutronix.de>)
        id 1hWhD3-0003WO-9s; Fri, 31 May 2019 15:04:37 +0200
Message-ID: <1559307876.2557.5.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] ethtool: Add 100BaseT1 and 1000BaseT1 link modes
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        linville@redhat.com
Date:   Fri, 31 May 2019 15:04:36 +0200
In-Reply-To: <20190531123020.GC18608@lunn.ch>
References: <20190530180616.1418-1-andrew@lunn.ch>
         <20190530180616.1418-3-andrew@lunn.ch>
         <20190531093029.GD15954@unicorn.suse.cz> <20190531115928.GA18608@lunn.ch>
         <1559305305.2557.3.camel@pengutronix.de> <20190531123020.GC18608@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::2a
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, den 31.05.2019, 14:30 +0200 schrieb Andrew Lunn:
> > That's not just theory. The Broadcom BCM54811 PHY supports both
> > 100/1000baseT, as well as 100baseT1.
> 
> Hi Lucus
> 
> There does not appear to be a driver for it, which is why i've not
> seen it, nor have we had this conversation before.
> 
> Do you have a driver to submit?

No, we've looked at this chip in the past for a project, but never
ended up doing anything with it. But the datasheet is quite clear that
the PHY supports both modes.

It was just a drive-by comment, as something clicked in my mind there.

Regards,
Lucas
