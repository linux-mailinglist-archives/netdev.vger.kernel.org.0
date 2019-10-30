Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32A73EA3AD
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 19:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfJ3S5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 14:57:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44426 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfJ3S5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 14:57:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3183C1481AD0D;
        Wed, 30 Oct 2019 11:57:45 -0700 (PDT)
Date:   Wed, 30 Oct 2019 11:57:44 -0700 (PDT)
Message-Id: <20191030.115744.526482386771296686.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com, aelior@marvell.com
Subject: Re: [PATCH net 1/1] qed: Optimize execution time for nvm
 attributes configuration.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191030083958.21723-1-skalluru@marvell.com>
References: <20191030083958.21723-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 11:57:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Wed, 30 Oct 2019 01:39:58 -0700

> Current implementation for nvm_attr configuration instructs the management
> FW to load/unload the nvm-cfg image for each user-provided attribute in
> the input file. This consumes lot of cycles even for few tens of
> attributes.
> This patch updates the implementation to perform load/commit of the config
> for every 50 attributes. After loading the nvm-image, MFW expects that
> config should be committed in a predefined timer value (5 sec), hence it's
> not possible to write large number of attributes in a single load/commit
> window. Hence performing the commits in chunks.
> 
> Fixes: 0dabbe1bb3a4 ("qed: Add driver API for flashing the config attributes.")
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>

Applied.
