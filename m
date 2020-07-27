Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9FE22F7D0
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbgG0Sge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgG0Sge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:36:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68735C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:36:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8062C11DB3142;
        Mon, 27 Jul 2020 11:19:46 -0700 (PDT)
Date:   Mon, 27 Jul 2020 11:36:29 -0700 (PDT)
Message-Id: <20200727.113629.107398328821127489.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next 00/10] bnxt_en update.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
References: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 11:19:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 26 Jul 2020 23:29:36 -0400

> This patchset removes the PCIe histogram and other debug register
> data from ethtool -S. The removed data are not counters and they have
> very large and constantly fluctuating values that are not suitable for
> the ethtool -S decimal counter display.
> 
> The rest of the patches implement counter rollover for all hardware
> counters that are not 64-bit counters.  Different generations of
> hardware have different counter widths.  The driver will now query
> the counter widths of all counters from firmware and implement
> rollover support on all non-64-bit counters.
> 
> The last patch adds the PCIe histogram and other PCIe register data back
> using the ethtool -d interface.

I guess you missed the necessary infiniband driver updates necessary
with the firmware interface changes?
