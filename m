Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF403ABC1
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 22:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbfFIUVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 16:21:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45362 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729084AbfFIUVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 16:21:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D8BA614DF1DB3;
        Sun,  9 Jun 2019 13:21:15 -0700 (PDT)
Date:   Sun, 09 Jun 2019 13:21:15 -0700 (PDT)
Message-Id: <20190609.132115.2294161372213194210.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH V2 net-next 00/12] net: hns3: some code optimizations &
 cleanups & bugfixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
References: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 13:21:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Fri, 7 Jun 2019 10:03:01 +0800

> This patch-set includes code optimizations, cleanups and bugfixes for
> the HNS3 ethernet controller driver.

Series applied, thanks.
