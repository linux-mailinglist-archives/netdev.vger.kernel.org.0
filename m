Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9056DDDA3D
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 20:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfJSSmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 14:42:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42348 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfJSSmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 14:42:16 -0400
Received: from localhost (unknown [64.79.112.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85E3F148E09FD;
        Sat, 19 Oct 2019 11:42:15 -0700 (PDT)
Date:   Sat, 19 Oct 2019 11:42:01 -0700 (PDT)
Message-Id: <20191019.114201.1452663573197641033.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com,
        liuyonglong@huawei.com
Subject: Re: [PATCH net] net: hns3: fix mis-counting IRQ vector numbers
 issue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571370179-52008-1-git-send-email-tanhuazhong@huawei.com>
References: <1571370179-52008-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 19 Oct 2019 11:42:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Fri, 18 Oct 2019 11:42:59 +0800

> From: Yonglong Liu <liuyonglong@huawei.com>
> 
> Currently, the num_msi_left means the vector numbers of NIC,
> but if the PF supported RoCE, it contains the vector numbers
> of NIC and RoCE(Not expected).
> 
> This may cause interrupts lost in some case, because of the
> NIC module used the vector resources which belongs to RoCE.
> 
> This patch adds a new variable num_nic_msi to store the vector
> numbers of NIC, and adjust the default TQP numbers and rss_size
> according to the value of num_nic_msi.
> 
> Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Applied, thanks.
