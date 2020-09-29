Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC75127BA5B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgI2Bio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgI2Bin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:38:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72DEC061755;
        Mon, 28 Sep 2020 18:38:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C63A61278D7D5;
        Mon, 28 Sep 2020 18:21:55 -0700 (PDT)
Date:   Mon, 28 Sep 2020 18:38:42 -0700 (PDT)
Message-Id: <20200928.183842.1755056497662404337.davem@davemloft.net>
To:     wilken.gottwalt@mailbox.org
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: ax88179_178a: fix missing stop entry in
 driver_info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928090104.GA27570@monster.powergraphx.local>
References: <20200928090104.GA27570@monster.powergraphx.local>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 18:21:55 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Date: Mon, 28 Sep 2020 11:01:04 +0200

> Adds the missing .stop entry in the Belkin driver_info structure.
> 
> Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
> ---
> Changes in v2:
>     - reposted to proper mailing list

Applied and queued up for -stable, please provide a proper Fixes: tag
next time.
