Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4334E1AF599
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgDRWqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgDRWqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:46:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC6EC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:46:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EBB161277A25C;
        Sat, 18 Apr 2020 15:46:20 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:46:19 -0700 (PDT)
Message-Id: <20200418.154619.111077385348982404.davem@davemloft.net>
To:     mail@david-bauer.net
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: at803x: add support for AR8032 PHY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200417134159.427556-1-mail@david-bauer.net>
References: <20200417134159.427556-1-mail@david-bauer.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:46:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Bauer <mail@david-bauer.net>
Date: Fri, 17 Apr 2020 15:41:59 +0200

> This adds support for the Qualcomm Atheros AR8032 Fast Ethernet PHY.
> 
> It shares many similarities with the already supported AR8030 PHY but
> additionally supports MII connection to the MAC.
> 
> Signed-off-by: David Bauer <mail@david-bauer.net>

Applied to net-next, thanks.
