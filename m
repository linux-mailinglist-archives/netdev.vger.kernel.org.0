Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9A7280006
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 15:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732280AbgJANXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 09:23:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731993AbgJANXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 09:23:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNyYc-00H4MM-Jd; Thu, 01 Oct 2020 15:23:38 +0200
Date:   Thu, 1 Oct 2020 15:23:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        devicetree@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: Re: [PATCH v3 devicetree 1/2] powerpc: dts: t1040: add bindings for
 Seville Ethernet switch
Message-ID: <20201001132338.GE4067422@lunn.ch>
References: <20201001132013.1866299-1-vladimir.oltean@nxp.com>
 <20201001132013.1866299-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001132013.1866299-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 04:20:12PM +0300, Vladimir Oltean wrote:
> Add the description of the embedded L2 switch inside the SoC dtsi file
> for NXP T1040.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
