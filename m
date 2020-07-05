Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A533D21503D
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgGEWr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEWr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:47:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBA8C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:47:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4EF2D12915D78;
        Sun,  5 Jul 2020 15:47:55 -0700 (PDT)
Date:   Sun, 05 Jul 2020 15:47:54 -0700 (PDT)
Message-Id: <20200705.154754.1112555733235603915.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH] dsa: rtl8366: Pass GENMASK() signed bits
From:   David Miller <davem@davemloft.net>
In-Reply-To: <945fc1cb-c37f-49d5-564c-0786ed9c9d57@gmail.com>
References: <20200705204227.892335-1-andrew@lunn.ch>
        <945fc1cb-c37f-49d5-564c-0786ed9c9d57@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jul 2020 15:47:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sun, 5 Jul 2020 13:49:10 -0700

> 
> 
> On 7/5/2020 1:42 PM, Andrew Lunn wrote:
>> Oddly, GENMASK() requires signed bit numbers, so that it can compare
>> them for < 0. If passed an unsigned type, we get warnings about the
>> test never being true.
>> 
>> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> The subject should also be prefixed with "net: " similar to the bcm_sf2
> patches you just sent out, with that fixed:
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Applied with Subject fixed.
