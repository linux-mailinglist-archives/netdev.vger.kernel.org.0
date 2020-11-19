Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD922B9D09
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgKSVlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:41:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgKSVlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 16:41:51 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfrgR-0080ip-HL; Thu, 19 Nov 2020 22:41:39 +0100
Date:   Thu, 19 Nov 2020 22:41:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mdio_bus: suppress err message for reset gpio
 EPROBE_DEFER
Message-ID: <20201119214139.GL1853236@lunn.ch>
References: <20201119203446.20857-1-grygorii.strashko@ti.com>
 <1a59fbe1-6a5d-81a3-4a86-fa3b5dbfdf8e@gmail.com>
 <cabad89e-23cc-18b3-8306-e5ef1ee4bfa6@ti.com>
 <44a3c8c0-9dbd-4059-bde8-98486dde269f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44a3c8c0-9dbd-4059-bde8-98486dde269f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> Doesn't checkpatch complain about line length > 80 here?
> > 
> > :)
> > 
> > commit bdc48fa11e46f867ea4d75fa59ee87a7f48be144
> > Author: Joe Perches <joe@perches.com>
> > Date:   Fri May 29 16:12:21 2020 -0700
> > 
> >     checkpatch/coding-style: deprecate 80-column warning
> > 
> 
> Ah, again something learnt. Thanks for the reference.

But it then got revoked for netdev. Or at least it was planned to
re-impose 80 for netdev. I don't know if checkpatch got patched yet.

	  Andrew
