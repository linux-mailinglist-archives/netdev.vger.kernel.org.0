Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63251245B59
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 06:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgHQEKF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Aug 2020 00:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgHQEKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 00:10:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458A3C061388
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 21:10:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1E0C1260D062;
        Sun, 16 Aug 2020 20:53:17 -0700 (PDT)
Date:   Sun, 16 Aug 2020 21:10:02 -0700 (PDT)
Message-Id: <20200816.211002.1955628031429504263.davem@davemloft.net>
To:     linus.luessing@c0d3.blue
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        gluon@luebeck.freifunk.net, openwrt-devel@lists.openwrt.org
Subject: Re: [RFC PATCH net-next] bridge: Implement MLD Querier wake-up
 calls / Android bug workaround
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200816202424.3526-1-linus.luessing@c0d3.blue>
References: <20200816202424.3526-1-linus.luessing@c0d3.blue>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Aug 2020 20:53:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>
Date: Sun, 16 Aug 2020 22:24:24 +0200

> I'm aware that this is quite a hack, so I'm unsure if this is suitable
> for upstream. On the other hand, the Android ticket isn't moving
> anywhere and even if it were fixed in Android, I'd expect it to take
> years until that fix would propagate or unpatched Android devices to
> vanish. So I'm wondering if it should be treated like a hardware bug
> workaround and by that should be suitable for applying it upstream in
> the Linux kernel?

Long after those Android devices are deprecated and no longer used, we
will still have this ugly hack in the tree.

Sorry, we're not doing this.
