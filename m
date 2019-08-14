Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEDE8D883
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbfHNQyL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Aug 2019 12:54:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56136 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbfHNQyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:54:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::202])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91D72154CD371;
        Wed, 14 Aug 2019 09:54:09 -0700 (PDT)
Date:   Wed, 14 Aug 2019 12:54:09 -0400 (EDT)
Message-Id: <20190814.125409.1827510929550167544.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org, edumazet@google.com,
        holger@applied-asynchrony.com
Subject: Re: [PATCH net-next] r8169: fix sporadic transmit timeout issue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e343933b-1965-4617-3011-6290ed30d4ae@gmail.com>
References: <e343933b-1965-4617-3011-6290ed30d4ae@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Aug 2019 09:54:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 12 Aug 2019 20:47:40 +0200

> Holger reported sporadic transmit timeouts and it turned out that one
> path misses ringing the doorbell. Fix was suggested by Eric.
> 
> Fixes: ef14358546b1 ("r8169: make use of xmit_more")
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
