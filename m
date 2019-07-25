Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E26756BC
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfGYSTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:19:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36742 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfGYSTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 14:19:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C19D61434E33E;
        Thu, 25 Jul 2019 11:19:40 -0700 (PDT)
Date:   Thu, 25 Jul 2019 11:19:38 -0700 (PDT)
Message-Id: <20190725.111938.1711332352368320537.davem@davemloft.net>
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
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 11:19:41 -0700 (PDT)
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

Applied.
