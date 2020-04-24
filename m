Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8665B1B8291
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 01:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgDXXuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 19:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgDXXuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 19:50:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2529DC09B049;
        Fri, 24 Apr 2020 16:50:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE2BF14F4BE2C;
        Fri, 24 Apr 2020 16:50:17 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:50:17 -0700 (PDT)
Message-Id: <20200424.165017.1855738964527204381.davem@davemloft.net>
To:     opendmb@gmail.com
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: systemport: suppress warnings on failed
 Rx SKB allocations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587683610-4342-1-git-send-email-opendmb@gmail.com>
References: <1587683610-4342-1-git-send-email-opendmb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Apr 2020 16:50:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>
Date: Thu, 23 Apr 2020 16:13:30 -0700

> The driver is designed to drop Rx packets and reclaim the buffers
> when an allocation fails, and the network interface needs to safely
> handle this packet loss. Therefore, an allocation failure of Rx
> SKBs is relatively benign.
> 
> However, the output of the warning message occurs with a high
> scheduling priority that can cause excessive jitter/latency for
> other high priority processing.
> 
> This commit suppresses the warning messages to prevent scheduling
> problems while retaining the failure count in the statistics of
> the network interface.
> 
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Applied.
