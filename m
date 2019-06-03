Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D12D33B6A
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfFCWdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:33:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36552 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfFCWdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:33:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99F6F1008E061;
        Mon,  3 Jun 2019 15:33:04 -0700 (PDT)
Date:   Mon, 03 Jun 2019 15:33:04 -0700 (PDT)
Message-Id: <20190603.153304.1766806861299562591.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH V2 net-next 00/10] code optimizations & bugfixes for
 HNS3 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559527762-22931-1-git-send-email-tanhuazhong@huawei.com>
References: <1559527762-22931-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 15:33:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Mon, 3 Jun 2019 10:09:12 +0800

> This patch-set includes code optimizations and bugfixes for the HNS3
> ethernet controller driver.
> 
> [patch 1/10] removes the redundant core reset type
> 
> [patch 2/10 - 3/10] fixes two VLAN related issues
> 
> [patch 4/10] fixes a TM issue
> 
> [patch 5/10 - 10/10] includes some patches related to RAS & MSI-X error
> 
> Change log:
> V1->V2: removes two patches which needs to change HNS's infiniband
> 	driver as well, they will be upstreamed later with the
> 	infiniband's one.

Applied, thanks.
