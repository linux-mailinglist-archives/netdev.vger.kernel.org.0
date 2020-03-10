Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B83717EEAA
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgCJCg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:36:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35024 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgCJCg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 22:36:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B2352120F5285;
        Mon,  9 Mar 2020 19:36:28 -0700 (PDT)
Date:   Mon, 09 Mar 2020 19:36:28 -0700 (PDT)
Message-Id: <20200309.193628.1915009045229686481.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH V2 net-next 0/9] net: hns3: misc updates for -net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583552570-51203-1-git-send-email-tanhuazhong@huawei.com>
References: <1583552570-51203-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 19:36:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Sat, 7 Mar 2020 11:42:41 +0800

> This series includes some misc updates for the HNS3 ethernet driver.
> 
> [patch 1] fixes some mixed type operation warning.
> [patch 2] renames a macro to make it more readable.
> [patch 3 & 4]  removes some unnecessary code.
> [patch 5] adds check before assert VF reset to prevent some unsuitable
> error log.
> [patch 6 - 9] some modifications related to printing.
> 
> Change log:
> V1->V2: fixes a wrong print format in [patch 1] suggested by Jian Shen.

Series applied, thank you.
