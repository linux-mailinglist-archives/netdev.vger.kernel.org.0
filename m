Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63C71A2B38
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfH2X6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:58:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55504 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfH2X6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:58:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69BCC153C952A;
        Thu, 29 Aug 2019 16:58:09 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:58:08 -0700 (PDT)
Message-Id: <20190829.165808.749785938274688937.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH net-next 00/12] net: hns3: add some cleanups and
 optimizations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
References: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 16:58:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Wed, 28 Aug 2019 22:23:04 +0800

> This patch-set includes cleanups, optimizations and bugfix for
> the HNS3 ethernet controller driver.
 ...

Series applied, thanks.
