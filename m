Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A6E14F11A
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 18:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgAaRKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 12:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbgAaRKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 12:10:05 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13CD9206D5;
        Fri, 31 Jan 2020 17:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580490605;
        bh=4Ca/p9eaun/fjwm17b1QdTDYvF3FekqAh2W9nVCEcTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jx7LEo+pnyxcvs482GuASR8tSjvD5I8+37EAetaUWSd41CuobJ+9QFTk3n/Fj/guK
         ckENUrlTtSiyFIDgCbBskOPaG+ckOrSTDXhI8SVGBNhWFctWXUQgdPW8f6Oiv0ZBuY
         SHr9bU+u4VC3QJcDMEDdFtHBrnuTAH5pYvT3f8sc=
Date:   Fri, 31 Jan 2020 09:10:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <bunk@kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>
Subject: Re: [PATCH net-master 1/1] net: phy: dp83867: Add speed
 optimization feature
Message-ID: <20200131091004.18d54183@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200131151110.31642-2-dmurphy@ti.com>
References: <20200131151110.31642-1-dmurphy@ti.com>
        <20200131151110.31642-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 09:11:10 -0600, Dan Murphy wrote:
> Set the speed optimization bit on the DP83867 PHY.
> This feature can also be strapped on the 64 pin PHY devices
> but the 48 pin devices do not have the strap pin available to enable
> this feature in the hardware.  PHY team suggests to have this bit set.
> 
> With this bit set the PHY will auto negotiate and report the link
> parameters in the PHYSTS register and not in the BMCR.  So we need to
> over ride the genphy_read_status with a DP83867 specific read status.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

While we wait for the PHY folk to take a look, could you please 
provide a Fixes tag?
