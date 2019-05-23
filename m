Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697612733B
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbfEWAWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:22:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36486 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbfEWAWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:22:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B12815042EA8;
        Wed, 22 May 2019 17:22:05 -0700 (PDT)
Date:   Wed, 22 May 2019 17:21:44 -0700 (PDT)
Message-Id: <20190522.172144.190504285268899608.davem@davemloft.net>
To:     Claudiu.Beznea@microchip.com
Cc:     Nicolas.Ferre@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: macb: save/restore the remaining registers and
 features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558513467-8424-1-git-send-email-claudiu.beznea@microchip.com>
References: <1558513467-8424-1-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:22:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <Claudiu.Beznea@microchip.com>
Date: Wed, 22 May 2019 08:24:43 +0000

> From: Claudiu Beznea <claudiu.beznea@microchip.com>
> 
> SAMA5D2 SoC has a suspend mode where SoC's power is cut off. Due to this
> the registers content is lost after a suspend/resume cycle. The current
> suspend/resume implementation covers some of these registers. However
> there are few which were not treated (e.g. SCRT2 and USRIO). Apart
> from this, netdev features are not restored. Treat these issues.
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Applied.
