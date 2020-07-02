Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9F2212EEB
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 23:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgGBVeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 17:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgGBVeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 17:34:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC63C08C5C1;
        Thu,  2 Jul 2020 14:34:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 45D5212845092;
        Thu,  2 Jul 2020 14:34:02 -0700 (PDT)
Date:   Thu, 02 Jul 2020 14:34:01 -0700 (PDT)
Message-Id: <20200702.143401.332217728494688192.davem@davemloft.net>
To:     nicolas.ferre@microchip.com
Cc:     netdev@vger.kernel.org, claudiu.beznea@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com
Subject: Re: [PATCH] MAINTAINERS: net: macb: add Claudiu as co-maintainer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702130021.32694-1-nicolas.ferre@microchip.com>
References: <20200702130021.32694-1-nicolas.ferre@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jul 2020 14:34:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <nicolas.ferre@microchip.com>
Date: Thu, 2 Jul 2020 15:00:21 +0200

> From: Nicolas Ferre <nicolas.ferre@microchip.com>
> 
> I would like that Claudiu becomes co-maintainer of the Cadence macb
> driver. He's already participating to lots of reviews and enhancements
> to this driver and knows the different versions of this controller.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Applied, thank you.
