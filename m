Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327282FDACE
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733157AbhATU1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:27:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50038 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387919AbhATN5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 08:57:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l2DyY-001epm-Dx; Wed, 20 Jan 2021 14:56:46 +0100
Date:   Wed, 20 Jan 2021 14:56:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <YAg2ngUQIty8U36l@lunn.ch>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch>
 <20210119115610.GZ3565223@nanopsycho.orion>
 <YAbyBbEE7lbhpFkw@lunn.ch>
 <20210120083605.GB3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120083605.GB3565223@nanopsycho.orion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> No, the FW does not know. The ASIC is not physically able to get the
> linecard type. Yes, it is odd, I agree. The linecard type is known to
> the driver which operates on i2c. This driver takes care of power
> management of the linecard, among other tasks.

So what does activated actually mean for your hardware? It seems to
mean something like: Some random card has been plugged in, we have no
idea what, but it has power, and we have enabled the MACs as
provisioned, which if you are lucky might match the hardware?

The foundations of this feature seems dubious.

    Andrew
