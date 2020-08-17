Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040EB2472B3
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 20:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391595AbgHQSqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 14:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388043AbgHQSqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 14:46:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEDCC061389;
        Mon, 17 Aug 2020 11:46:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F77014ACC17C;
        Mon, 17 Aug 2020 11:29:47 -0700 (PDT)
Date:   Mon, 17 Aug 2020 11:46:29 -0700 (PDT)
Message-Id: <20200817.114629.1895503086750807628.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH] phylink: <linux/phylink.h>: fix function prototype
 kernel-doc warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f99bacca-0868-dff0-ff72-ebe8b8749270@infradead.org>
References: <20200816222549.379-1-rdunlap@infradead.org>
        <20200816.211451.1874573780407600816.davem@davemloft.net>
        <f99bacca-0868-dff0-ff72-ebe8b8749270@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Aug 2020 11:29:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Sun, 16 Aug 2020 22:43:54 -0700

> On 8/16/20 9:14 PM, David Miller wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>> Date: Sun, 16 Aug 2020 15:25:49 -0700
>> 
>>> Fix a kernel-doc warning for the pcs_config() function prototype:
>>>
>>> ../include/linux/phylink.h:406: warning: Excess function parameter 'permit_pause_to_mac' description in 'pcs_config'
>>>
>>> Fixes: 7137e18f6f88 ("net: phylink: add struct phylink_pcs")
>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> 
>> There's no definition of this function anywhere.  Maybe just remove all of
>> this?
>> 
> 
> It's for documentation purposes...
> 
> It's a "method" (callback) function.

I see, that's an unfortunate shortcoming of kerneldoc.

Applied, thanks.

