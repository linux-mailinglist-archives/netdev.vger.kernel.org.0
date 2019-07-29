Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6551A7912E
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387826AbfG2QjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:39:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35604 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfG2QjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:39:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDE9F12662B76;
        Mon, 29 Jul 2019 09:39:03 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:39:03 -0700 (PDT)
Message-Id: <20190729.093903.637838713920137841.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     m.grzeschik@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        keescook@chromium.org
Subject: Re: [PATCH] arcnet: com90io: Mark expected switch fall-throughs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729111320.GA3193@embeddedor>
References: <20190729111320.GA3193@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 09:39:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Mon, 29 Jul 2019 06:13:20 -0500

> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following warnings (Building: powerpc allyesconfig):
 ...
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied.
