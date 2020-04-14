Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087881A8C0A
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 22:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632781AbgDNUNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 16:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2632775AbgDNUNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 16:13:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4EFC03C1A7
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 13:13:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 40BBF127FD188;
        Tue, 14 Apr 2020 13:13:13 -0700 (PDT)
Date:   Tue, 14 Apr 2020 13:13:12 -0700 (PDT)
Message-Id: <20200414.131312.1848036375031469118.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, lukas@wunner.de, ynezz@true.cz,
        yuehaibing@huawei.com
Subject: Re: [PATCH V4 00/19] net: ks8851: Unify KS8851 SPI and MLL drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200414182029.183594-1-marex@denx.de>
References: <20200414182029.183594-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Apr 2020 13:13:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The net-next tree is still closed:

	http://vger.kernel.org/~davem/net-next.html

Please only submit bug fixes at this time, thank you.
