Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D192259EB1
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732530AbgIASzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729072AbgIASxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:53:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B9AC061245;
        Tue,  1 Sep 2020 11:53:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 504D913632395;
        Tue,  1 Sep 2020 11:36:52 -0700 (PDT)
Date:   Tue, 01 Sep 2020 11:53:38 -0700 (PDT)
Message-Id: <20200901.115338.1041117882209940166.davem@davemloft.net>
To:     richardcochran@gmail.com
Cc:     andrew@lunn.ch, olteanv@gmail.com, kurt@linutronix.de,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, bigeasy@linutronix.de,
        kamil.alkhouri@hs-offenburg.de, ilias.apalodimas@linaro.org
Subject: Re: [PATCH v4 2/7] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200901163610.GD22807@hoboy>
References: <20200901142243.2jrurmfmh6znosxd@skbuf>
        <20200901155945.GG2403519@lunn.ch>
        <20200901163610.GD22807@hoboy>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 11:36:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Tue, 1 Sep 2020 09:36:10 -0700

> On Tue, Sep 01, 2020 at 05:59:45PM +0200, Andrew Lunn wrote:
>> Maybe, at the moment, RTNL is keeping things atomic. But that is
>> because there is no HWMON, or MDIO bus. Those sort of operations don't
>> take the RTNL, and so would be an issue. I've also never audited the
>> network stack to check RTNL really is held at all the network stack
>> entry points to a DSA driver. It would be an interesting excesses to
>> scatter some ASSERT_RTNL() in a DSA driver and see what happens.
> 
> Device drivers really aught to protect their state and their devices'
> state from concurrent access.

Completely agreed.
