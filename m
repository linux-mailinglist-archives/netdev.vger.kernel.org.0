Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657772707E3
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgIRVNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIRVNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:13:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA717C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 14:13:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD38B159CF6E6;
        Fri, 18 Sep 2020 13:56:11 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:12:58 -0700 (PDT)
Message-Id: <20200918.141258.81390045923800996.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH 0/7 net-next] net: various: delete duplicated words
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918043521.17346-1-rdunlap@infradead.org>
References: <20200918043521.17346-1-rdunlap@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 13:56:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Thu, 17 Sep 2020 21:35:14 -0700

> [PATCH 1/7 net-next] net: core: delete duplicated words
> [PATCH 2/7 net-next] net: rds: delete duplicated words
> [PATCH 3/7 net-next] net: ipv6: delete duplicated words
> [PATCH 4/7 net-next] net: bluetooth: delete duplicated words
> [PATCH 5/7 net-next] net: tipc: delete duplicated words
> [PATCH 6/7 net-next] net: atm: delete duplicated words
> [PATCH 7/7 net-next] net: bridge: delete duplicated words

Series applied.
