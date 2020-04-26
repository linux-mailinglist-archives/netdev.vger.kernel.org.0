Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC83B1B8BA6
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgDZDaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726089AbgDZDaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:30:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2817EC061A0C;
        Sat, 25 Apr 2020 20:30:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEEF7159F836B;
        Sat, 25 Apr 2020 20:30:03 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:29:59 -0700 (PDT)
Message-Id: <20200425.202959.1368122664226619442.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH net-next 0/8] net: hns3: refactor for MAC table
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
References: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:30:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Fri, 24 Apr 2020 10:23:05 +0800

> This patchset refactors the MAC table management, configure
> the MAC address asynchronously, instead of synchronously.
> Base on this change, it also refines the handle of promisc
> mode and filter table entries restoring after reset.

Series applied, thanks.
