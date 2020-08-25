Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5002250D55
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 02:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgHYAbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 20:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbgHYAbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 20:31:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44423C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 17:31:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7C421294C6ED;
        Mon, 24 Aug 2020 17:14:49 -0700 (PDT)
Date:   Mon, 24 Aug 2020 17:31:33 -0700 (PDT)
Message-Id: <20200824.173133.1770652899131339061.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH] net: ipv4: delete repeated words
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200822233141.1671-1-rdunlap@infradead.org>
References: <20200822233141.1671-1-rdunlap@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 17:14:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 22 Aug 2020 16:31:41 -0700

> Drop duplicate words in comments in net/ipv4/.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied.
