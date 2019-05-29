Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6142D2E7
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfE2AjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:39:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54778 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfE2AjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 20:39:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC71D14010FF9;
        Tue, 28 May 2019 17:39:21 -0700 (PDT)
Date:   Tue, 28 May 2019 17:39:21 -0700 (PDT)
Message-Id: <20190528.173921.1448329544526972425.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH net-next 00/12] code optimizations & bugfixes for HNS3
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
References: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 17:39:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Tue, 28 May 2019 17:02:50 +0800

> This patch-set includes code optimizations and bugfixes for the HNS3
> ethernet controller driver.
> 
> [patch 1/12] fixes a compile warning reported by kbuild test robot.
> 
> [patch 2/12] fixes HNS3_RXD_GRO_SIZE_M macro definition error.
> 
> [patch 3/12] adds a debugfs command to dump firmware information.
> 
> [patch 4/12 - 10/12] adds some code optimizaions and cleanups for
> reset and driver unloading.
> 
> [patch 11/12 - 12/12] adds two bugfixes.

Series applied, thanks.
