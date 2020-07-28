Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1009230ACE
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 15:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgG1NAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 09:00:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59778 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728990AbgG1NAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 09:00:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0PD7-007Hed-45; Tue, 28 Jul 2020 15:00:01 +0200
Date:   Tue, 28 Jul 2020 15:00:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vikas Singh <vikas.singh@puresoftware.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, calvin.johnson@oss.nxp.com,
        kuldip.dwivedi@puresoftware.com, madalin.bucur@oss.nxp.com,
        vikas.singh@nxp.com
Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Message-ID: <20200728130001.GB1712415@lunn.ch>
References: <1595938400-13279-1-git-send-email-vikas.singh@puresoftware.com>
 <1595938400-13279-3-git-send-email-vikas.singh@puresoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595938400-13279-3-git-send-email-vikas.singh@puresoftware.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 05:43:20PM +0530, Vikas Singh wrote:
> This patch will extend "struct fixed_phy_status" by adding new
> "struct device *dev" member entry in it.
> This change will help to handle the fixed phy registration in
> ACPI probe case for fwnodes.

Hi Vikas

Please could you tell us more about your use cases. It seems that
using ACPI on ARM is limited to SBSA/SBSA system. It is not clear to
me why you would need a fixed-link PHY on such a system.

   Andrew
