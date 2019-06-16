Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64667476E6
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 23:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfFPVDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 17:03:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52118 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfFPVDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 17:03:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64DC7151BFFA9;
        Sun, 16 Jun 2019 14:03:42 -0700 (PDT)
Date:   Sun, 16 Jun 2019 14:03:41 -0700 (PDT)
Message-Id: <20190616.140341.1206535816113380121.davem@davemloft.net>
To:     ivan.khoronzhuk@linaro.org
Cc:     grygorii.strashko@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: ti: davinci_cpdma: use idled
 submit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190615110132.6594-1-ivan.khoronzhuk@linaro.org>
References: <20190615110132.6594-1-ivan.khoronzhuk@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 14:03:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Sat, 15 Jun 2019 14:01:32 +0300

> While data pass suspend, reuse of rx descriptors can be disabled using
> channel state & lock from cpdma layer. For this, submit to a channel
> has to be disabled using state != "not active" under lock, what is done
> with this patch. The same submit is used to fill rx channel while
> ndo_open, when channel is idled, so add idled submit routine that
> allows to prepare descs for the channel. All this simplifies code and
> helps to avoid dormant mode usage and send packets only to active
> channels, avoiding potential race in later on changes. Also add missed
> sync barrier analogically like in other places after stopping tx
> queues.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Applied.
