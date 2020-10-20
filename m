Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B361F2943F8
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 22:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409563AbgJTUhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 16:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409556AbgJTUhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 16:37:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8816F2224A;
        Tue, 20 Oct 2020 20:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603226258;
        bh=XBAXsJHUIh/+mN7SPuRDyEtONViRC+xODcGlgkYavhs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d7vR50K2xNLEXigSR6Frzb+C625m+1+FGiXuZmFRBMN1q5EhhXx2s+itZpOJfMBKy
         tmKTjd79POBrhA9xwn8f46h67fIolwcRsXuLTfMVg0lNZ4gy7CFIBMLJfdPzmlCYq1
         ypCJg32++eRsqgayiVnCeW9O1uvU6ynExv+5TcYU=
Date:   Tue, 20 Oct 2020 13:37:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        vinicius.gomes@intel.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, alexandre.belloni@bootlin.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com, mingkai.hu@nxp.com
Subject: Re: [PATCH v1 net-next 0/5] net: dsa: felix: psfp support on
Message-ID: <20201020133732.035d8df4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
References: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 15:23:16 +0800 Xiaoliang Yang wrote:
> This patch series add gate and police action for tc flower offload to
> support Per-Stream Filtering and Policing(PSFP), which is defined in
> IEEE802.1Qci.
> 
> There is also a TC flower offload to set up VCAPs on ocelot driver.
> Because VCAPs use chain 10000-21255, we set chain 30000 to offload to
> gate and police action to run PSFP module.

We have already sent a pull request for 5.10 and therefore net-next 
is closed for new drivers, features, and code refactoring.

Please repost when net-next reopens after 5.10-rc1 is cut.

(http://vger.kernel.org/~davem/net-next.html will not be up to date 
 this time around, sorry about that).

RFC patches sent for review only are obviously welcome at any time.
