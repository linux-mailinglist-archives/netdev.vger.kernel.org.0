Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07A420E176
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389958AbgF2Uz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731288AbgF2TNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C187CC08C5F8
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 21:40:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4231F129CE251;
        Sun, 28 Jun 2020 21:40:48 -0700 (PDT)
Date:   Sun, 28 Jun 2020 21:40:47 -0700 (PDT)
Message-Id: <20200628.214047.1363693841454221477.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com
Subject: Re: [PATCH net-next] net: mscc: ocelot: remove EXPORT_SYMBOL from
 ocelot_net.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200627120306.282071-1-olteanv@gmail.com>
References: <20200627120306.282071-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Jun 2020 21:40:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 27 Jun 2020 15:03:06 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Now that all net_device operations are bundled together inside
> mscc_ocelot.ko and no longer part of the common library, there's no
> reason to export these symbols.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks Vlad.
