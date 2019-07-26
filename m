Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C26F777345
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfGZVLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:11:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55158 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfGZVLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:11:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD9B312B88C13;
        Fri, 26 Jul 2019 14:11:49 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:11:49 -0700 (PDT)
Message-Id: <20190726.141149.2082260287271973845.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     alexandre.belloni@bootlin.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net] ocelot: Cancel delayed work before wq destruction
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564061598-4440-1-git-send-email-claudiu.manoil@nxp.com>
References: <1564061598-4440-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jul 2019 14:11:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Thu, 25 Jul 2019 16:33:18 +0300

> Make sure the delayed work for stats update is not pending before
> wq destruction.
> This fixes the module unload path.
> The issue is there since day 1.
> 
> Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied, thanks.
