Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E51AF866
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfIKJC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:02:28 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37627 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfIKJC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 05:02:28 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1i7yW7-0005Rk-R0; Wed, 11 Sep 2019 11:02:23 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1i7yVz-0006vQ-1a; Wed, 11 Sep 2019 11:02:15 +0200
Date:   Wed, 11 Sep 2019 11:02:15 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        The j1939 authors <linux-can@vger.kernel.org>,
        Bastian Stender <bst@pengutronix.de>,
        Elenita Hinds <ecathinds@gmail.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        kbuild test robot <lkp@intel.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        Robin van der Gracht <robin@protonic.nl>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20190911090215.n776azhwewfbr6xf@pengutronix.de>
References: <20190911004103.3480fa40@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911004103.3480fa40@canb.auug.org.au>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:56:05 up 116 days, 15:14, 66 users,  load average: 0.12, 0.07,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Wed, Sep 11, 2019 at 12:41:03AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Commit
> 
>   9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> 
> is missing a Signed-off-by from its author.
> 
> [Not sure if I should complain about this one ...]

Here is the original pull request message for this patch series:
"The final patch is the collective effort of many entities (The j1939
authors: Oliver Hartkopp, Bastian Stender, Elenita Hinds, kbuild test
robot, Kurt Van Dijck, Maxime Jayat, Robin van der Gracht, Oleksij
Rempel, Marc Kleine-Budde). It adds support of SAE J1939 protocol to the
CAN networking stack."
https://www.mail-archive.com/netdev@vger.kernel.org/msg313476.html

Since the patch can be hardly assigned to one author we deiced to use
address of CAN mailing list.

Best regards,
Oleksij Rempel
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
