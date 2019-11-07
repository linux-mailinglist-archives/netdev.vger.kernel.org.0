Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3422F3BFE
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfKGXN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:13:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49642 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfKGXN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:13:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C4EC15369903;
        Thu,  7 Nov 2019 15:13:28 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:13:28 -0800 (PST)
Message-Id: <20191107.151328.687483368106631813.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     jiri@mellanox.com, idosch@mellanox.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] mlxsw: spectrum: Fix error return code in
 mlxsw_sp_port_module_info_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191106145231.39128-1-weiyongjun1@huawei.com>
References: <20191106145231.39128-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:13:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Wed, 6 Nov 2019 14:52:31 +0000

> Fix to return negative error code -ENOMEM from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 4a7f970f1240 ("mlxsw: spectrum: Replace port_to_module array with array of structs")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied, thank you.
