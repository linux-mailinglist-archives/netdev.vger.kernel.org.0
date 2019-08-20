Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3189095309
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbfHTBPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:15:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39126 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728615AbfHTBPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 21:15:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5DBC214B4DFE0;
        Mon, 19 Aug 2019 18:15:32 -0700 (PDT)
Date:   Mon, 19 Aug 2019 18:15:31 -0700 (PDT)
Message-Id: <20190819.181531.755596030105916368.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Kconfig: Fix the reference to the IDT77105 Phy driver
 in the description of ATM_NICSTAR_USE_IDT77105
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190819050425.6119-1-christophe.jaillet@wanadoo.fr>
References: <20190819050425.6119-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 18:15:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Mon, 19 Aug 2019 07:04:25 +0200

> This should be IDT77105, not IDT77015.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.
