Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B582B09BA
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgKLQTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:19:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51208 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbgKLQS7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 11:18:59 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kdFJC-006gUO-9A; Thu, 12 Nov 2020 17:18:50 +0100
Date:   Thu, 12 Nov 2020 17:18:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, Nicolas Pitre <nico@fluxnic.net>,
        Jakub Kicinski <kuba@kernel.org>, Erik Stahlman <erik@vt.edu>,
        Peter Cammaert <pc@denkart.be>,
        Daris A Nevil <dnevil@snmc.com>,
        Russell King <rmk@arm.linux.org.uk>, netdev@vger.kernel.org
Subject: Re: [PATCH 30/30] net: ethernet: smsc: smc91x: Mark 'pkt_len' as
 __maybe_unused
Message-ID: <20201112161850.GC1456319@lunn.ch>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
 <20201102114512.1062724-31-lee.jones@linaro.org>
 <20201112100658.GB1997862@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112100658.GB1997862@dell>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This one is still lingering.  Looks like it's still relevant.

Hi Lee

It is part of this patchset:

https://www.mail-archive.com/netdev@vger.kernel.org/msg368589.html

	Andrew
