Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605184F610
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 15:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfFVNxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 09:53:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54514 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfFVNxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 09:53:34 -0400
Received: from localhost (unknown [8.46.76.25])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9F77153DF648;
        Sat, 22 Jun 2019 06:53:27 -0700 (PDT)
Date:   Sat, 22 Jun 2019 09:53:23 -0400 (EDT)
Message-Id: <20190622.095323.1495992426494142587.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH net-next 00/11] net: hns3: some code optimizations &
 bugfixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
References: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 06:53:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Thu, 20 Jun 2019 16:52:34 +0800

> This patch-set includes code optimizations and bugfixes for
> the HNS3 ethernet controller driver.
> 
> [patch 1/11] fixes a selftest issue when doing autoneg.
> 
> [patch 2/11 - 3-11] adds two code optimizations about VLAN issue.
> 
> [patch 4/11] restores the MAC autoneg state after reset.
> 
> [patch 5/11 - 8/11] adds some code optimizations and bugfixes about
> HW errors handling.
> 
> [patch 9/11 - 11/11] fixes some issues related to driver loading and
> unloading.

Series applied, thanks.
