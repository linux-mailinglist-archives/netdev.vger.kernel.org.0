Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E031F6D74B
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 01:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfGRXdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 19:33:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57230 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfGRXdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 19:33:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 675451528C8C8;
        Thu, 18 Jul 2019 16:33:05 -0700 (PDT)
Date:   Thu, 18 Jul 2019 16:33:04 -0700 (PDT)
Message-Id: <20190718.163304.76416296704116264.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: dsa: sja1105: Fix missing unlock on error in
 sk_buff()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190717062956.127446-1-weiyongjun1@huawei.com>
References: <20190717062956.127446-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 16:33:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Wed, 17 Jul 2019 06:29:56 +0000

> Add the missing unlock before return from function sk_buff()
> in the error handling case.
> 
> Fixes: f3097be21bf1 ("net: dsa: sja1105: Add a state machine for RX timestamping")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied.
