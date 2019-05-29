Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA772D2D5
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfE2AZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:25:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54454 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfE2AZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 20:25:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D33521400F69A;
        Tue, 28 May 2019 17:24:59 -0700 (PDT)
Date:   Tue, 28 May 2019 17:24:59 -0700 (PDT)
Message-Id: <20190528.172459.2048004424458737029.davem@davemloft.net>
To:     xuechaojing@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoshaokai@huawei.com, cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next] hinic: fix a bug in set rx mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190527221005.10073-1-xuechaojing@huawei.com>
References: <20190527221005.10073-1-xuechaojing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 17:25:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xue Chaojing <xuechaojing@huawei.com>
Date: Mon, 27 May 2019 22:10:05 +0000

> in set_rx_mode, __dev_mc_sync and netdev_for_each_mc_addr will
> repeatedly set the multicast mac address. so we delete this loop.
> 
> Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>

Applied.
