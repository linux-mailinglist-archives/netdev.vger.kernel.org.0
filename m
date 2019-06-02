Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAB2D324DA
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 22:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfFBU4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 16:56:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48392 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFBU4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 16:56:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E6D21418EB70;
        Sun,  2 Jun 2019 13:56:14 -0700 (PDT)
Date:   Sun, 02 Jun 2019 13:56:13 -0700 (PDT)
Message-Id: <20190602.135613.2279224080035211108.davem@davemloft.net>
To:     liuyonglong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, shiju.jose@huawei.com
Subject: Re: [PATCH net] net: hns: Fix loopback test failed at copper ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559293190-24600-1-git-send-email-liuyonglong@huawei.com>
References: <1559293190-24600-1-git-send-email-liuyonglong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Jun 2019 13:56:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>
Date: Fri, 31 May 2019 16:59:50 +0800

> When doing a loopback test at copper ports, the serdes loopback
> and the phy loopback will fail, because of the adjust link had
> not finished, and phy not ready.
> 
> Adds sleep between adjust link and test process to fix it.
> 
> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>

Applied.
