Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457161D8C7E
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgESAnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgESAnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:43:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA8CC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 17:43:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B23812765154;
        Mon, 18 May 2020 17:43:39 -0700 (PDT)
Date:   Mon, 18 May 2020 17:43:38 -0700 (PDT)
Message-Id: <20200518.174338.291650928600469697.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     vishal@chelsio.com, netdev@vger.kernel.org
Subject: Re: [PATCH v1] cxgb4: Use %pM format specifier for MAC addresses
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200518191831.72534-1-andriy.shevchenko@linux.intel.com>
References: <20200518191831.72534-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 May 2020 17:43:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 18 May 2020 22:18:31 +0300

> Convert to %pM instead of using custom code.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied.
