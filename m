Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F71B1066CB
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKVHGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:06:52 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60813 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfKVHGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 02:06:52 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rsc@pengutronix.de>)
        id 1iY31l-0007oP-0Z; Fri, 22 Nov 2019 08:06:49 +0100
Received: from rsc by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <rsc@pengutronix.de>)
        id 1iY31k-0003wd-4L; Fri, 22 Nov 2019 08:06:48 +0100
Date:   Fri, 22 Nov 2019 08:06:48 +0100
From:   Robert Schwebel <r.schwebel@pengutronix.de>
To:     David Miller <davem@davemloft.net>
Cc:     corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 5/5] docs: networking: nfc: change to rst format
Message-ID: <20191122070648.xqdz4nujvtvtbff6@pengutronix.de>
References: <20191121155503.52019-1-r.schwebel@pengutronix.de>
 <20191121155503.52019-5-r.schwebel@pengutronix.de>
 <20191121.150607.1310896813096710634.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121.150607.1310896813096710634.davem@davemloft.net>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:05:49 up 137 days, 13:16, 129 users,  load average: 0,33, 0,22,
 0,15
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 03:06:07PM -0800, David Miller wrote:
> From: Robert Schwebel <r.schwebel@pengutronix.de>
> Date: Thu, 21 Nov 2019 16:55:03 +0100
> 
> > Now that the sphinx syntax has been fixed, change the document from txt
> > to rst and add it to the index.
> > 
> > Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
> 
> As Jon mentioned, you aren't actually adding it to the index in this
> patch yet the commit message says that you did.

The index doesn't seem to be particularly ordered, so I'll just add it
to the end, ok?

> Please fix that, repsin this series, and provide a proper "[PATCH 0/5]
> ..."  cover letter this time.

Will do, thanks.

rsc
-- 
Pengutronix e.K.                           | Dipl.-Ing. Robert Schwebel  |
Steuerwalder Str. 21                       | https://www.pengutronix.de/ |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
