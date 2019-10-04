Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B98CBACA
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 14:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387573AbfJDMsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 08:48:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60860 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfJDMsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 08:48:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sFSABVM5xhY1ofChx6SKGM+3GUKOlIR3njAIBzmp/bY=; b=eMr9PklEC15Az75KSoxZeTOFjK
        MYyGZxFFwQfcH/dfktNDBZaGX5z4N14LybFsWuupnmRSu1zf/qt95K3Heo1anOGfSpuHd1/1vKVOb
        p8tGpKYRePUeUGRMn6dSJgwnT1tGkxISvrSj5F0CrshfC+G9OJR2ht4dBvt9Mj72RBS8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iGMzz-000113-GF; Fri, 04 Oct 2019 14:47:55 +0200
Date:   Fri, 4 Oct 2019 14:47:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 0/2] mv88e6xxx: Allow config of ATU hash
 algorithm
Message-ID: <20191004124755.GA3817@lunn.ch>
References: <20191004013523.28306-1-andrew@lunn.ch>
 <20191003191455.021156d2@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003191455.021156d2@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 07:14:55PM -0700, Jakub Kicinski wrote:
> On Fri,  4 Oct 2019 03:35:21 +0200, Andrew Lunn wrote:
> > The Marvell switches allow the hash algorithm for MAC addresses in the
> > address translation unit to be configured. Add support to the DSA core
> > to allow DSA drivers to make use of devlink parameters, and allow the
> > ATU hash to be get/set via such a parameter.
> > 
> > Andrew Lunn (2):
> >   net: dsa: Add support for devlink device parameters
> >   net: dsa: mv88e6xxx: Add devlink param for ATU hash algorithm.
> > 
> >  drivers/net/dsa/mv88e6xxx/chip.c        | 136 +++++++++++++++++++++++-
> >  drivers/net/dsa/mv88e6xxx/chip.h        |   4 +
> >  drivers/net/dsa/mv88e6xxx/global1.h     |   3 +
> >  drivers/net/dsa/mv88e6xxx/global1_atu.c |  30 ++++++
> >  include/net/dsa.h                       |  23 ++++
> >  net/dsa/dsa.c                           |  48 +++++++++
> >  net/dsa/dsa2.c                          |   7 +-
> >  7 files changed, 249 insertions(+), 2 deletions(-)
> 
> We try to make sure devlink parameters are documented under
> Documentation/networking/devlink-params-$drv. Could you add 
> a simple doc for mv88e6xxx with a short description?

Jakub

Sure, no problem.

I don't know what the hash algorithms actually are, we have just
played around and found that in some settings, a different value
helps. So the documentation will be limited.

	Andrew
