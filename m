Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A584927BA5F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgI2BjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2BjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:39:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C32C061755;
        Mon, 28 Sep 2020 18:39:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E743B1279E311;
        Mon, 28 Sep 2020 18:22:33 -0700 (PDT)
Date:   Mon, 28 Sep 2020 18:39:20 -0700 (PDT)
Message-Id: <20200928.183920.1112211279234288010.davem@davemloft.net>
To:     wilken.gottwalt@mailbox.org
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: usb: ax88179_178a: add MCT usb 3.0 adapter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928091740.GA27844@monster.powergraphx.local>
References: <20200928091740.GA27844@monster.powergraphx.local>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 18:22:34 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Date: Mon, 28 Sep 2020 11:17:40 +0200

> Adds the driver_info and usb ids of the AX88179 based MCT U3-A9003 USB
> 3.0 ethernet adapter.
> 
> Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>

Applied.
