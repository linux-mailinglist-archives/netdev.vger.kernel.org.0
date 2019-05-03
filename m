Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19B413018
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfECO0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:26:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfECO0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 10:26:45 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B6CF514B666DF;
        Fri,  3 May 2019 07:26:43 -0700 (PDT)
Date:   Fri, 03 May 2019 10:26:39 -0400 (EDT)
Message-Id: <20190503.102639.682620225620762896.davem@davemloft.net>
To:     nicolas.ferre@microchip.com
Cc:     claudiu.beznea@microchip.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, michal.simek@xilinx.com,
        harini.katakam@xilinx.com
Subject: Re: [PATCH] net: macb: remove redundant struct phy_device
 declaration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190503103628.17160-1-nicolas.ferre@microchip.com>
References: <20190503103628.17160-1-nicolas.ferre@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 07:26:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>
Date: Fri, 3 May 2019 12:36:28 +0200

> While moving the chunk of code during 739de9a1563a
> ("net: macb: Reorganize macb_mii bringup"), the declaration of
> struct phy_device declaration was kept. It's not useful in this
> function as we alrady have a phydev pointer.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Applied.
