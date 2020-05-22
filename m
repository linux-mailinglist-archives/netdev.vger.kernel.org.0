Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EEE1DDC2D
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgEVAbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgEVAbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:31:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A317C061A0E;
        Thu, 21 May 2020 17:31:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 236F9120ED486;
        Thu, 21 May 2020 17:31:07 -0700 (PDT)
Date:   Thu, 21 May 2020 17:31:05 -0700 (PDT)
Message-Id: <20200521.173105.157572657643183117.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: mscc: fix initialization of the
 MACsec protocol mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200520100355.587686-1-antoine.tenart@bootlin.com>
References: <20200520100355.587686-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 17:31:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Wed, 20 May 2020 12:03:55 +0200

> What's the best way to handle this? I can provide all the patches.

Resubmit this against 'net' please, then I'll deal with the fallout
when I merge net into net-next.
