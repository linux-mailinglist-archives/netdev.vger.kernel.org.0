Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB1A741AA
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387816AbfGXWrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:47:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53134 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbfGXWrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:47:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 218E11543C8D7;
        Wed, 24 Jul 2019 15:47:40 -0700 (PDT)
Date:   Wed, 24 Jul 2019 15:47:39 -0700 (PDT)
Message-Id: <20190724.154739.72147269285837223.davem@davemloft.net>
To:     wsa+renesas@sang-engineering.com
Cc:     linux-i2c@vger.kernel.org, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sfc: falcon: convert to i2c_new_dummy_device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190722172635.4535-1-wsa+renesas@sang-engineering.com>
References: <20190722172635.4535-1-wsa+renesas@sang-engineering.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 15:47:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>
Date: Mon, 22 Jul 2019 19:26:35 +0200

> Move from i2c_new_dummy() to i2c_new_dummy_device(). So, we now get an
> ERRPTR which we use in error handling.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Solarflare folks, please review/test.

Thank you.
