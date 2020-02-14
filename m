Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC1415DA45
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgBNPFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:05:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53182 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729122AbgBNPFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:05:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 28F9015C3BCEB;
        Fri, 14 Feb 2020 07:05:33 -0800 (PST)
Date:   Fri, 14 Feb 2020 07:05:30 -0800 (PST)
Message-Id: <20200214.070530.386375186739050820.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH net 0/3] net: hns3: fixes for -net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1581645223-23038-1-git-send-email-tanhuazhong@huawei.com>
References: <1581645223-23038-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Feb 2020 07:05:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Fri, 14 Feb 2020 09:53:40 +0800

> This series includes three bugfixes for the HNS3 ethernet driver.
> 
> [patch 1] fixes a management table lost issue after IMP reset.
> [patch 2] fixes a VF bandwidth configuration not work problem.
> [patch 3] fixes a problem related to IPv6 address copying.

Series applied.
