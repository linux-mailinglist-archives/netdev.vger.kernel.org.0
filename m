Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABBC26965F
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgINUYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgINUYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 16:24:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA858C06174A;
        Mon, 14 Sep 2020 13:24:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 39C461273FF76;
        Mon, 14 Sep 2020 13:07:52 -0700 (PDT)
Date:   Mon, 14 Sep 2020 13:24:38 -0700 (PDT)
Message-Id: <20200914.132438.1323071673363556958.davem@davemloft.net>
To:     allen.lkml@gmail.com
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, apais@linux.microsoft.com
Subject: Re: [RESEND net-next v2 00/12]drivers: net: convert tasklets to
 use new tasklet_setup() API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200914073131.803374-1-allen.lkml@gmail.com>
References: <20200914073131.803374-1-allen.lkml@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 13:07:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>
Date: Mon, 14 Sep 2020 13:01:19 +0530

> From: Allen Pais <apais@linux.microsoft.com>
> 
> ommit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
> introduced a new tasklet initialization API. This series converts
> all the net/* drivers to use the new tasklet_setup() API
> 
> This series is based on v5.9-rc5

I don't understand how this works, you're not passing the existing
parameter any more so won't that crash until the final parts of the
conversion?

This is like a half-transformation that will break bisection.

I'm not applying this series, sorry.
