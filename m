Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 424805D5F1
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 20:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfGBSMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 14:12:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39446 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBSMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 14:12:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4393A133E9BEA;
        Tue,  2 Jul 2019 11:12:39 -0700 (PDT)
Date:   Tue, 02 Jul 2019 11:12:38 -0700 (PDT)
Message-Id: <20190702.111238.2286297854869517208.davem@davemloft.net>
To:     xuechaojing@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoshaokai@huawei.com, cloud.wangxiaoyun@huawei.com,
        chiqijun@huawei.com, wulike1@huawei.com
Subject: Re: [PATCH net-next] hinic: remove standard netdev stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190701234000.31738-1-xuechaojing@huawei.com>
References: <20190701234000.31738-1-xuechaojing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 11:12:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xue Chaojing <xuechaojing@huawei.com>
Date: Mon, 1 Jul 2019 23:40:00 +0000

> This patch removes standard netdev stats in ethtool -S.
> 
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>

Applied, thanks for following up on this.
