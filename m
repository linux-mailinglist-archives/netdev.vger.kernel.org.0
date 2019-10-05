Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092B6CC6E4
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 02:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbfJEAZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 20:25:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60366 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJEAZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 20:25:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1698D14F2B13F;
        Fri,  4 Oct 2019 17:25:20 -0700 (PDT)
Date:   Fri, 04 Oct 2019 17:25:16 -0700 (PDT)
Message-Id: <20191004.172516.2250657783390011586.davem@davemloft.net>
To:     zhengbin13@huawei.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: sja1105: Make function sja1105_xfer_long_buf
 static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1570183050-136729-1-git-send-email-zhengbin13@huawei.com>
References: <1570183050-136729-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 17:25:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>
Date: Fri, 4 Oct 2019 17:57:30 +0800

> Fix sparse warnings:
> 
> drivers/net/dsa/sja1105/sja1105_spi.c:159:5: warning: symbol 'sja1105_xfer_long_buf' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

Applied.
