Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C085170D4B
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 01:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgB0Aju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 19:39:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35320 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgB0Aju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 19:39:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D29E915ADF427;
        Wed, 26 Feb 2020 16:39:49 -0800 (PST)
Date:   Wed, 26 Feb 2020 16:39:49 -0800 (PST)
Message-Id: <20200226.163949.936741955680517789.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Forcibly configure IMP port for
 1Gb/sec
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224235632.5163-1-f.fainelli@gmail.com>
References: <20200224235632.5163-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 16:39:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 24 Feb 2020 15:56:32 -0800

> We are still experiencing some packet loss with the existing advanced
> congestion buffering (ACB) settings with the IMP port configured for
> 2Gb/sec, so revert to conservative link speeds that do not produce
> packet loss until this is resolved.
> 
> Fixes: 8f1880cbe8d0 ("net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec")
> Fixes: de34d7084edd ("net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for v5.5 -stable.

Thanks.
