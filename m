Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387ED21A82B
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgGITu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgGITuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:50:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B336AC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 12:50:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D71261279796A;
        Thu,  9 Jul 2020 12:50:24 -0700 (PDT)
Date:   Thu, 09 Jul 2020 12:50:24 -0700 (PDT)
Message-Id: <20200709.125024.1556154096943379616.davem@davemloft.net>
To:     akiyano@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        ndagan@amazon.com, shayagr@amazon.com, sameehj@amazon.com
Subject: Re: [PATCH V1 net-next 2/8] net: ena: add reserved PCI device ID
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1594321503-12256-3-git-send-email-akiyano@amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
        <1594321503-12256-3-git-send-email-akiyano@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jul 2020 12:50:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <akiyano@amazon.com>
Date: Thu, 9 Jul 2020 22:04:57 +0300

> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> Add a reserved PCI device ID to the driver's table
> 
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>

No explanation whatsoever what this reserved ID is, what it is used
for, and why it should be used in the PCI ID table used for probing
and discovery of devices.

You have to be more verbose than this, please...
