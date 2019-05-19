Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBF6227DA
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbfESRff convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 19 May 2019 13:35:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41188 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfESRfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 13:35:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B546C13F0734F;
        Sun, 19 May 2019 10:35:33 -0700 (PDT)
Date:   Sun, 19 May 2019 10:35:33 -0700 (PDT)
Message-Id: <20190519.103533.1752298588551711978.davem@davemloft.net>
To:     ynezz@true.cz
Cc:     robh+dt@kernel.org, frowand.list@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, mlindner@marvell.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of_net: fix of_get_mac_address retval if compiled
 without CONFIG_OF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558268324-5596-1-git-send-email-ynezz@true.cz>
References: <1558268324-5596-1-git-send-email-ynezz@true.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 May 2019 10:35:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr ¦tetiar <ynezz@true.cz>
Date: Sun, 19 May 2019 14:18:44 +0200

> of_get_mac_address prior to commit d01f449c008a ("of_net: add NVMEM
> support to of_get_mac_address") could return only valid pointer or NULL,
> after this change it could return only valid pointer or ERR_PTR encoded
> error value, but I've forget to change the return value of
> of_get_mac_address in case where the kernel is compiled without
> CONFIG_OF, so I'm doing so now.
> 
> Cc: Mirko Lindner <mlindner@marvell.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
> Reported-by: Octavio Alvarez <octallk1@alvarezp.org>
> Signed-off-by: Petr ¦tetiar <ynezz@true.cz>

Applied, thanks.
