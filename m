Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FAB2459CB
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 00:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbgHPWKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 18:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgHPWKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 18:10:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA8DC061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 15:10:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8DD88127EA607;
        Sun, 16 Aug 2020 14:53:57 -0700 (PDT)
Date:   Sun, 16 Aug 2020 15:10:40 -0700 (PDT)
Message-Id: <20200816.151040.1591962687263069414.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     linus.luessing@c0d3.blue, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org, gluon@luebeck.freifunk.net,
        openwrt-devel@lists.openwrt.org
Subject: Re: [Bridge] [RFC PATCH net-next] bridge: Implement MLD Querier
 wake-up calls / Android bug workaround
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200816150813.0b998607@hermes.lan>
References: <20200816202424.3526-1-linus.luessing@c0d3.blue>
        <20200816150813.0b998607@hermes.lan>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Aug 2020 14:53:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Sun, 16 Aug 2020 15:08:13 -0700

> Rather than adding yet another feature to the bridge, could this hack be done by
> having a BPF hook? or netfilter module?

Stephen please do not quote an entire huge patch just to add a small
amount of commentary at the end.

Thank you.
