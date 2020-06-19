Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9AE201C61
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 22:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389066AbgFSU1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 16:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388274AbgFSU1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 16:27:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C67EC06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 13:27:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 647C211D69C3E;
        Fri, 19 Jun 2020 13:27:20 -0700 (PDT)
Date:   Fri, 19 Jun 2020 13:27:19 -0700 (PDT)
Message-Id: <20200619.132719.497506153850410801.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     fido_max@inbox.ru, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, kuba@kernel.org
Subject: Re: [PATCH 0/3] Add Marvell 88E1340S, 88E1548P support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619145802.GJ279339@lunn.ch>
References: <20200619084904.95432-1-fido_max@inbox.ru>
        <20200619145802.GJ279339@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 13:27:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Fri, 19 Jun 2020 16:58:02 +0200

> On Fri, Jun 19, 2020 at 11:49:01AM +0300, Maxim Kochetkov wrote:
>> This patch series add new PHY id support.
>> Russell King asked to use single style for referencing functions.
> 
> Hi Maxim
> 
> In future, please put which tree this patchset is for into the subject
> line:
> 
> [PATCH net-next v2] ...

This patch series doesn't apply to net-next.

It probably depends upon a recent change which is only in 'net'?
