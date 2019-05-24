Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B2429F97
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391743AbfEXUOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:14:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42560 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391612AbfEXUOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:14:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 96A3814E24DEE;
        Fri, 24 May 2019 13:14:24 -0700 (PDT)
Date:   Fri, 24 May 2019 13:14:24 -0700 (PDT)
Message-Id: <20190524.131424.1033576069004958221.davem@davemloft.net>
To:     fugang.duan@nxp.com
Cc:     netdev@vger.kernel.org, baruch@tkos.co.il
Subject: Re: [PATCH net,stable 1/1] net: fec: fix the clk mismatch in
 failed_reset path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558576444-25080-2-git-send-email-fugang.duan@nxp.com>
References: <1558576444-25080-1-git-send-email-fugang.duan@nxp.com>
        <1558576444-25080-2-git-send-email-fugang.duan@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 May 2019 13:14:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Duan <fugang.duan@nxp.com>
Date: Thu, 23 May 2019 01:55:28 +0000

> Fix the clk mismatch in the error path "failed_reset" because
> below error path will disable clk_ahb and clk_ipg directly, it
> should use pm_runtime_put_noidle() instead of pm_runtime_put()
> to avoid to call runtime resume callback.
> 
> Reported-by: Baruch Siach <baruch@tkos.co.il>
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>

Applied and queued up for -stable.
