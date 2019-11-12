Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEB24F9A90
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKLUZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:25:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49232 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKLUZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:25:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E68F154D4A47;
        Tue, 12 Nov 2019 12:25:45 -0800 (PST)
Date:   Tue, 12 Nov 2019 12:25:44 -0800 (PST)
Message-Id: <20191112.122544.356627523822808563.davem@davemloft.net>
To:     Bryan.Whitehead@microchip.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v1 net-next] mscc.c: Add support for additional VSC PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573574048-12251-1-git-send-email-Bryan.Whitehead@microchip.com>
References: <1573574048-12251-1-git-send-email-Bryan.Whitehead@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 12:25:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bryan Whitehead <Bryan.Whitehead@microchip.com>
Date: Tue, 12 Nov 2019 10:54:08 -0500

>  		phy = container_of(map[addr], struct phy_device, mdio);

Unnecessary space added between this assignment and the test.

> +		if (!phy)
> +			continue;

And this test makes no sense, the result of container_of() is never NULL
unless it is for the first member of a structure of a NULL pointer.
