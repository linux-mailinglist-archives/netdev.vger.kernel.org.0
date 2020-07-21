Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294B9228C3A
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731361AbgGUWvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUWvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:51:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215E6C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 15:51:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA70911E45904;
        Tue, 21 Jul 2020 15:34:21 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:51:06 -0700 (PDT)
Message-Id: <20200721.155106.1818913050234118207.davem@davemloft.net>
To:     ybason@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com
Subject: Re: [PATCH net-next] qed: Fix ILT and XRCD bitmap memory leaks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721113426.32260-1-ybason@marvell.com>
References: <20200721113426.32260-1-ybason@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:34:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuval Basson <ybason@marvell.com>
Date: Tue, 21 Jul 2020 14:34:26 +0300

> - Free ILT lines used for XRC-SRQ's contexts.
> - Free XRCD bitmap
> 
> Fixes: b8204ad878ce7 ("qed: changes to ILT to support XRC")
> Fixes: 7bfb399eca460 ("qed: Add XRC to RoCE")
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Yuval Basson <ybason@marvell.com>

Applied.
