Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96BE933A31
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFCVui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:50:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35758 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFCVuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:50:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4644D14D99F48;
        Mon,  3 Jun 2019 14:34:10 -0700 (PDT)
Date:   Mon, 03 Jun 2019 14:34:09 -0700 (PDT)
Message-Id: <20190603.143409.1580682037956010747.davem@davemloft.net>
To:     ivan.khoronzhuk@linaro.org
Cc:     grygorii.strashko@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: ti: cpsw_ethtool: fix ethtool ring
 param set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531134725.2054-1-ivan.khoronzhuk@linaro.org>
References: <20190531134725.2054-1-ivan.khoronzhuk@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 14:34:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Fri, 31 May 2019 16:47:25 +0300

> Fix ability to set RX descriptor number, the reason - initially
> "tx_max_pending" was set incorrectly, but the issue appears after
> adding sanity check, so fix is for "sanity" patch.
> 
> Fixes: 37e2d99b59c476 ("ethtool: Ensure new ring parameters are within bounds during SRINGPARAM")
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Applied and queued up for -stable, thanks.
