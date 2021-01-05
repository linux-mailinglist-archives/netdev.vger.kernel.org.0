Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A813F2EADBE
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbhAEOzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:55:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50288 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbhAEOzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:55:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwnj7-00GBNf-Pw; Tue, 05 Jan 2021 15:54:25 +0100
Date:   Tue, 5 Jan 2021 15:54:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "leoyang.li@nxp.com" <leoyang.li@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "murali.policharla@broadcom.com" <murali.policharla@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "qiang.zhao@nxp.com" <qiang.zhao@nxp.com>
Subject: Re: [PATCH 01/20] ethernet: ucc_geth: set dev->max_mtu to 1518
Message-ID: <X/R9oWNNxkY2pTC6@lunn.ch>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205191744.7847-2-rasmus.villemoes@prevas.dk>
 <20201210012502.GB2638572@lunn.ch>
 <33816fa937efc8d4865d95754965e59ccfb75f2c.camel@infinera.com>
 <X/R4tqny72Bjt28b@lunn.ch>
 <6c56889ce3d0e9fc7a6ca7e7a43091b1ae8cd309.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c56889ce3d0e9fc7a6ca7e7a43091b1ae8cd309.camel@infinera.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew
> 
> I found here: 
> https://patchwork.kernel.org/project/netdevbpf/patch/20201218105538.30563-2-rasmus.villemoes@prevas.dk/
> 
> Seem to be underway but stable isn't included, I think it should be.

Stable should happen, since this was posted with [net,v2,3/3]. David
or Jakub handles stable for netdev. Give it a few more days. If not,
ask Jakub what is happening.

    Andrew
