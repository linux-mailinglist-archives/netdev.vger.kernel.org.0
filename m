Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15580F1D79
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 19:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732548AbfKFSXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 13:23:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfKFSXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 13:23:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A6BBA151EB7AB;
        Wed,  6 Nov 2019 10:23:50 -0800 (PST)
Date:   Wed, 06 Nov 2019 10:23:50 -0800 (PST)
Message-Id: <20191106.102350.923019985931751442.davem@davemloft.net>
To:     yeyunfeng@huawei.com
Cc:     dougmill@linux.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hushiyuan@huawei.com,
        linfeilong@huawei.com
Subject: Re: [PATCH] ehea: replace with page_shift() in ehea_is_hugepage()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f581efc8-5d92-fed7-27b5-d5c5e9bce8ee@huawei.com>
References: <f581efc8-5d92-fed7-27b5-d5c5e9bce8ee@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 10:23:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>
Date: Tue, 5 Nov 2019 19:30:45 +0800

> The function page_shift() is supported after the commit 94ad9338109f
> ("mm: introduce page_shift()").
> 
> So replace with page_shift() in ehea_is_hugepage() for readability.
> 
> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>

Applied to net-next.
