Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1DDC37F72
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfFFVVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:21:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58044 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfFFVVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:21:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60C7E14E226CD;
        Thu,  6 Jun 2019 14:21:31 -0700 (PDT)
Date:   Thu, 06 Jun 2019 14:21:30 -0700 (PDT)
Message-Id: <20190606.142130.1667416969493399525.davem@davemloft.net>
To:     dinguyen@kernel.org
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        dalon.westergreen@intel.com
Subject: Re: [PATCH 2/2] net: stmmac: socfpga: fix phy and ptp_ref setup
 for Arria10/Stratix10
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190605150551.12791-2-dinguyen@kernel.org>
References: <20190605150551.12791-1-dinguyen@kernel.org>
        <20190605150551.12791-2-dinguyen@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 14:21:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>
Date: Wed,  5 Jun 2019 10:05:51 -0500

> On the Arria10, Agilex, and Stratix10 SoC, there are a few differences from
> the Cyclone5 and Arria5:
>  - The emac PHY setup bits are in separate registers.
>  - The PTP reference clock select mask is different.
>  - The register to enable the emac signal from FPGA is different.
> 
> Thus, this patch creates a separate function for setting the phy modes on
> Arria10/Agilex/Stratix10. The separation is based a new DTS binding:
> "altr,socfpga-stmmac-a10-s10".
> 
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>

Applied to net-next.
