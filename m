Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5221279565
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgIZAIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgIZAH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 20:07:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAE8C0613CE;
        Fri, 25 Sep 2020 17:07:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC83513BA1192;
        Fri, 25 Sep 2020 16:51:11 -0700 (PDT)
Date:   Fri, 25 Sep 2020 17:07:58 -0700 (PDT)
Message-Id: <20200925.170758.120865648433529005.davem@davemloft.net>
To:     wilken.gottwalt@mailbox.org
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: ax88179_178a: add Toshiba usb 3.0 adapter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925135857.GA102845@monster.powergraphx.local>
References: <20200925135857.GA102845@monster.powergraphx.local>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:51:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Date: Fri, 25 Sep 2020 15:58:57 +0200

> Adds the driver_info and usb ids of the AX88179 based Toshiba USB 3.0
> ethernet adapter.
> 
> Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>

Applied.
