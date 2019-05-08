Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A32717E6E
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 18:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbfEHQrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 12:47:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48854 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbfEHQrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 12:47:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 940A2140751E7;
        Wed,  8 May 2019 09:47:00 -0700 (PDT)
Date:   Wed, 08 May 2019 09:46:58 -0700 (PDT)
Message-Id: <20190508.094658.865891598451554394.davem@davemloft.net>
To:     wanghai26@huawei.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: sja1105: Make 'sja1105et_regs' and
 'sja1105pqrs_regs' static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190508134326.34840-1-wanghai26@huawei.com>
References: <20190508134326.34840-1-wanghai26@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 May 2019 09:47:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai26@huawei.com>
Date: Wed, 8 May 2019 21:43:26 +0800

> drivers/net/dsa/sja1105/sja1105_spi.c:486:21: warning: symbol 'sja1105et_regs' was not declared. Should it be static?
> drivers/net/dsa/sja1105/sja1105_spi.c:511:21: warning: symbol 'sja1105pqrs_regs' was not declared. Should it be static?
> 
> Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai26@huawei.com>

Applied.
