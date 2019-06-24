Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBA450DB6
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfFXOTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:19:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54580 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfFXOTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:19:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 017FB15040FFE;
        Mon, 24 Jun 2019 07:19:07 -0700 (PDT)
Date:   Mon, 24 Jun 2019 07:19:04 -0700 (PDT)
Message-Id: <20190624.071904.218810557862357397.davem@davemloft.net>
To:     xuechaojing@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoshaokai@huawei.com, cloud.wangxiaoyun@huawei.com,
        chiqijun@huawei.com, wulike1@huawei.com
Subject: Re: [PATCH net-next v2] hinic: implement the statistical interface
 of ethtool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624035012.7221-1-xuechaojing@huawei.com>
References: <20190624035012.7221-1-xuechaojing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 07:19:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xue Chaojing <xuechaojing@huawei.com>
Date: Mon, 24 Jun 2019 03:50:12 +0000

> This patch implement the statistical interface of ethtool, user can use
> ethtool -S to show hinic statistics.
> 
> Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>

Applied.
