Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B582160A2
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgGFUxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGFUxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:53:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB35DC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:46:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01315120F19C8;
        Mon,  6 Jul 2020 13:46:11 -0700 (PDT)
Date:   Mon, 06 Jul 2020 13:46:11 -0700 (PDT)
Message-Id: <20200706.134611.1669469964883291908.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     olteanv@gmail.com, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH v2 net-next 0/6] PHYLINK integration improvements for
 Felix DSA driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706203924.GV1551@shell.armlinux.org.uk>
References: <20200706084503.GU1551@shell.armlinux.org.uk>
        <20200706.125454.557093783656648876.davem@davemloft.net>
        <20200706203924.GV1551@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 13:46:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Mon, 6 Jul 2020 21:39:24 +0100

> On Mon, Jul 06, 2020 at 12:54:54PM -0700, David Miller wrote:
>> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
>> Date: Mon, 6 Jul 2020 09:45:04 +0100
>> 
>> > v3 was posted yesterday...
>> 
>> My tree is immutable, so you know what that means :-)
> 
> I was wondering whether there was a reason why you merged v2 when v3 had
> already been posted.

I simply missed it, so relative fixups need to be sent to me.
