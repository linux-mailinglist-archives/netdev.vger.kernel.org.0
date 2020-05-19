Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26DE1D8C7F
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgESAnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgESAno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:43:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C567CC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 17:43:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BF1B12765156;
        Mon, 18 May 2020 17:43:44 -0700 (PDT)
Date:   Mon, 18 May 2020 17:43:43 -0700 (PDT)
Message-Id: <20200518.174343.1989729001180143693.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1] net: seeq: Use %pM format specifier for MAC
 addresses
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200518192128.72875-1-andriy.shevchenko@linux.intel.com>
References: <20200518192128.72875-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 May 2020 17:43:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 18 May 2020 22:21:28 +0300

> Convert to %pM instead of using custom code.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied.
