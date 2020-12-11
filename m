Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949182D7C84
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391813AbgLKRKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:10:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51052 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730528AbgLKRKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 12:10:18 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1knlvB-00BSlB-On; Fri, 11 Dec 2020 18:09:33 +0100
Date:   Fri, 11 Dec 2020 18:09:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        mcroce@microsoft.com, sven.auhagen@voleatech.de
Subject: Re: [PATCH v2] MAINTAINERS: add mvpp2 driver entry
Message-ID: <20201211170933.GM2638572@lunn.ch>
References: <20201211165114.26290-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211165114.26290-1-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 05:51:14PM +0100, Marcin Wojtas wrote:
> Since its creation Marvell NIC driver for Armada 375/7k8k and
> CN913x SoC families mvpp2 has been lacking an entry in MAINTAINERS,
> which sometimes lead to unhandled bugs that persisted
> across several kernel releases.
> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>

Acked-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
