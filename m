Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6347760DEB
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfGEWj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:39:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43738 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGEWj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:39:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37DC415042882;
        Fri,  5 Jul 2019 15:39:55 -0700 (PDT)
Date:   Fri, 05 Jul 2019 15:39:54 -0700 (PDT)
Message-Id: <20190705.153954.1998560426298381085.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH net-next 0/9] net: hns3: some cleanups & bugfixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
References: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 15:39:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Thu, 4 Jul 2019 22:04:19 +0800

> This patch-set includes cleanups and bugfixes for
> the HNS3 ethernet controller driver.
> 
> [patch 1/9] fixes VF's broadcast promisc mode not enabled after
> initializing.
> 
> [patch 2/9] adds hints for fibre port not support flow control.
> 
> [patch 3/9] fixes a port capbility updating issue.
> 
> [patch 4/9 - 9/9] adds some cleanups for HNS3 driver.

Series applied, thanks.
