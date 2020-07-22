Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CF32299F3
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbgGVOWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:22:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49150 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728351AbgGVOWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 10:22:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jyFdA-006LKs-Ki; Wed, 22 Jul 2020 16:22:00 +0200
Date:   Wed, 22 Jul 2020 16:22:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vikas Singh <vikas.singh@puresoftware.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuldip.dwivedi@puresoftware.com,
        calvin.johnson@oss.nxp.com, madalin.bucur@oss.nxp.com,
        vikas.singh@nxp.com
Subject: Re: [PATCH] net: Phy: Add PHY lookup support on MDIO bus in case of
 ACPI probe
Message-ID: <20200722142200.GZ1339445@lunn.ch>
References: <1595416934-18709-1-git-send-email-vikas.singh@puresoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595416934-18709-1-git-send-email-vikas.singh@puresoftware.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> *Disclaimer* -The information transmitted is intended solely for the
> individual or entity to which it is addressed and may contain
> confidential and/or privileged material. Any review,
> re-transmission, dissemination or other use of or taking action in
> reliance upon this information by persons or entities other than the
> intended recipient is prohibited. If you have received this email in
> error please contact the sender and delete the material from any
> computer.

I.m going to partially ignore this request to delete your email...

This patch is dependent on

Calvin Johnson  [net-next PATCH v7 0/6]  ACPI support for dpaa2 MAC driver.

which is stuck in limbo waiting for an ACPI maintainer to ACK/NACK it.
I've also had off list suggestions it should be NACKed. If it does get
NACKed, it makes this patch pointless.

	Andrew
