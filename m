Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953BF2CFC59
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgLESDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:03:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728178AbgLESAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 13:00:38 -0500
Date:   Sat, 5 Dec 2020 09:59:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607191189;
        bh=2XTj98FPwKYrzmdgVAroyFbBlTDM4KyJc/G+XYx1L5s=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=frCgoLvdzjdFmwlMnLFXg2EUZK1aRpWGIxlunb2Yx0PduLElndrQvqORfyMbcZjOY
         sA9u7JB/BbqjGMmWfSlHvzTfuaHo4ffWPpUsFsoskWCcjmrF/BYSL+n0ZpRnsZ84I1
         AXu/7TgwP3/kiOWws2ZiPPHQBV7lzPs5PCujv3IBlUOAsF155AKtB+Ny2sy1wPcAQa
         4vC/DK9p6mCU63qbakVs9iQh6l1Gg/N/ZbcFqczrYkFD330x1sn+sk5M3XOMhFIHBs
         4R0snzIEAY6bW0JT1EVc55C+R8uX42sZU95qU/1ZyZER29WztsTZwKkNIyXBTKX1QC
         YIJx3ks2ohP/w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v1 8/9] igc: Add support for exposing frame
 preemption stats registers
Message-ID: <20201205095948.5e0eba28@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202045325.3254757-9-vinicius.gomes@intel.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
        <20201202045325.3254757-9-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Dec 2020 20:53:24 -0800 Vinicius Costa Gomes wrote:
> Expose the Frame Preemption counters, so the number of
> express/preemptible packets can be monitored by userspace.
> 
> These registers are cleared when read, so the value shown is the
> number of events that happened since the last read.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

You mean expose in a register dump? That's not great user experience..

Are there any stats that the standards mandate?

It'd be great if we could come up with some common set and expose them
via ethtool like the pause frame statistics.
