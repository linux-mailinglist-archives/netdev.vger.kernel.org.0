Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A85121A7CF
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgGITao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgGITao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:30:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0E8C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 12:30:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDD0412790335;
        Thu,  9 Jul 2020 12:30:41 -0700 (PDT)
Date:   Thu, 09 Jul 2020 12:30:39 -0700 (PDT)
Message-Id: <20200709.123039.1585505016635613210.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, irusskikh@marvell.com,
        mkalderon@marvell.com
Subject: Re: [PATCH net v3 1/1] qed: Populate nvm-file attributes while
 reading nvm config partition.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200709031429.8267-1-skalluru@marvell.com>
References: <20200709031429.8267-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jul 2020 12:30:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Wed, 8 Jul 2020 20:14:29 -0700

> NVM config file address will be modified when the MBI image is upgraded.
> Driver would return stale config values if user reads the nvm-config
> (via ethtool -d) in this state. The fix is to re-populate nvm attribute
> info while reading the nvm config values/partition.
> 
> Changes from previous version:
> -------------------------------
> v3: Corrected the formatting in 'Fixes' tag.
> v2: Added 'Fixes' tag.
> 
> Fixes: 1ac4329a1cff ("qed: Add configuration information to register dump and debug data")
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

Applied, thanks.
