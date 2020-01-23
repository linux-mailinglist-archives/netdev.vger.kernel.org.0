Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBD31464E6
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 10:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgAWJvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 04:51:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55918 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728799AbgAWJvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 04:51:20 -0500
Received: from localhost (unknown [185.13.106.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4199B153D1F49;
        Thu, 23 Jan 2020 01:51:08 -0800 (PST)
Date:   Thu, 23 Jan 2020 10:49:58 +0100 (CET)
Message-Id: <20200123.104958.2192934942627784465.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, mripard@kernel.org,
        wens@csie.org, opendmb@gmail.com, pantelis.antoniou@gmail.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com, vz@mleia.com,
        slemieux.tyco@gmail.com, timur@kernel.org,
        sergei.shtylyov@cogentembedded.com, steve.glendinning@shawell.net,
        michal.simek@xilinx.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-renesas-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: convert suitable drivers to use
 phy_do_ioctl_running
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2db5d899-a550-456d-a725-f7cf009f53a3@gmail.com>
References: <2db5d899-a550-456d-a725-f7cf009f53a3@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 01:51:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 21 Jan 2020 22:09:33 +0100

> Convert suitable drivers to use new helper phy_do_ioctl_running.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> v2: I forgot the netdev mailing list

Applied to net-next.
