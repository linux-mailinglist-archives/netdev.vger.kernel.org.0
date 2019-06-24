Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8875198E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732467AbfFXR3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:29:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfFXR33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:29:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5520C15065090;
        Mon, 24 Jun 2019 10:29:28 -0700 (PDT)
Date:   Mon, 24 Jun 2019 10:29:27 -0700 (PDT)
Message-Id: <20190624.102927.1268781741493594465.davem@davemloft.net>
To:     megous@megous.com
Cc:     linux-sunxi@googlegroups.com, maxime.ripard@bootlin.com,
        wens@csie.org, robh+dt@kernel.org, jernej.skrabec@gmail.com,
        airlied@linux.ie, daniel@ffwll.ch, mark.rutland@arm.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH v7 0/6] Add support for Orange Pi 3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190620134748.17866-1-megous@megous.com>
References: <20190620134748.17866-1-megous@megous.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 10:29:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: megous@megous.com
Date: Thu, 20 Jun 2019 15:47:42 +0200

> From: Ondrej Jirman <megous@megous.com>
> 
> This series implements support for Xunlong Orange Pi 3 board.
> 
> - ethernet support (patches 1-3)
> - HDMI support (patches 4-6)
> 
> For some people, ethernet doesn't work after reboot (but works on cold
> boot), when the stmmac driver is built into the kernel. It works when
> the driver is built as a module. It's either some timing issue, or power
> supply issue or a combination of both. Module build induces a power
> cycling of the phy.
> 
> I encourage people with this issue, to build the driver into the kernel,
> and try to alter the reset timings for the phy in DTS or
> startup-delay-us and report the findings.

This is a mixture of networking and non-networking changes so it really
can't go through my tree.

I wonder how you expect this series to be merged?

Thanks.
