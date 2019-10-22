Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90973E023C
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 12:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731850AbfJVKjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 06:39:42 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41508 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731754AbfJVKjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 06:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l24xzMFlpyV1/9eK1jyafcSeP6crPrVA4lJ5XbfSSKY=; b=Ln9wB6rFjQKenm7biqmrC1SFy
        ikSW2/uj+staszMo1ZcHMLnd7N2HkGHgPJQv5GAxV6uI9A+lFIgyhinN+SafpDJPr1Lx1TLb+yMu4
        eINnUnGtrDToGTObRkinAv+mYrwaXG2zJ+a8E7v5oUodtLn+SfXG1pZ//GTTKW4UgoSKSOh8OWRMf
        QvO4K3cmtKesbhkhf6OEnM5AqKq9/W4JU83DnLqnDrS+xa/3tnP8p3MZN+Tcs1Qkrpd0o5+Lt4WLM
        HCw2QXQfgzvzE2BoV8c9rg4seWsgmCQGWxSjYtHJlvlCNG+4vawXL3fkX9I14vumObudfnrZ0cCxD
        Klr4Y/Kkw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:45938)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iMrZg-0006db-88; Tue, 22 Oct 2019 11:39:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iMrZc-0004VW-65; Tue, 22 Oct 2019 11:39:32 +0100
Date:   Tue, 22 Oct 2019 11:39:32 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 3/4] dpaa2-eth: add MAC/PHY support through
 phylink
Message-ID: <20191022103932.GS25745@shell.armlinux.org.uk>
References: <1571698228-30985-1-git-send-email-ioana.ciornei@nxp.com>
 <1571698228-30985-4-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571698228-30985-4-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 01:50:27AM +0300, Ioana Ciornei wrote:
> +	mac->phylink_config.dev = &net_dev->dev;
> +	mac->phylink_config.type = PHYLINK_NETDEV;
> +
> +	phylink = phylink_create(&mac->phylink_config,
> +				 of_fwnode_handle(dpmac_node), mac->if_mode,
> +				 &dpaa2_mac_phylink_ops);

Does this mean we didn't need to go through the removal of netdev from
phylink after all?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
