Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E371294D7
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 12:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfLWLKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 06:10:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38054 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbfLWLKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 06:10:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tBB2+h5a9ut+dDBSWF0v9H6PyQlOx+QMXbp/30kZwSM=; b=ArfCyL8iEY3A5DioT9p89u2LxM
        XOy3mPXAr4L/cECxMDfrlzoWVNr4H4nWhXSW/n/ZjNRw5PZMsooOeZe2/24my5YATsP23ubl9ZUYT
        SgkzH1YLx2cw5NVJfC0WrWX8JIF9GdiiG5u9/6KsFPEuDhhz1BLdAJsfLKcgjZSJpumI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ijLbc-00022R-I9; Mon, 23 Dec 2019 12:10:32 +0100
Date:   Mon, 23 Dec 2019 12:10:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Madalin Bucur <madalin.bucur@oss.nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        shawnguo@kernel.org, leoyang.li@nxp.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, Madalin Bucur <madalin.bucur@nxp.com>
Subject: Re: [PATCH net-next v2 1/7] net: phy: add interface modes for XFI,
 SFI
Message-ID: <20191223111032.GI32356@lunn.ch>
References: <1577096053-20507-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1577096053-20507-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191223105743.GN25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191223105743.GN25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 10:57:43AM +0000, Russell King - ARM Linux admin wrote:
> On Mon, Dec 23, 2019 at 12:14:07PM +0200, Madalin Bucur wrote:
> > From: Madalin Bucur <madalin.bucur@nxp.com>
> > 
> > Add explicit entries for XFI, SFI to make sure the device
> > tree entries for phy-connection-type "xfi" or "sfi" are
> > properly parsed and differentiated against the existing
> > backplane 10GBASE-KR mode.
> > 
> > Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
> 
> NAK until we've finished discussing this matter in the previous posting.

Agreed.

Lets fully understand the issues before we start patching stuff.

     Andrew
