Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45023A8878
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhFOSYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhFOSYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 14:24:52 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD50C061574;
        Tue, 15 Jun 2021 11:22:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E91A74D257153;
        Tue, 15 Jun 2021 11:22:45 -0700 (PDT)
Date:   Tue, 15 Jun 2021 11:22:42 -0700 (PDT)
Message-Id: <20210615.112242.1470575442069805806.davem@davemloft.net>
To:     pavel@denx.de
Cc:     linux-kernel@vger.kernel.org, colin.king@canonical.com,
        rajur@chelsio.com, kuba@kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] cxgb4: fix wrong shift.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210615095651.GA7479@duo.ucw.cz>
References: <20210615095651.GA7479@duo.ucw.cz>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 15 Jun 2021 11:22:46 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Machek <pavel@denx.de>
Date: Tue, 15 Jun 2021 11:56:51 +0200

> While fixing coverity warning, commit
> dd2c79677375c37f8f9f8d663eb4708495d595ef introduced typo in shift
> value. Fix that.
>     
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

Please repost with an appropriate Fixes: tag, thank you.

