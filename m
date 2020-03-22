Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5B518E640
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 04:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgCVDWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 23:22:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34490 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgCVDWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 23:22:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C1BC15AC42AD;
        Sat, 21 Mar 2020 20:22:41 -0700 (PDT)
Date:   Sat, 21 Mar 2020 20:22:40 -0700 (PDT)
Message-Id: <20200321.202240.842595752556222392.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH net-next 0/3] net: hns3: add three optimizations for
 mailbox handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584503827-12025-1-git-send-email-tanhuazhong@huawei.com>
References: <1584503827-12025-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 20:22:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Wed, 18 Mar 2020 11:57:04 +0800

> This patchset includes three code optimizations for mailbox handling.
> 
> [patch 1] adds a response code conversion.
> [patch 2] refactors some structure definitions about PF and
> VF mailbox.
> [patch 3] refactors the condition whether PF responds VF's mailbox.

Series applied, thanks.
