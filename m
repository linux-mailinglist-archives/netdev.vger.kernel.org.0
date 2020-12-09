Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52DC2D374F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730527AbgLIAB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730241AbgLIAB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:01:28 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45546C0613CF;
        Tue,  8 Dec 2020 16:00:48 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 9DD564D248DBF;
        Tue,  8 Dec 2020 16:00:47 -0800 (PST)
Date:   Tue, 08 Dec 2020 16:00:46 -0800 (PST)
Message-Id: <20201208.160046.1210704223846709688.davem@davemloft.net>
To:     johan.hedberg@gmail.com
Cc:     kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2020-12-07
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201207150915.GA10957@johnypau-MOBL2.ger.corp.intel.com>
References: <20201207150915.GA10957@johnypau-MOBL2.ger.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 16:00:47 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hedberg <johan.hedberg@gmail.com>
Date: Mon, 7 Dec 2020 17:09:15 +0200

> Hi Dave, Jakub,
> 
> Here's the main bluetooth-next pull request for the 5.11 kernel.
> 
>  - Updated Bluetooth entries in MAINTAINERS to include Luiz von Dentz
>  - Added support for Realtek 8822CE and 8852A devices
>  - Added support for MediaTek MT7615E device
>  - Improved workarounds for fake CSR devices
>  - Fix Bluetooth qualification test case L2CAP/COS/CFD/BV-14-C
>  - Fixes for LL Privacy support
>  - Enforce 16 byte encryption key size for FIPS security level
>  - Added new mgmt commands for extended advertising support
>  - Multiple other smaller fixes & improvements
> 
> Please let me know if there are any issues pulling. Thanks.

Pulled, thanks Johan.
