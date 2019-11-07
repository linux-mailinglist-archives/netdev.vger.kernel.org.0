Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E85F3C02
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfKGXON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:14:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49658 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfKGXOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:14:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 72FEE15363D6D;
        Thu,  7 Nov 2019 15:14:12 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:14:09 -0800 (PST)
Message-Id: <20191107.151409.1123596566825003561.davem@davemloft.net>
To:     alexander.sverdlin@nokia.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: octeon_mgmt: Account for second
 possible VLAN header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191106153125.118789-1-alexander.sverdlin@nokia.com>
References: <20191106153125.118789-1-alexander.sverdlin@nokia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:14:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
Date: Wed, 6 Nov 2019 15:32:01 +0000

> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> Octeon's input ring-buffer entry has 14 bits-wide size field, so to account
> for second possible VLAN header max_mtu must be further reduced.
> 
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Please repost this with an appropriate Fixes: tag added.
