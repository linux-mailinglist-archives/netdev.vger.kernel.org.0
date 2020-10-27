Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F4429AC58
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900176AbgJ0Ml4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:41:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47198 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900103AbgJ0Mlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 08:41:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXOI6-003nNe-Mu; Tue, 27 Oct 2020 13:41:30 +0100
Date:   Tue, 27 Oct 2020 13:41:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v3 14/32] net: phy: remove kernel-doc duplication
Message-ID: <20201027124130.GB904240@lunn.ch>
References: <cover.1603791716.git.mchehab+huawei@kernel.org>
 <75e9a357f9a716833d2094b04898754876365e68.1603791716.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75e9a357f9a716833d2094b04898754876365e68.1603791716.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 10:51:18AM +0100, Mauro Carvalho Chehab wrote:
> Sphinx 3 now checks for duplicated function declarations:
> 
> 	.../Documentation/networking/kapi:143: ../include/linux/phy.h:163: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
> 	Declaration is 'unsigned int phy_supported_speeds (struct phy_device *phy, unsigned int *speeds, unsigned int size)'.
> 	.../Documentation/networking/kapi:143: ../include/linux/phy.h:1034: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
> 	Declaration is 'int phy_read_mmd (struct phy_device *phydev, int devad, u32 regnum)'.
> 	.../Documentation/networking/kapi:143: ../include/linux/phy.h:1076: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
> 	Declaration is 'int __phy_read_mmd (struct phy_device *phydev, int devad, u32 regnum)'.
> 	.../Documentation/networking/kapi:143: ../include/linux/phy.h:1088: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
> 	Declaration is 'int phy_write_mmd (struct phy_device *phydev, int devad, u32 regnum, u16 val)'.
> 	.../Documentation/networking/kapi:143: ../include/linux/phy.h:1100: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
> 	Declaration is 'int __phy_write_mmd (struct phy_device *phydev, int devad, u32 regnum, u16 val)'.
> 
> It turns that both the C and the H files have the same
> kernel-doc markup for the same functions. Let's drop the
> at the header file, keeping the one closer to the code.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
