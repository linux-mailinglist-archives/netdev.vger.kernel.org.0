Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26DE216957
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 19:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfEGRha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 13:37:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59918 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEGRha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 13:37:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4B0F1491A2B5;
        Tue,  7 May 2019 10:37:29 -0700 (PDT)
Date:   Tue, 07 May 2019 10:37:27 -0700 (PDT)
Message-Id: <20190507.103727.18553029517298566.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, nhorman@redhat.com
Subject: Re: [PATCH net-next 00/12] cleanup & optimizations & bugfixes for
 HNS3 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
References: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 10:37:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Mon, 6 May 2019 10:48:40 +0800

> This patchset contains some cleanup related to hns3_enet_ring
> struct and tx bd filling process, optimizations related
> to rx page reusing, barrier using and tso handling process,
> bugfixes related to tunnel type handling and error handling for
> desc filling.

Series applied, thanks.
