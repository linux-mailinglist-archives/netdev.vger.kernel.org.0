Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E0546DCB
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfFOC0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:26:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57436 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFOC03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:26:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7993D1341200A;
        Fri, 14 Jun 2019 19:26:29 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:26:29 -0700 (PDT)
Message-Id: <20190614.192629.1590309153811007708.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH net-next 00/12] net: hns3: some code optimizations &
 cleanups & bugfixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560417152-53050-1-git-send-email-tanhuazhong@huawei.com>
References: <1560417152-53050-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:26:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Thu, 13 Jun 2019 17:12:20 +0800

> This patch-set includes code optimizations, cleanups and bugfixes for
> the HNS3 ethernet controller driver.
> 
> [patch 1/12 - 6/12] adds some code optimizations and bugfixes about RAS
> and MSI-X HW error.
> 
> [patch 7/12] fixes a loading issue.
> 
> [patch 8/12 - 11/12] adds some bugfixes.
> 
> [patch 12/12] adds some cleanups, which does not change the logic of code.

Series applied.
