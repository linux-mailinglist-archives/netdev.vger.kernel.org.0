Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BB522F8AB
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgG0TGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgG0TGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 15:06:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E94BC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 12:06:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ACE8C127567BB;
        Mon, 27 Jul 2020 11:49:24 -0700 (PDT)
Date:   Mon, 27 Jul 2020 12:06:08 -0700 (PDT)
Message-Id: <20200727.120608.2245293587733963820.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, laurent.brando@nxp.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH] net: mscc: ocelot: fix hardware timestamp dequeue logic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200727102614.24570-1-yangbo.lu@nxp.com>
References: <20200727102614.24570-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 11:49:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Mon, 27 Jul 2020 18:26:14 +0800

> From: laurent brando <laurent.brando@nxp.com>
> 
> The next hw timestamp should be snapshoot to the read registers
> only once the current timestamp has been read.
> If none of the pending skbs matches the current HW timestamp
> just gracefully flush the available timestamp by reading it.
> 
> Signed-off-by: laurent brando <laurent.brando@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Applied and queued up for -stable, thanks.

So you have to read the hwtimestamp, even if you won't use it for
any packets?
