Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B4A35242
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfFDVwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:52:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53006 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDVwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:52:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD7B815010A56;
        Tue,  4 Jun 2019 14:52:10 -0700 (PDT)
Date:   Tue, 04 Jun 2019 14:52:10 -0700 (PDT)
Message-Id: <20190604.145210.1322361852490983999.davem@davemloft.net>
To:     xuechaojing@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, luoshaokai@huawei.com,
        cloud.wangxiaoyun@huawei.com, chiqijun@huawei.com,
        wulike1@huawei.com
Subject: Re: [PATCH net-next v4] hinic: add LRO support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190604011608.26485-1-xuechaojing@huawei.com>
References: <20190604011608.26485-1-xuechaojing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 14:52:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xue Chaojing <xuechaojing@huawei.com>
Date: Tue, 4 Jun 2019 01:16:08 +0000

> This patch adds LRO support for the HiNIC driver.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>

Applied.
