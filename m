Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDAA195A24
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 16:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgC0PpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 11:45:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34284 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgC0PpD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 11:45:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Pm/asNb1Pns7utlRhHbrECwkl0DqjgsSY9mzrFMWbfc=; b=bPPkVIFbYibgLevFJDBOJPj9z8
        vLZPFE4CZqVSOcg9UstAwQmVVhdcjPIkgLkeDbZiXK3wfVC9q4l/VkbVHndf0uxEA4l3lmnhvUTa6
        pExzEGX0D5qVstXT3yGsZR0Am0t+PtD7PgcCmE+JQHMW7IQuXkJ3EDqm2dN1R+y6Kb/M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHrA8-0002qY-2y; Fri, 27 Mar 2020 16:44:48 +0100
Date:   Fri, 27 Mar 2020 16:44:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florinel Iordache <florinel.iordache@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 2/9] dt-bindings: net: add backplane
 dt bindings
Message-ID: <20200327154448.GK11004@lunn.ch>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-3-git-send-email-florinel.iordache@nxp.com>
 <20200327010411.GM3819@lunn.ch>
 <AM0PR04MB5443185A1236F621B9EC9873FBCC0@AM0PR04MB5443.eurprd04.prod.outlook.com>
 <20200327152849.GP25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327152849.GP25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What worries me is the situation which I've been working on, where
> we want access to the PCS PHYs, and we can't have the PCS PHYs
> represented as a phylib PHY because we may have a copper PHY behind
> the PCS PHY, and we want to be talking to the copper PHY in the
> first instance (the PCS PHY effectivel ybecomes a slave to the
> copper PHY.)

I guess we need to clarify what KR actually means. If we have a
backplane with a MAC on each end, i think modelling it as a PHY could
work.

If however, we have a MAC connected to a backplane, and on the end of
the backplane is a traditional PHY, or an SFP cage, we have problems.
As your point out, we cannot have two PHYs in a chain for one MAC.

But i agree with Russell. We need a general solution of how we deal
with PCSs.

   Andrew
