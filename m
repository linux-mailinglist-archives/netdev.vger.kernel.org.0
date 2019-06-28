Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF385A121
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfF1QkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:40:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF1QkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:40:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5EE9714E03B0A;
        Fri, 28 Jun 2019 09:40:04 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:40:03 -0700 (PDT)
Message-Id: <20190628.094003.1587085416066529986.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH net-next 00/12] net: hns3: some code optimizations &
 cleanups & bugfixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
References: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 09:40:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Fri, 28 Jun 2019 19:50:06 +0800

> [patch 01/12] fixes a TX timeout issue.
> 
> [patch 02/12 - 04/12] adds some patch related to TM module.
> 
> [patch 05/12] fixes a compile warning.
> 
> [patch 06/12] adds Asym Pause support for autoneg
> 
> [patch 07/12] optimizes the error handler for VF reset.
> 
> [patch 08/12] deals with the empty interrupt case.
> 
> [patch 09/12 - 12/12] adds some cleanups & optimizations.

Looks good, series applied, thanks.
