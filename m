Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20CB2C3457
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 00:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732098AbgKXXHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 18:07:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731850AbgKXXHh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 18:07:37 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7491206D9;
        Tue, 24 Nov 2020 23:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606259257;
        bh=utPGT6bYeWdE0Bd3zt35luqhmW0HdbJ1ldBnmbIGTZY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vlezj0SRB07SwcfPPbtJG7frNuTgxGdCDyozhCHxXz5QkW9NjPAPNeTwR8Z3DOBDe
         Jx28FnM/UHgSTe26i5AQQq30DaelBENaAp4HaEqtWu18OXHYzpwu7ksvPBEj9SJeGq
         33SBeXL5d7EuV872PkNCsq3+/DhlPvfaYnoJP1uA=
Date:   Tue, 24 Nov 2020 15:07:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     stefanc@marvell.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, mw@semihalf.com, andrew@lunn.ch
Subject: Re: [PATCH v2] net: mvpp2: divide fifo for dts-active ports only
Message-ID: <20201124150735.2f12b8c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123201715.GZ1551@shell.armlinux.org.uk>
References: <1606154073-28267-1-git-send-email-stefanc@marvell.com>
        <20201123201715.GZ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 20:17:15 +0000 Russell King - ARM Linux admin wrote:
> On Mon, Nov 23, 2020 at 07:54:33PM +0200, stefanc@marvell.com wrote:
> > From: Stefan Chulski <stefanc@marvell.com>
> > 
> > Tx/Rx FIFO is a HW resource limited by total size, but shared
> > by all ports of same CP110 and impacting port-performance.
> > Do not divide the FIFO for ports which are not enabled in DTS,
> > so active ports could have more FIFO.
> > No change in FIFO allocation if all 3 ports on the communication
> > processor enabled in DTS.
> > 
> > The active port mapping should be done in probe before FIFO-init.
> > 
> > Signed-off-by: Stefan Chulski <stefanc@marvell.com>  
> 
> Thanks.
> 
> Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> One thing I didn't point out is that netdev would like patch submissions
> to indicate which tree they are targetting. Are you intending this for
> net or net-next?
> 
> [PATCH net vX] ...
> 
> or
> 
> [PATCH net-next vX] ...
> 
> in the subject line please.

I'll assume Stefan does not know :) This patches does not appear to
fix a bug or other user-visible issue, so applying to net-next, it 
will be part of the next Linux release (5.11) and not queued to LTS.

Thanks!
