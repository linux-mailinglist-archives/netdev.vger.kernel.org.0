Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4BFC3D2F
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387713AbfJAQ6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:58:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49568 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731314AbfJAQlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:41:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2241015458711;
        Tue,  1 Oct 2019 09:41:45 -0700 (PDT)
Date:   Tue, 01 Oct 2019 09:41:44 -0700 (PDT)
Message-Id: <20191001.094144.1520493336302505890.davem@davemloft.net>
To:     icenowy@aosc.io
Cc:     linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        andrew@lunn.ch, f.fainelli@gmail.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mripard@kernel.org, linux-sunxi@googlegroups.com,
        robh+dt@kernel.org, wens@csie.org, hkallweit1@gmail.com
Subject: Re: [PATCH 0/3] Pine64+ specific hacks for RTL8211E Ethernet PHY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <D1124458-D5CB-4AFF-B106-C6EA1A98100F@aosc.io>
References: <2CCD0856-433E-4602-A079-9F7F5F2E00D6@aosc.io>
        <20191001.093000.372726574458067639.davem@davemloft.net>
        <D1124458-D5CB-4AFF-B106-C6EA1A98100F@aosc.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 09:41:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>
Date: Wed, 02 Oct 2019 00:31:25 +0800

> I have tried to ask via TL Lim from Pine64, because I have no way
> to communicate directly to Realtek. However TL cannot get anything
> more from Realtek.

We have several Realtek developers who post here as part of maintaining
the upstream copy of their drivers, and upstream developers of other
Realtek parts who sometimes interact with Realtek.

Be creative and work with these people to try to get to the right
people.

Please stop making excuses and do the right thing.

Thank you.
