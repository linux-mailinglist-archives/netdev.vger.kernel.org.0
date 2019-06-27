Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8727589B4
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfF0SRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:17:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57878 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF0SRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 14:17:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB4B2133EB08C;
        Thu, 27 Jun 2019 11:17:46 -0700 (PDT)
Date:   Thu, 27 Jun 2019 11:17:46 -0700 (PDT)
Message-Id: <20190627.111746.1633047892796421451.davem@davemloft.net>
To:     chunkeey@gmail.com
Cc:     netdev@vger.kernel.org, mark.rutland@arm.com, robh+dt@kernel.org,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH v1 2/2] net: dsa: qca8k: introduce reset via gpio
 feature
From:   David Miller <davem@davemloft.net>
In-Reply-To: <36b1e912b47bc079a78e06e05a33213833715314.1561452044.git.chunkeey@gmail.com>
References: <08e0fd513620f03a2207b9f32637cdb434ed8def.1561452044.git.chunkeey@gmail.com>
        <36b1e912b47bc079a78e06e05a33213833715314.1561452044.git.chunkeey@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 11:17:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>
Date: Tue, 25 Jun 2019 10:41:51 +0200

> The QCA8337(N) has a RESETn signal on Pin B42 that
> triggers a chip reset if the line is pulled low.
> The datasheet says that: "The active low duration
> must be greater than 10 ms".
> 
> This can hopefully fix some of the issues related
> to pin strapping in OpenWrt for the EA8500 which
> suffers from detection issues after a SoC reset.
> 
> Please note that the qca8k_probe() function does
> currently require to read the chip's revision
> register for identification purposes.
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>

Applied.
