Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 994C51942E2
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 16:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgCZPTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 11:19:36 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47012 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCZPTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 11:19:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/MPBq9dbDtcQ46yU8ndira/wj+NlA41raAI0dPKWp0U=; b=o2m6/IiQ8Qt52wJyIGSFhZMeU
        kak/PvoRyKdTvVcFwzWU5KhwSVdnvUuf1duZcTcFMMo9zdTt80+rGBE/uA4FBuCIGWitrBaFyA8uN
        K+EOBsLRjB40LsXvIQ9NUdl337jLWT+2t6n9mxeA46GggniPXGPqNt3OXKV56xn4By+SYXDksvGiL
        2cteoYcI6P+TNQoFtTziOEgGnLGXBcdfdk+Vpj2BhZZAoZChZRWGYqLVOvMctuHlkEMGeQ5SMD+YJ
        YGm3wRO9ZoZMqw9JMxFLDgymG5X7iPRWc3ClXBCHAoUKx+ZvOL9m3g+bv2F+SUW87VDqGUsAZxtK7
        +GkVPl2Jg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41658)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jHUI5-00047X-OU; Thu, 26 Mar 2020 15:19:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jHUI4-0003KE-Ti; Thu, 26 Mar 2020 15:19:28 +0000
Date:   Thu, 26 Mar 2020 15:19:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] split phylink PCS operations and add PCS
 support for dpaa2
Message-ID: <20200326151928.GD25745@shell.armlinux.org.uk>
References: <20200326151458.GC25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326151458.GC25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 03:14:58PM +0000, Russell King - ARM Linux admin wrote:
> This series splits the phylink_mac_ops structure so that PCS can be
> supported separately with their own PCS operations, separating them
> from the MAC layer.  This may need adaption later as more users come
> along.

I see I've messed up the subject line on this email, does it matter, or
shall I resend again?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
