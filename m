Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F81D1F08FF
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 00:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgFFWnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 18:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbgFFWnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 18:43:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13247C03E96A
        for <netdev@vger.kernel.org>; Sat,  6 Jun 2020 15:43:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9CECE1274DFD7;
        Sat,  6 Jun 2020 15:43:51 -0700 (PDT)
Date:   Sat, 06 Jun 2020 15:43:49 -0700 (PDT)
Message-Id: <20200606.154349.1936374060527295254.davem@davemloft.net>
To:     tseewald@gmail.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com, kuba@kernel.org
Subject: Re: [PATCH v2] cxgb4: Fix 'defined but not used' warning for
 cxgb4_uld_in_use()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAARYdbiGzOOXcU5ny3hM2VxV4944mUYt-H5uzyq9w+230Xdriw@mail.gmail.com>
References: <20200605000748.31442-1-tseewald@gmail.com>
        <20200605013632.781-1-tseewald@gmail.com>
        <CAARYdbiGzOOXcU5ny3hM2VxV4944mUYt-H5uzyq9w+230Xdriw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 06 Jun 2020 15:43:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Seewald <tseewald@gmail.com>
Date: Sat, 6 Jun 2020 01:04:21 -0500

>> This doesn't apply to the net GIT tree.
> Apologies, this fix is for net-next. Let me know if I should resend.

Right now net == net-next, and no new changes are going into net-next.
