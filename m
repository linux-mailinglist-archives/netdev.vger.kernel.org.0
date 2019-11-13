Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 562ADFB910
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfKMToY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:44:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfKMToY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 14:44:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D3AC153EE9C2;
        Wed, 13 Nov 2019 11:44:23 -0800 (PST)
Date:   Wed, 13 Nov 2019 11:44:22 -0800 (PST)
Message-Id: <20191113.114422.941795677652250.davem@davemloft.net>
To:     radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, michal.simek@xilinx.com,
        anirudha.sarangi@xilinx.com, john.linn@xilinx.com,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        nicolas.ferre@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jakub.kicinski@netronome.com
Subject: Re: [PATCH v3 net-next] net: axienet: In kconfig remove arch
 dependency for axi_emac
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573622483-2033-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1573622483-2033-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 11:44:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Date: Wed, 13 Nov 2019 10:51:23 +0530

> To enable xilinx axi_emac driver support on zynqmp ultrascale platform
> (ARCH64) there are two choices, mention ARCH64 as a dependency list
> and other is to check if this ARCH dependency list is really needed.
> Later approach seems more reasonable, so remove the obsolete ARCH
> dependency list for the axi_emac driver.
> 
> Sanity test done for microblaze, zynq and zynqmp ultrascale platform.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Applied.
