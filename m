Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7AD58838
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfF0RW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:22:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56802 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfF0RW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:22:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E1E314DB875E;
        Thu, 27 Jun 2019 10:22:57 -0700 (PDT)
Date:   Thu, 27 Jun 2019 10:22:56 -0700 (PDT)
Message-Id: <20190627.102256.1839462093915893704.davem@davemloft.net>
To:     maxime.ripard@bootlin.com
Cc:     mark.rutland@arm.com, robh+dt@kernel.org, frowand.list@gmail.com,
        wens@csie.org, mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        maxime.chevallier@bootlin.com, antoine.tenart@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH v4 00/13] net: Add generic and Allwinner YAML bindings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.e80da8845680a45c2e07d5f17280fdba84555b8a.1561649505.git-series.maxime.ripard@bootlin.com>
References: <cover.e80da8845680a45c2e07d5f17280fdba84555b8a.1561649505.git-series.maxime.ripard@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 10:22:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>
Date: Thu, 27 Jun 2019 17:31:42 +0200

> This is an attempt at getting the main generic DT bindings for the ethernet
> (and related) devices, and convert some DT bindings for the Allwinner DTs
> to YAML as well.
> 
> This should provide some DT validation coverage.

I don't think this should go via my tree as it's all DT stuff.
