Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B137155D22
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgBGRqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:46:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45386 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgBGRqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:46:33 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53B0115B26295;
        Fri,  7 Feb 2020 09:46:31 -0800 (PST)
Date:   Fri, 07 Feb 2020 18:46:29 +0100 (CET)
Message-Id: <20200207.184629.2031351294269270096.davem@davemloft.net>
To:     codrin.ciubotariu@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        razvan.stefanescu@microchip.com
Subject: Re: [PATCH v3] net: dsa: microchip: enable module autoprobe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200207154404.1093-1-codrin.ciubotariu@microchip.com>
References: <20200207154404.1093-1-codrin.ciubotariu@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 09:46:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Date: Fri, 7 Feb 2020 17:44:04 +0200

> From: Razvan Stefanescu <razvan.stefanescu@microchip.com>
> 
> This matches /sys/devices/.../spi1.0/modalias content.
> 
> Fixes: 9b2d9f05cddf ("net: dsa: microchip: add ksz9567 to ksz9477 driver")
> Fixes: d9033ae95cf4 ("net: dsa: microchip: add KSZ8563 compatibility string")
> Fixes: 8c29bebb1f8a ("net: dsa: microchip: add KSZ9893 switch support")
> Fixes: 45316818371d ("net: dsa: add support for ksz9897 ethernet switch")
> Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
> Signed-off-by: Razvan Stefanescu <razvan.stefanescu@microchip.com>
> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied and queued up for -stable, thank you.
