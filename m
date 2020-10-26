Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EEB2995C1
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 19:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790452AbgJZSvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 14:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790448AbgJZSvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 14:51:07 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A36AB2085B;
        Mon, 26 Oct 2020 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603738267;
        bh=mBN156QVx5rBjqQv/5lb63gbcTQwM7laN0HK5UOcZOk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d53zjYDwb2xg+6RR1spqV6JCL/Xsl8/2SO5CL6UiJTp2Ar0+csre7O5FOy1L9Dlt5
         ddQpGno4D5LiFdF38DiLT7AvID25yPYBdoUR/Hw/M/2ms5L1g0K6Eq2wOz0/my+1M+
         MtPQ2NpHhF4W6MKu+CloPDqAdpunMHfJUeJXPBhE=
Date:   Mon, 26 Oct 2020 11:51:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net] net: mscc: ocelot: populate the entry type in
 ocelot_mact_read
Message-ID: <20201026115105.540ef640@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201026112257.1371229-1-vladimir.oltean@nxp.com>
References: <20201026112257.1371229-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 13:22:57 +0200 Vladimir Oltean wrote:
> Currently this boolean in ocelot_fdb_dump will always be set to false:
> 
> is_static = (entry.type == ENTRYTYPE_LOCKED);
> 
> Fix it by ensuring the entry type is always read from hardware.
> 
> Fixes: 64bfb05b74ad ("net: mscc: ocelot: break out fdb operations into abstract implementations")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Fixes tag: Fixes: 64bfb05b74ad ("net: mscc: ocelot: break out fdb operations into abstract implementations")
Has these problem(s):
	- Target SHA1 does not exist
