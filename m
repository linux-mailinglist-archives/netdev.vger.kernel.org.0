Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84A3C2AC11
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 22:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfEZU1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 16:27:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45956 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfEZU1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 16:27:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2EA42141A910D;
        Sun, 26 May 2019 13:27:03 -0700 (PDT)
Date:   Sun, 26 May 2019 13:27:02 -0700 (PDT)
Message-Id: <20190526.132702.1332516735071617778.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH net-next 0/4] net: hns3: add aRFS feature and fix FEC
 bugs for HNS3 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558696788-12944-1-git-send-email-tanhuazhong@huawei.com>
References: <1558696788-12944-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 13:27:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Fri, 24 May 2019 19:19:44 +0800

> This patchset adds some new features support and fixes some bugs:
> [Patch 1/4 - 3/4] adds support for aRFS
> [Patch 4/4] fix FEC configuration issue

Series applied.
