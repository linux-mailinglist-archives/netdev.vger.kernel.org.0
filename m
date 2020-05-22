Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4559E1DF2BB
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbgEVXKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731117AbgEVXKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:10:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D4FC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 16:10:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26F3A127505A4;
        Fri, 22 May 2020 16:10:17 -0700 (PDT)
Date:   Fri, 22 May 2020 16:10:16 -0700 (PDT)
Message-Id: <20200522.161016.1020289172839520752.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, dgcbueu@gmail.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH] net: mvneta: only do WoL speed down if the PHY is valid
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200521182010.GV1551@shell.armlinux.org.uk>
References: <20200521152656.GU1551@shell.armlinux.org.uk>
        <20200521155513.GE677363@lunn.ch>
        <20200521182010.GV1551@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 16:10:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Thu, 21 May 2020 19:20:10 +0100

> David, can you revert 5e3768a436bb70c9c3e27aaba6b73f8ef8f5dcf3 please?
> It's a layering violation, and as Andrew has found, it causes kernel
> oopses.

Done.
