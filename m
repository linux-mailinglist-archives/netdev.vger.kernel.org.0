Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D824A9AA5
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 15:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357229AbiBDOGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 09:06:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232992AbiBDOGf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 09:06:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VV/8t/Zm8bbs/x699ruo1/49Qn4L2nguXkD80SOF6DM=; b=lLOAwMHESGxU+xBKhWkVTfW12R
        QTp4OSioB23sbvC6nkqJ0ij8eFofSYu/C0qetvrtelPOcjGIb8Vea/GNe4BLXSoWcTCSPBcXauTbt
        XWk9/3uiESdLT53rWsgzPNYXWaIMNyFXaaIP1Hk8gOw7mJJPqMRMj3af5Z99zP+jYw7M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nFzEQ-004HIy-74; Fri, 04 Feb 2022 15:06:34 +0100
Date:   Fri, 4 Feb 2022 15:06:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH 2/2] net: phy: micrel: add Microchip KSZ 9477 to the
 device table
Message-ID: <Yf0y6vFtjHh3S2++@lunn.ch>
References: <20220204133635.296974-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <20220204133635.296974-3-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204133635.296974-3-enguerrand.de-ribaucourt@savoirfairelinux.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 04, 2022 at 02:36:35PM +0100, Enguerrand de Ribaucourt wrote:
> PHY_ID_KSZ9477 was supported but not added to the device table passed to
> MODULE_DEVICE_TABLE.
> 
> Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
