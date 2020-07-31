Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7629823487F
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 17:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgGaPbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 11:31:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37108 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbgGaPbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 11:31:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k1X0B-007iQT-KN; Fri, 31 Jul 2020 17:31:19 +0200
Date:   Fri, 31 Jul 2020 17:31:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vikas Singh <vikas.singh@puresoftware.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Kuldip Dwivedi <kuldip.dwivedi@puresoftware.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Vikas Singh <vikas.singh@nxp.com>
Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Message-ID: <20200731153119.GJ1712415@lunn.ch>
References: <1595938400-13279-1-git-send-email-vikas.singh@puresoftware.com>
 <1595938400-13279-3-git-send-email-vikas.singh@puresoftware.com>
 <20200728130001.GB1712415@lunn.ch>
 <CADvVLtXVVfU3-U8DYPtDnvGoEK2TOXhpuE=1vz6nnXaFBA8pNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvVLtXVVfU3-U8DYPtDnvGoEK2TOXhpuE=1vz6nnXaFBA8pNA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 07:34:19PM +0530, Vikas Singh wrote:
> Hi Andrew,
> 
> I understand your concern But my use case is pretty simple and straightforward.
> As you are already aware of the fact that operating systems running on standard
> server hardware requires standard firmware interfaces to be present in order to
> boot
> and function correctly.
> Here SBBR describes these firmware requirements which covers UEFI & ACPI.
> Therefore I would like to provide dual boot support to such systems which means
> supporting ACPI along with existing DT.
> Now kernels "__fixed_phy_registe() " being a wonderful implementation catters
> almost every thing required for both ACPI & DT
> But fails to register fixed PHYs in case of ACPI because it has no clue of the
> fwnode (of_node in case of DT) to attach with a PHY device.

You failed to answer my question. Why do you need a fixed PHY? Please
could you point me at your DT files so i can at least understand your
hardware.

	Andrew
