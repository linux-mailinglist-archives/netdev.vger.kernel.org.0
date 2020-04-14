Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F1B1A8F3B
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 01:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392189AbgDNXjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 19:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392187AbgDNXj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 19:39:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8E2C061A0C
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 16:39:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2047B1280C7BD;
        Tue, 14 Apr 2020 16:39:27 -0700 (PDT)
Date:   Tue, 14 Apr 2020 16:39:26 -0700 (PDT)
Message-Id: <20200414.163926.1995972662164307404.davem@davemloft.net>
To:     atsushi.nemoto@sord.co.jp
Cc:     netdev@vger.kernel.org, tomonori.sakita@sord.co.jp
Subject: Re: [PATCH] net: stmmac: socfpga: Allow all RGMII modes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200414.101234.1930009524396577448.atsushi.nemoto@sord.co.jp>
References: <20200414.101234.1930009524396577448.atsushi.nemoto@sord.co.jp>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Apr 2020 16:39:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Date: Tue, 14 Apr 2020 10:12:34 +0900 (JST)

> Allow all the RGMII modes to be used.  (Not only "rgmii", "rgmii-id"
> but "rgmii-txid", "rgmii-rxid")
> 
> Signed-off-by: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>

Applied, thanks.
