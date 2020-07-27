Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740E522F86E
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgG0Std (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgG0Std (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:49:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505E0C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:49:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEA6D126B5A80;
        Mon, 27 Jul 2020 11:32:47 -0700 (PDT)
Date:   Mon, 27 Jul 2020 11:49:32 -0700 (PDT)
Message-Id: <20200727.114932.909077877657976448.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next v2 00/10] bnxt_en update.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
References: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 11:32:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Mon, 27 Jul 2020 05:40:35 -0400

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
> 
> v2: Fix bnxt_re RDMA driver compile issue.

This looks better, series applied, thanks Michael.
