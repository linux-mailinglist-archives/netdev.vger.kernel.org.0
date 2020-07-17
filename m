Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B729B2244A5
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgGQTw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728291AbgGQTw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:52:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AB3C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 12:52:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 926DF11E45928;
        Fri, 17 Jul 2020 12:52:28 -0700 (PDT)
Date:   Fri, 17 Jul 2020 12:52:27 -0700 (PDT)
Message-Id: <20200717.125227.55028219209538840.davem@davemloft.net>
To:     akiyano@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        ndagan@amazon.com, shayagr@amazon.com, sameehj@amazon.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH V3 net-next 1/8] net: ena: avoid unnecessary rearming
 of interrupt vector when busy-polling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1594923010-6234-2-git-send-email-akiyano@amazon.com>
References: <1594923010-6234-1-git-send-email-akiyano@amazon.com>
        <1594923010-6234-2-git-send-email-akiyano@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 12:52:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <akiyano@amazon.com>
Date: Thu, 16 Jul 2020 21:10:03 +0300

> To the best of my knowledge this assumption holds for ARM64 and x86_64
> architecture which use a MESI like cache coherency model.

Use the well defined kernel memory model correctly please.

This is no place for architectural assumptions.  The memory model of
the kernel defines the rules, and in what locations various memory
barriers are required for correct operation.

Thank you.

