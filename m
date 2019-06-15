Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53EB246DA0
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 03:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfFOBqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 21:46:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56890 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfFOBqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 21:46:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A609712B05D21;
        Fri, 14 Jun 2019 18:46:04 -0700 (PDT)
Date:   Fri, 14 Jun 2019 18:46:04 -0700 (PDT)
Message-Id: <20190614.184604.907915797695253644.davem@davemloft.net>
To:     ivan.khoronzhuk@linaro.org
Cc:     grygorii.strashko@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: ti: cpsw_ethtool: simplify
 slave loops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190611215940.32359-1-ivan.khoronzhuk@linaro.org>
References: <20190611215940.32359-1-ivan.khoronzhuk@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 18:46:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Wed, 12 Jun 2019 00:59:40 +0300

> Only for consistency reasons, do it like in main cpsw.c module
> and use ndev reference but not by means of slave.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Applied.
