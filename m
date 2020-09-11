Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF98F266A3B
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgIKVoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgIKVoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:44:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56F9C061573;
        Fri, 11 Sep 2020 14:44:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 297551366AF43;
        Fri, 11 Sep 2020 14:27:50 -0700 (PDT)
Date:   Fri, 11 Sep 2020 14:44:36 -0700 (PDT)
Message-Id: <20200911.144436.1790085156026689841.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/net/wan/x25_asy: Remove an unused
 flag "SLF_OUTWAIT"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200911063503.152765-1-xie.he.0141@gmail.com>
References: <20200911063503.152765-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 14:27:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Thu, 10 Sep 2020 23:35:03 -0700

> The "SLF_OUTWAIT" flag defined in x25_asy.h is not actually used.
> It is only cleared at one place in x25_asy.c but is never read or set.
> So we can remove it.
> 
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, it looks like this code wss based upon the slip.c code.
