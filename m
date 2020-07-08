Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01455218DF8
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbgGHRLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730120AbgGHRLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:11:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20F8C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 10:11:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 956F812745FFC;
        Wed,  8 Jul 2020 10:11:28 -0700 (PDT)
Date:   Wed, 08 Jul 2020 10:11:25 -0700 (PDT)
Message-Id: <20200708.101125.1866454022843102923.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, irusskikh@marvell.com,
        mkalderon@marvell.com
Subject: Re: [PATCH net v2 1/1] qed: Populate nvm-file attributes while
 reading nvm config partition.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708040737.17141-1-skalluru@marvell.com>
References: <20200708040737.17141-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 10:11:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Tue, 7 Jul 2020 21:07:37 -0700

> Fixes: 1ac4329a1cff (qed: Add configuration information to register dump and debug data)

This Fixes: tag is not formatted properly, the commit header text should be
inside of parenthesis as well as double quotes.

	Fixes: 1ac4329a1cff ("qed: Add configuration information to register dump and debug data")
