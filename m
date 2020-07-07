Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74002217B47
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgGGWuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729612AbgGGWup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:50:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93957C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 15:50:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 61E70120F19EC;
        Tue,  7 Jul 2020 15:50:45 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:50:44 -0700 (PDT)
Message-Id: <20200707.155044.341060322330270425.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] ionic: centralize queue reset code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200707211326.11291-1-snelson@pensando.io>
References: <20200707211326.11291-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:50:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Tue,  7 Jul 2020 14:13:26 -0700

> The queue reset pattern is used in a couple different places,
> only slightly different from each other, and could cause
> issues if one gets changed and the other didn't.  This puts
> them together so that only one version is needed, yet each
> can have slighty different effects by passing in a pointer
> to a work function to do whatever configuration twiddling is
> needed in the middle of the reset.
> 
> This specifically addresses issues seen where under loops
> of changing ring size or queue count parameters we could
> occasionally bump into the netdev watchdog.
> 
> v2: added more commit message commentary
> 
> Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied, thanks.
