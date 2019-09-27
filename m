Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77CACC0B0D
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbfI0S3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:29:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35254 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbfI0S3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:29:09 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7FAC153EF900;
        Fri, 27 Sep 2019 11:29:06 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:29:05 +0200 (CEST)
Message-Id: <20190927.202905.2156096619479919255.davem@davemloft.net>
To:     haan@cellavision.se
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, hans.andersson@cellavision.se
Subject: Re: [PATCH] net: phy: micrel: add Asym Pause workaround for KSZ9021
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190926075437.18088-1-haan@cellavision.se>
References: <20190926075437.18088-1-haan@cellavision.se>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:29:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Andersson <haan@cellavision.se>
Date: Thu, 26 Sep 2019 09:54:37 +0200

> From: Hans Andersson <hans.andersson@cellavision.se>
> 
> The Micrel KSZ9031 PHY may fail to establish a link when the Asymmetric
> Pause capability is set. This issue is described in a Silicon Errata
> (DS80000691D or DS80000692D), which advises to always disable the
> capability.
> 
> Micrel KSZ9021 has no errata, but has the same issue with Asymmetric Pause.
> This patch apply the same workaround as the one for KSZ9031.
> 
> Signed-off-by: Hans Andersson <hans.andersson@cellavision.se>

Applied and queued up for -stable.
