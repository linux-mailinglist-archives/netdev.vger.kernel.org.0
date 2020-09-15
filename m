Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CCB26AF31
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgIOVIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbgIOU2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:28:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4FBC06174A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 13:28:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7067C13682872;
        Tue, 15 Sep 2020 13:11:51 -0700 (PDT)
Date:   Tue, 15 Sep 2020 13:28:37 -0700 (PDT)
Message-Id: <20200915.132837.1353627986155410882.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] ionic: dynamic interrupt moderation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915013345.27309-1-snelson@pensando.io>
References: <20200915013345.27309-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 13:11:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon, 14 Sep 2020 18:33:45 -0700

> Use the dim library to manage dynamic interrupt
> moderation in ionic.
> 
> v2: untangled declarations in ionic_dim_work()
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

This doesn't apply cleanly to net-next, please respin.
