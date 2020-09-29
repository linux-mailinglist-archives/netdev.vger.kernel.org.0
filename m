Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B095527D55F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 20:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgI2SCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 14:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727657AbgI2SCv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 14:02:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 036B020848;
        Tue, 29 Sep 2020 18:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601402571;
        bh=xWl5tfRNg2TlRz3K92VyygXJ4olCgL6UbF41GTTh6ds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GV70jr78xv64/Q16QiCksViMoHwgbJc89kBDtwxOQP73k2QewiH1JmSbE/OzgnHQA
         8Q3r5kwTEH2OI2NpqdP6Sj3mV8PjqBhuxyOd5aSqVXONpSqS0dg4CkVTvjdaDQpRmW
         tRpa6XN35z51XttAnz1chUitskyGi2f7d04KJNlM=
Date:   Tue, 29 Sep 2020 11:02:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 0/7] net: hns3: updates for -next
Message-ID: <20200929110248.0b656337@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
References: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020 17:31:58 +0800 Huazhong Tan wrote:
> There are some misc updates for the HNS3 ethernet driver.
> #1 uses the queried BD number as the limit for TSO.
> #2 renames trace event hns3_over_8bd since #1.
> #3 adds UDP segmentation offload support.
> #4 adds RoCE VF reset support.
> #5 is a minor cleanup.
> #6 & #7 add debugfs for device specifications and TQP enable status.

These patches look good to me, but please move away from the command
interface in debugfs and create a file for each thing you may want to
query.
