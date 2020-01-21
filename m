Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52B271439CB
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgAUJtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:49:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35886 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbgAUJtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 04:49:11 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87C8815BCC53B;
        Tue, 21 Jan 2020 01:49:08 -0800 (PST)
Date:   Tue, 21 Jan 2020 10:49:07 +0100 (CET)
Message-Id: <20200121.104907.186187461912601930.davem@davemloft.net>
To:     chenzhou10@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] net: hns3: replace snprintf with scnprintf in
 hns3_dbg_cmd_read
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200120124943.30274-1-chenzhou10@huawei.com>
References: <20200120124943.30274-1-chenzhou10@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 01:49:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>
Date: Mon, 20 Jan 2020 20:49:43 +0800

> The return value of snprintf may be greater than the size of
> HNS3_DBG_READ_LEN, use scnprintf instead in hns3_dbg_cmd_read.
> 
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> ---
> 
> changes in v2:
> - fix checkpatch style problem.

Both conversion patches applied, thank you.
