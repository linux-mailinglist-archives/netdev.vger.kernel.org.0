Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C388318C27
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 14:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhBKNfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 08:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbhBKNc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 08:32:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67818C061574;
        Thu, 11 Feb 2021 05:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=D9CHTW+hSrLJ+MTxUD49Vye2O/Qwq/6hLfOIDMtGZF8=; b=NGqXU4aN88igflHdBTGwsWyzO
        SOdOHOGSupIcIWlGuRrdrmtM/vy/5Ek7IXlXpJ9DXLVHsj8TAXx0Z7gvIQLqzNbgUEbZDBUO82OPC
        FnlzmaPbI9uI9Vg/ZIXmhL3Z+0CFWEq9ap9EoZy+ZtUzXsf1dHhJesT70paAXDXkUVKI7mCugi4z9
        GrVN23MNbTlmjE0cq6wUvm2VvCoTzDlta5K9zjqdbHFcu3lZTT3a4sSIVO60BGeOeEK3xCYNjcVDi
        U/6EwrQ6MMjElPGPn6HHuYnNy8EOZ0ztodsxDRrLH2HIsGCIY1ZBgOpcfGDxm2GBkiXyZ7VnnTqIK
        sySJupWkg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42052)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lAC4M-0006Dh-L7; Thu, 11 Feb 2021 13:31:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lAC4L-00068W-P3; Thu, 11 Feb 2021 13:31:41 +0000
Date:   Thu, 11 Feb 2021 13:31:41 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v13 net-next 08/15] net: mvpp2: add FCA RXQ non
 occupied descriptor threshold
Message-ID: <20210211133141.GK1463@shell.armlinux.org.uk>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-9-git-send-email-stefanc@marvell.com>
 <20210211125009.GF1463@shell.armlinux.org.uk>
 <CO6PR18MB387356072132F306EBB1C9C2B08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB387356072132F306EBB1C9C2B08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 01:22:35PM +0000, Stefan Chulski wrote:
> > Ditto.
> > 
> > I don't think these need to be fixed in the net tree, but it would still be nice
> > to fix the problem. Please do so, as an initial patch in your series - so we can
> > then backport if it turns out to eventually be necessary.
> > 
> > Thanks.
> 
> My series already has 15 patches and patchwork not happy about series with over 15 patches.
> Maybe I can send this as separate patch to net-next(or net) first and base this series on this net-next tree with this patch?

In that case, send the fixes as a separate series and get that merged
first. It shouldn't take very long to get the fixes merged.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
