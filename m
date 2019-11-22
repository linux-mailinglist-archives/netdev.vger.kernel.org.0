Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07D001066C3
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfKVHBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:01:06 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33545 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfKVHBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 02:01:06 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rsc@pengutronix.de>)
        id 1iY2wA-000777-Mb; Fri, 22 Nov 2019 08:01:02 +0100
Received: from rsc by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <rsc@pengutronix.de>)
        id 1iY2w8-0003lz-Vj; Fri, 22 Nov 2019 08:01:00 +0100
Date:   Fri, 22 Nov 2019 08:01:00 +0100
From:   Robert Schwebel <r.schwebel@pengutronix.de>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 4/5] docs: networking: nfc: fix code block syntax
Message-ID: <20191122070100.yzxuqulobjrhxoa7@pengutronix.de>
References: <20191121155503.52019-1-r.schwebel@pengutronix.de>
 <20191121155503.52019-4-r.schwebel@pengutronix.de>
 <20191121100919.1b483fab@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121100919.1b483fab@lwn.net>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:00:27 up 137 days, 13:10, 128 users,  load average: 0,67, 0,26,
 0,14
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 10:09:19AM -0700, Jonathan Corbet wrote:
> > +.. code-block:: none
> > +
> > +        struct sockaddr_nfc {
> > +               sa_family_t sa_family;
> > +               __u32 dev_idx;
> > +               __u32 target_idx;
> > +               __u32 nfc_protocol;
> > +        };
> 
> Rather than cluttering the text with ".. code-block::", you can just use
> the literal-block shortcut:
> 
> 	targets. All NFC sockets use AF_NFC::
> 
> 	    struct sockaddr_nfc {
> 

Thanks, will do in v2.

rsc
-- 
Pengutronix e.K.                           | Dipl.-Ing. Robert Schwebel  |
Steuerwalder Str. 21                       | https://www.pengutronix.de/ |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
