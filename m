Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6563402D57
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 19:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345391AbhIGRBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 13:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345180AbhIGRBK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 13:01:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EF7960EBA;
        Tue,  7 Sep 2021 17:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631034003;
        bh=wwlWGlgc1Kt0jWuQQ+Z7NUQSVo0eNyUiTRZHhC6q/PY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aDvVZwLu6V/qmAcwq/SwUIiyM9taL9r5uxbS4F10sMy89aHU9h+EUIvsIiXIJ1KfS
         1AxPpHRg1TPkzr/UBtfB3MGqI8vz5coyXMYZsxC5h3nbdT5le0zHWlGaCCd2jV6dEE
         TW3XFpwBzaakwAh/Pp9Pfy8A+zll/qB2BHx94UELmFeF5jOu7SkH4a6bqVrmw/PvFJ
         F2xfY0yM5S3Y2LktCAkqWFDnaadhEM9jA+N7xsulgD+rv2cX5ST1eTERN1Ja+IEPVd
         gqT2sakmkuY/DIv0uITayZFrqdcgbFJaLsNF7wIF0uEAg4AqmuSmEysxkmHA97n3Jc
         NevRge/aVnRjA==
Date:   Tue, 7 Sep 2021 10:00:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        vinicius.gomes@intel.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, alexandre.belloni@bootlin.com, po.liu@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, claudiu.manoil@nxp.com
Subject: Re: [PATCH v4 net-next 0/8] net: dsa: felix: psfp support on
 vsc9959
Message-ID: <20210907100001.5c8a20eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210907090915.17866-1-xiaoliang.yang_1@nxp.com>
References: <20210907090915.17866-1-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Sep 2021 17:09:07 +0800 Xiaoliang Yang wrote:
> VSC9959 hardware supports Per-Stream Filtering and Policing(PSFP).
> This patch series add PSFP support on tc flower offload of ocelot
> driver. Use chain 30000 to distinguish PSFP from VCAP blocks. Add gate
> and police set to support PSFP in VSC9959 driver.

# Form letter - net-next is closed

We have already sent the networking pull request for 5.15
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.15-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
