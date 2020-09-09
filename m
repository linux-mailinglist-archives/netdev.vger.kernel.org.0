Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92ED92625DF
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgIID01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgIID01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:26:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8085C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 20:26:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EBB8011E3E4C4;
        Tue,  8 Sep 2020 20:09:38 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:26:24 -0700 (PDT)
Message-Id: <20200908.202624.1034584030321657759.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org, kuba@kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH trivial] nfc: pn533/usb.c: fix spelling of "functions"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fc1a9118-39d5-2084-8a1d-0974f70f80ad@infradead.org>
References: <fc1a9118-39d5-2084-8a1d-0974f70f80ad@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 20:09:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Tue, 8 Sep 2020 17:13:25 -0700

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix typo/spello of "functions".
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied to net-next.
