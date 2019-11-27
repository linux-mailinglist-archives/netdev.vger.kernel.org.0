Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A872710A8C5
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 03:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfK0CbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 21:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbfK0CbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Nov 2019 21:31:07 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 649062071A;
        Wed, 27 Nov 2019 02:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574821866;
        bh=LG1iGHju7sDo59Qem5ol1WR6GrmrIEbPYdzCn849FA4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s5MtTm6ge6K4PXI95CvI7znApSIwXztf9gKnzp54xRtYQYKAYv/siOLbeTAQNs+cu
         GQYZyjUSOr7J/+Nof5IaPCuzKmBnz6rmOUyeOm9/Y5G3sziVT1i8uItbslJS7KJO8j
         68xlEGuQ5Rfstsho/Q5UaksavmIfYNL8fF0nnDK4=
Date:   Tue, 26 Nov 2019 21:31:05 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Adrian Bunk <bunk@kernel.org>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        Max Uvarov <muvarov@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [4.14/4.19 patch 1/2] net: phy: dp83867: fix speed 10 in sgmii
 mode
Message-ID: <20191127023105.GP5861@sasha-vm>
References: <20191126140406.6451-1-bunk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191126140406.6451-1-bunk@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 04:04:05PM +0200, Adrian Bunk wrote:
>From: Max Uvarov <muvarov@gmail.com>
>
>Commit 333061b924539c0de081339643f45514f5f1c1e6 upstream.
>
>For supporting 10Mps speed in SGMII mode DP83867_10M_SGMII_RATE_ADAPT bit
>of DP83867_10M_SGMII_CFG register has to be cleared by software.
>That does not affect speeds 100 and 1000 so can be done on init.
>
>Signed-off-by: Max Uvarov <muvarov@gmail.com>
>Cc: Heiner Kallweit <hkallweit1@gmail.com>
>Cc: Florian Fainelli <f.fainelli@gmail.com>
>Cc: Andrew Lunn <andrew@lunn.ch>
>Signed-off-by: David S. Miller <davem@davemloft.net>
>[ adapted for kernels without phy_modify_mmd ]
>Signed-off-by: Adrian Bunk <bunk@kernel.org>
>---
>- already in 5.3
>- applies and builds against 4.14 and 4.19
>- tested with 4.14

Looks like Greg took these in, thanks!

-- 
Thanks,
Sasha
