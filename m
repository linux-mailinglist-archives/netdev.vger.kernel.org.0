Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB46C007E
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 09:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfI0H6v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 27 Sep 2019 03:58:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56942 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfI0H6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 03:58:51 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A26C14DB8491;
        Fri, 27 Sep 2019 00:58:49 -0700 (PDT)
Date:   Fri, 27 Sep 2019 09:51:30 +0200 (CEST)
Message-Id: <20190927.095130.1501090569750608526.davem@davemloft.net>
To:     uwe@kleine-koenig.org
Cc:     talgi@mellanox.com, saeedm@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] dimlib: make DIMLIB a hidden symbol
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190924160259.10987-1-uwe@kleine-koenig.org>
References: <20190924.164528.724219923520816886.davem@davemloft.net>
        <20190924160259.10987-1-uwe@kleine-koenig.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 00:58:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Uwe Kleine-König <uwe@kleine-koenig.org>
Date: Tue, 24 Sep 2019 18:02:59 +0200

> According to Tal Gilboa the only benefit from DIM comes from a driver
> that uses it. So it doesn't make sense to make this symbol user visible,
> instead all drivers that use it should select it (as is already the case
> AFAICT).
> 
> Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>

Applied.
