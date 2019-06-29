Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652705ACB2
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 19:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfF2R2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 13:28:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37792 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbfF2R2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 13:28:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1BAD414AAC091;
        Sat, 29 Jun 2019 10:28:36 -0700 (PDT)
Date:   Sat, 29 Jun 2019 10:28:35 -0700 (PDT)
Message-Id: <20190629.102835.322512688194056099.davem@davemloft.net>
To:     xuechaojing@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoshaokai@huawei.com, cloud.wangxiaoyun@huawei.com,
        chiqijun@huawei.com, wulike1@huawei.com
Subject: Re: [PATCH net-next] hinic: add vlan offload support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190629022627.25396-1-xuechaojing@huawei.com>
References: <20190629022627.25396-1-xuechaojing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 10:28:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xue Chaojing <xuechaojing@huawei.com>
Date: Sat, 29 Jun 2019 02:26:27 +0000

> This patch adds vlan offload support for the HINIC driver.
> 
> Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>

Applied, thank you.
