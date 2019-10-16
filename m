Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 891E2D8641
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388897AbfJPDQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:16:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43764 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfJPDQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:16:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DAB2128F3863;
        Tue, 15 Oct 2019 20:16:48 -0700 (PDT)
Date:   Tue, 15 Oct 2019 20:16:48 -0700 (PDT)
Message-Id: <20191015.201648.1585995900214408426.davem@davemloft.net>
To:     nishadkamdar@gmail.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org, joe@perches.com,
        u.kleine-koenig@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: sja1105: Use the correct style for SPDX
 License Identifier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191014162116.GA5024@nishad>
References: <20191014162116.GA5024@nishad>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 20:16:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nishad Kamdar <nishadkamdar@gmail.com>
Date: Mon, 14 Oct 2019 21:51:20 +0530

> This patch corrects the SPDX License Identifier style
> in header files related to Distributed Switch Architecture
> drivers for NXP SJA1105 series Ethernet switch support.
> It uses an expilict block comment for the SPDX License
> Identifier.
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
> ---
> Changes in v2:
>   - Modify the commit message to reflect the changes done.
>   - Correct some indentation errors.

Applied, thanks.
