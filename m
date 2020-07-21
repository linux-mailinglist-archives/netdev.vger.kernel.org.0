Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24B8228C4F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgGUW7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgGUW7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:59:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77E6C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 15:59:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B65511E45904;
        Tue, 21 Jul 2020 15:42:56 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:59:40 -0700 (PDT)
Message-Id: <20200721.155940.1283130546170315882.davem@davemloft.net>
To:     akiyano@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        ndagan@amazon.com, shayagr@amazon.com, sameehj@amazon.com
Subject: Re: [PATCH V3 net-next 0/8] ENA driver new features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
References: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:42:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <akiyano@amazon.com>
Date: Tue, 21 Jul 2020 16:38:03 +0300

> This patchset contains performance improvements, support for new devices
> and functionality:
> 
> 1. Support for upcoming ENA devices
> 2. Avoid unnecessary IRQ unmasking in busy poll to reduce interrupt rate
> 3. Enabling device support for RSS function and key manipulation
> 4. Support for NIC-based traffic mirroring (SPAN port)
> 5. Additional PCI device ID
> 6. Cosmetic changes

Series applied, thanks.
