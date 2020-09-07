Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFFE2605CD
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 22:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgIGUjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 16:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbgIGUjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 16:39:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2DF621556;
        Mon,  7 Sep 2020 20:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599511159;
        bh=MJCDlbZVjFXDweVbafndYKQCuv0J0EE/gY2hOM4Q2pQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AD98mbgsUcRpyiMVAmsAWCu/HD6K385Q7YaxxowbIujMUfcKmgk0Yq78Np7z2kZ6T
         8NsIjcXW6m1gP2Qt14Bk74VVbtvDw6xh7l5XGvz+8jdMuZFyoEZz3mwCUNv4aBq/lR
         YdxEnyvi80z/PXhRPkruPFhw9TivA1vIig6uxrtA=
Date:   Mon, 7 Sep 2020 13:39:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: xilinx: remove redundant null check
 before clk_disable_unprepare()
Message-ID: <20200907133917.0dd18fc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BYAPR02MB5638CE555F06629B3EC83043C7280@BYAPR02MB5638.namprd02.prod.outlook.com>
References: <1599483723-43704-1-git-send-email-zhangchangzhong@huawei.com>
        <BYAPR02MB5638CE555F06629B3EC83043C7280@BYAPR02MB5638.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 13:14:05 +0000 Radhey Shyam Pandey wrote:
> > From: Zhang Changzhong <zhangchangzhong@huawei.com>
> > Sent: Monday, September 7, 2020 6:32 PM
> > To: Radhey Shyam Pandey <radheys@xilinx.com>; davem@davemloft.net;
> > kuba@kernel.org; Michal Simek <michals@xilinx.com>
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: [PATCH net-next] net: xilinx: remove redundant null check before
> > clk_disable_unprepare()
> > 
> > Because clk_prepare_enable() and clk_disable_unprepare() already checked
> > NULL clock parameter, so the additional checks are unnecessary, just
> > remove them.
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>  
> 
> Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Applied, thanks!
