Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFDBBCA98
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 16:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409726AbfIXOtG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Sep 2019 10:49:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52636 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfIXOtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 10:49:06 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 173B615280446;
        Tue, 24 Sep 2019 07:49:04 -0700 (PDT)
Date:   Tue, 24 Sep 2019 16:49:03 +0200 (CEST)
Message-Id: <20190924.164903.1330933104318327465.davem@davemloft.net>
To:     u.kleine-koenig@pengutronix.de
Cc:     m.grzeschik@pengutronix.de, netdev@vger.kernel.org,
        labbott@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH] arcnet: provide a buffer big enough to actually
 receive packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190920140821.11876-1-u.kleine-koenig@pengutronix.de>
References: <20190920140821.11876-1-u.kleine-koenig@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Sep 2019 07:49:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date: Fri, 20 Sep 2019 16:08:21 +0200

> struct archdr is only big enough to hold the header of various types of
> arcnet packets. So to provide enough space to hold the data read from
> hardware provide a buffer large enough to hold a packet with maximal
> size.
> 
> The problem was noticed by the stack protector which makes the kernel
> oops.
> 
> Cc: stable@vger.kernel.org # v2.4.0+

Do not CC: stable for networking patches, I take care of it.

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Applied and queued up for -stable.
