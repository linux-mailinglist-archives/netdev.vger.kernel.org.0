Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 270C86B009
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 21:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388662AbfGPTlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 15:41:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57180 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbfGPTlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 15:41:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 54EC01522472D;
        Tue, 16 Jul 2019 12:41:48 -0700 (PDT)
Date:   Tue, 16 Jul 2019 12:41:47 -0700 (PDT)
Message-Id: <20190716.124147.446749376298800402.davem@davemloft.net>
To:     bpoirier@suse.com
Cc:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        fyang@suse.com, saeedm@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] be2net: Signal that the device cannot transmit
 during reconfiguration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190716081655.7676-1-bpoirier@suse.com>
References: <20190716081655.7676-1-bpoirier@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jul 2019 12:41:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.com>
Date: Tue, 16 Jul 2019 17:16:55 +0900

> While changing the number of interrupt channels, be2net stops adapter
> operation (including netif_tx_disable()) but it doesn't signal that it
> cannot transmit. This may lead dev_watchdog() to falsely trigger during
> that time.
> 
> Add the missing call to netif_carrier_off(), following the pattern used in
> many other drivers. netif_carrier_on() is already taken care of in
> be_open().
> 
> Signed-off-by: Benjamin Poirier <bpoirier@suse.com>

Applied.
