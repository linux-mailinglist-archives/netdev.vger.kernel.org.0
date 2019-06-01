Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C70D318BA
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfFAAPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:15:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52992 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfFAAPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:15:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B56D3150402A2;
        Fri, 31 May 2019 17:15:29 -0700 (PDT)
Date:   Fri, 31 May 2019 17:15:29 -0700 (PDT)
Message-Id: <20190531.171529.1003718945482922118.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH net-next 00/12] code optimizations & bugfixes for HNS3
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
References: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 17:15:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Fri, 31 May 2019 16:54:46 +0800

> This patch-set includes code optimizations and bugfixes for the HNS3
> ethernet controller driver.
> 
> [patch 1/12] removes the redundant core reset type
> 
> [patch 2/12 - 3/12] fixes two VLAN related issues
> 
> [patch 4/12] fixes a TM issue
> 
> [patch 5/12 - 12/12] includes some patches related to RAS & MSI-X error

Series applied.
