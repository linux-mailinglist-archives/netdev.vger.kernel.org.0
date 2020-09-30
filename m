Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E83227F411
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgI3VSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728031AbgI3VSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 17:18:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079EFC061755;
        Wed, 30 Sep 2020 14:18:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CBFC313C66FF6;
        Wed, 30 Sep 2020 14:01:43 -0700 (PDT)
Date:   Wed, 30 Sep 2020 14:18:30 -0700 (PDT)
Message-Id: <20200930.141830.2305767061881178696.davem@davemloft.net>
To:     alexandre.belloni@bootlin.com
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: macb: move pdata to private header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930105100.2956042-1-alexandre.belloni@bootlin.com>
References: <20200930105100.2956042-1-alexandre.belloni@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 30 Sep 2020 14:01:44 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>
Date: Wed, 30 Sep 2020 12:50:59 +0200

> struct macb_platform_data is only used by macb_pci to register the platform
> device, move its definition to cadence/macb.h and remove platform_data/macb.h
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Applied, thank you.
