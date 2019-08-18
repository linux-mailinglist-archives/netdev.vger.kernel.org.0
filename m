Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7A691964
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 21:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfHRT7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 15:59:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47718 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfHRT7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 15:59:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1197C143750E0;
        Sun, 18 Aug 2019 12:59:33 -0700 (PDT)
Date:   Sun, 18 Aug 2019 12:59:32 -0700 (PDT)
Message-Id: <20190818.125932.1044566169750919915.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 0/6] net: hns3: add some cleanups & bugfix
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
References: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 12:59:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Fri, 16 Aug 2019 16:09:36 +0800

> This patch-set includes cleanups and bugfix for the HNS3 ethernet
> controller driver.
> 
> [patch 01/06 - 03/06] adds some cleanups.
> 
> [patch 04/06] changes the print level of RAS.
> 
> [patch 05/06] fixes a bug related to MAC TNL.
> 
> [patch 06/06] adds phy_attached_info().

Series applied, thanks.
