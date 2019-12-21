Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9F78128757
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfLUFVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:21:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56886 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:21:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1BC7C153CC235;
        Fri, 20 Dec 2019 21:21:30 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:21:29 -0800 (PST)
Message-Id: <20191220.212129.46762175820038925.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 0/8] net: hns3: misc updates for -net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576738667-37960-1-git-send-email-tanhuazhong@huawei.com>
References: <1576738667-37960-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:21:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Thu, 19 Dec 2019 14:57:39 +0800

> This series includes some misc updates for the HNS3 ethernet driver.
> 
> [patch 1] adds FE bit check before calling hns3_add_frag().
> [patch 2] removes an unnecessary lock.
> [patch 3] adds a little optimization for CMDQ uninitialization.
> [patch 4] refactors the dump of FD tcams.
> [patch 5] implements ndo_features_check ops.
> [patch 6] adds some VF VLAN information for command "ip link show".
> [patch 7] adds a debug print.
> [patch 8] modifies the timing of print misc interrupt status when
> handling hardware error event.

Series applied, thanks.
