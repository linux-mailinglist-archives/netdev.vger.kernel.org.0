Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C17214963
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 02:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgGEAvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 20:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgGEAvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 20:51:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CD7C061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 17:51:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78044157A9A3F;
        Sat,  4 Jul 2020 17:51:22 -0700 (PDT)
Date:   Sat, 04 Jul 2020 17:51:21 -0700 (PDT)
Message-Id: <20200704.175121.1755433999423322740.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, irusskikh@marvell.com,
        mkalderon@marvell.com
Subject: Re: [PATCH net-next v3 0/3] bnx2x: Perform IdleChk dump.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593837824-26657-1-git-send-email-skalluru@marvell.com>
References: <1593837824-26657-1-git-send-email-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 04 Jul 2020 17:51:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Sat, 4 Jul 2020 10:13:41 +0530

> Idlechk test verifies that the chip is in idle state. If there are any
> errors, Idlechk dump would capture the same. This data will help in
> debugging the device related issues.
> The patch series adds driver support for dumping IdleChk data during the
> debug dump collection.
> Patch (1) adds register definitions required in this implementation.
> Patch (2) adds the implementation for Idlechk tests.
> Patch (3) adds driver changes to invoke Idlechk implementation.
> 
> 
> Changes from previous version:
> -------------------------------
> v3: Combined the test data creation and implementation to a single patch.
> v2: Addressed issues reported by kernel test robot.

Series applied, thanks.
