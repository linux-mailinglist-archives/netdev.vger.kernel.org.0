Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A014F22B6A2
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 21:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgGWTWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 15:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgGWTWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 15:22:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A50C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 12:22:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7819711D69C3B;
        Thu, 23 Jul 2020 12:05:39 -0700 (PDT)
Date:   Thu, 23 Jul 2020 12:22:23 -0700 (PDT)
Message-Id: <20200723.122223.123487642508856678.davem@davemloft.net>
To:     W_Armin@gmx.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] lib8390: Fix coding-style issues and
 remove verion printing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200723183604.GA6850@mx-linux-amd>
References: <20200723183604.GA6850@mx-linux-amd>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 12:05:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>
Date: Thu, 23 Jul 2020 20:36:04 +0200

> Fix various checkpatch warnings.
> Remove version printing so modules including lib8390 do not
> have to provide a global version string for successful
> compilation.
> 
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>

Honestly, I see little to no value to all this comment layout churn.

I'm not applying this, sorry.
