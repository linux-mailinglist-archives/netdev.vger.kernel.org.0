Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE5F579165
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfG2Qsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:48:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfG2Qsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:48:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3AB6F1266535A;
        Mon, 29 Jul 2019 09:48:45 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:48:44 -0700 (PDT)
Message-Id: <20190729.094844.56809733624311319.davem@davemloft.net>
To:     dingxiang@cmss.chinamobile.com
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ag71xx: use resource_size for the ioremap size
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564390882-28002-1-git-send-email-dingxiang@cmss.chinamobile.com>
References: <1564390882-28002-1-git-send-email-dingxiang@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 09:48:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ding Xiang <dingxiang@cmss.chinamobile.com>
Date: Mon, 29 Jul 2019 17:01:22 +0800

> use resource_size to calcuate ioremap size and make
> the code simpler.
> 
> Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>

Applied to net-next.
