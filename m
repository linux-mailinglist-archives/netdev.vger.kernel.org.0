Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA2BB0E4B
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 13:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731422AbfILLvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 07:51:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730923AbfILLvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 07:51:54 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E7231433DDA9;
        Thu, 12 Sep 2019 04:51:53 -0700 (PDT)
Date:   Thu, 12 Sep 2019 13:51:51 +0200 (CEST)
Message-Id: <20190912.135151.2131652757013081691.davem@davemloft.net>
To:     arkadiusz@drabczyk.org
Cc:     vishal@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb4: Fix spelling typos
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190910204901.11741-1-arkadiusz@drabczyk.org>
References: <20190910204901.11741-1-arkadiusz@drabczyk.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Sep 2019 04:51:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Drabczyk <arkadiusz@drabczyk.org>
Date: Tue, 10 Sep 2019 22:49:01 +0200

> Fix several spelling typos in comments in t4_hw.c.
> 
> Signed-off-by: Arkadiusz Drabczyk <arkadiusz@drabczyk.org>

Applied to net-next.
