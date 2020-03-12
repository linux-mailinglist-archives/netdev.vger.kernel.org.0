Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA2A1838D4
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgCLSj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:39:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33678 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgCLSj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:39:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 06339157526A7;
        Thu, 12 Mar 2020 11:39:57 -0700 (PDT)
Date:   Thu, 12 Mar 2020 11:39:57 -0700 (PDT)
Message-Id: <20200312.113957.925508715253795165.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH net 0/4] net: hns3: fixes for -net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583997066-24773-1-git-send-email-tanhuazhong@huawei.com>
References: <1583997066-24773-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 11:39:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Thu, 12 Mar 2020 15:11:02 +0800

> This series includes several bugfixes for the HNS3 ethernet driver.
> 
> [patch 1] fixes an "tc qdisc del" failure.
> [patch 2] fixes SW & HW VLAN table not consistent issue.
> [patch 3] fixes a RMW issue related to VLAN filter switch.
> [patch 4] clears port based VLAN when uploading PF.

Series applied and queued up for -stable.
