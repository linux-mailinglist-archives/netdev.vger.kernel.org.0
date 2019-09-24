Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E941EBCA83
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 16:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441417AbfIXOpb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Sep 2019 10:45:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52592 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfIXOpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 10:45:31 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB0881527F8DE;
        Tue, 24 Sep 2019 07:45:29 -0700 (PDT)
Date:   Tue, 24 Sep 2019 16:45:28 +0200 (CEST)
Message-Id: <20190924.164528.724219923520816886.davem@davemloft.net>
To:     uwe@kleine-koenig.org
Cc:     talgi@mellanox.com, saeedm@mellanox.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] dimlib: make DIMLIB a hidden symbol
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190920133115.12802-1-uwe@kleine-koenig.org>
References: <20190920133115.12802-1-uwe@kleine-koenig.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Sep 2019 07:45:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Uwe Kleine-König <uwe@kleine-koenig.org>
Date: Fri, 20 Sep 2019 15:31:15 +0200

> According to Tal Gilboa the only benefit from DIM comes from a driver
> that uses it. So it doesn't make sense to make this symbol user visible,
> instead all drivers that use it should select it (as is already the case
> AFAICT).
> 
> Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>

Since this doesn't apply due to the moderation typo being elsewhere, I'd
really like you to fix up this submission to properly be against 'net'.

Thank you.
