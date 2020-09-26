Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E750A279C9A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 23:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgIZVT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 17:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgIZVT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 17:19:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE62DC0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 14:19:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 207DF12A0275D;
        Sat, 26 Sep 2020 14:02:35 -0700 (PDT)
Date:   Sat, 26 Sep 2020 14:19:21 -0700 (PDT)
Message-Id: <20200926.141921.58520530847796423.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netdevsim: fix duplicated debugfs directory
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200926011913.3324120-1-kuba@kernel.org>
References: <20200926011913.3324120-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 26 Sep 2020 14:02:35 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 25 Sep 2020 18:19:13 -0700

> The "ethtool" debugfs directory holds per-netdev knobs, so move
> it from the device instance directory to the port directory.
> 
> This fixes the following warning when creating multiple ports:
> 
>  debugfs: Directory 'ethtool' with parent 'netdevsim1' already present!
> 
> Fixes: ff1f7c17fb20 ("netdevsim: add pause frame stats")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied.
