Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34D8128747
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfLUFHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:07:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56788 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfLUFHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:07:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D9E2153CA108;
        Fri, 20 Dec 2019 21:07:11 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:07:10 -0800 (PST)
Message-Id: <20191220.210710.851288695476146210.davem@davemloft.net>
To:     m.grzeschik@pengutronix.de
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] net: dsa: ksz: use common define for tag len
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191218160139.26972-1-m.grzeschik@pengutronix.de>
References: <20191218160139.26972-1-m.grzeschik@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:07:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>
Date: Wed, 18 Dec 2019 17:01:39 +0100

> Remove special taglen define KSZ8795_INGRESS_TAG_LEN
> and use generic KSZ_INGRESS_TAG_LEN instead.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Applied, thank you.
