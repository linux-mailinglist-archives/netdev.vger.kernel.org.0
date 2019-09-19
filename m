Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDD4CB74D0
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbfISINM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:13:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53280 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730886AbfISINH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 04:13:07 -0400
Received: from localhost (unknown [86.58.254.34])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1189154EE39F;
        Thu, 19 Sep 2019 01:13:04 -0700 (PDT)
Date:   Thu, 19 Sep 2019 10:13:02 +0200 (CEST)
Message-Id: <20190919.101302.1362348814209807468.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     olteanv@gmail.com, emamd001@umn.edu, smccaman@umn.edu,
        kjlu@umn.edu, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] net: dsa: sja1105: prevent leaking memory
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190918203407.23826-1-navid.emamdoost@gmail.com>
References: <8d6f6c54-1758-7d98-c9b5-5c16b171c885@gmail.com>
        <20190918203407.23826-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Sep 2019 01:13:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Wed, 18 Sep 2019 15:34:06 -0500

> Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port
> L2 switch")
> 
> Fixes: 1a4c69406cc1 ("net: dsa: sja1105: Prevent PHY jabbering during
> switch reset")

Please:

1) Do not break Fixes: tags into multiples lines, that way the string
   is easily greppable.

2) Do not separate the Fixes: from other tags with newlines.  It is
   just another tag like Signed-off-by: and Acked-by:

Thanks.
