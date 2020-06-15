Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9901F9D96
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 18:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbgFOQhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 12:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729772AbgFOQhM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 12:37:12 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B4BC20679;
        Mon, 15 Jun 2020 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592239032;
        bh=9Mx52TqWdSdCtob3kgWa+UGpxsKlsgGNC4QVbFr/2C8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MS5MmHRgg8f/hL8ShHv5g2bXO0qRAlHuebcMBuBfe8IRrGfU8tnxCxBC+vfthIuCj
         e/EiwUh+YGoK4HSQxNbA0v2qisJERNpkJKqCSs9hbq2EqygZUf7HDcDVod/YhwUTHT
         hbh4BU+X2/FTflDwJF/upEVEx75sMWLGpCVnRb4g=
Date:   Mon, 15 Jun 2020 09:37:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] MAINTAINERS: merge entries for felix and ocelot
 drivers
Message-ID: <20200615093710.2d5e931e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200613220753.948166-1-olteanv@gmail.com>
References: <20200613220753.948166-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 14 Jun 2020 01:07:53 +0300 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The ocelot switchdev driver also provides a set of library functions for
> the felix DSA driver, which in practice means that most of the patches
> will be of interest to both groups of driver maintainers.
> 
> So, as also suggested in the discussion here, let's merge the 2 entries
> into a single larger one:
> https://www.spinics.net/lists/netdev/msg657412.html
> 
> Note that the entry has been renamed into "OCELOT SWITCH" since neither
> Vitesse nor Microsemi exist any longer as company names, instead they
> are now named Microchip (which again might be subject to change in the
> future), so use the device family name instead.
> 
> Suggested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Looks like checkpatch is unhappy about the order of files?

WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#58: FILE: MAINTAINERS:12308:
+F:	include/soc/mscc/ocelot*
+F:	drivers/net/ethernet/mscc/

WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#59: FILE: MAINTAINERS:12309:
+F:	drivers/net/ethernet/mscc/
+F:	drivers/net/dsa/ocelot/*

total: 0 errors, 2 warnings, 0 checks, 46 lines checked
