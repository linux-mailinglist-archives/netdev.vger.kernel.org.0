Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F112D98B5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 19:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbfJPRq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 13:46:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52258 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbfJPRq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 13:46:27 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB485142395D5;
        Wed, 16 Oct 2019 10:46:26 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:46:26 -0400 (EDT)
Message-Id: <20191016.134626.2020955495176386867.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, hkallweit1@gmail.com,
        sean.nyekjaer@prevas.dk, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH net V4 1/2] net: phy: micrel: Discern KSZ8051 and
 KSZ8795 PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c7ff59cb-0ee7-b746-c54b-6e718ab62c28@denx.de>
References: <20191013212404.31708-1-marex@denx.de>
        <20191015.174209.218969750454729705.davem@davemloft.net>
        <c7ff59cb-0ee7-b746-c54b-6e718ab62c28@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Oct 2019 10:46:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Wed, 16 Oct 2019 15:39:18 +0200

> Maybe next time we can do these exercises on patches which are not
> bugfixes for real issues?

No, we should put changes into the tree which are correctly formed.

If you're not interested in learning how to submit changes properly,
we am not interested in accepting your work.

It's as simple as that.
