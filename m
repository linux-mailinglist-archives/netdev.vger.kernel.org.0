Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396E8201FE3
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 04:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732059AbgFTCro convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Jun 2020 22:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732092AbgFTCri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 22:47:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2045C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 19:47:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDC0012780FD5;
        Fri, 19 Jun 2020 19:47:32 -0700 (PDT)
Date:   Fri, 19 Jun 2020 19:47:29 -0700 (PDT)
Message-Id: <20200619.194729.1459536350813756185.davem@davemloft.net>
To:     fido_max@inbox.ru
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, andrew@lunn.ch
Subject: Re: [PATCH 0/3] Add Marvell 88E1340S, 88E1548P support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592602289.1450270@f540.i.mail.ru>
References: <20200619145802.GJ279339@lunn.ch>
        <20200619.132719.497506153850410801.davem@davemloft.net>
        <1592602289.1450270@f540.i.mail.ru>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=koi8-r
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 19:47:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Кочетков Максим <fido_max@inbox.ru>
Date: Sat, 20 Jun 2020 00:31:29 +0300

> It is based on 5.7.0

You need to post your patches against the tree onto which it
will be applied, which in this case is net-next.
