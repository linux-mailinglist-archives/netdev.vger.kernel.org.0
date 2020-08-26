Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24055253A9C
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 01:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgHZXVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 19:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgHZXVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 19:21:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5020DC061574;
        Wed, 26 Aug 2020 16:21:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A09412989970;
        Wed, 26 Aug 2020 16:04:48 -0700 (PDT)
Date:   Wed, 26 Aug 2020 16:21:33 -0700 (PDT)
Message-Id: <20200826.162133.1378636842290936380.davem@davemloft.net>
To:     rikard.falkeborn@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sergei.shtylyov@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        antoine.tenart@bootlin.com, kvalo@codeaurora.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] drivers/net: constify static ops-variables
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200826225608.90299-1-rikard.falkeborn@gmail.com>
References: <20200826225608.90299-1-rikard.falkeborn@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 16:04:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Date: Thu, 27 Aug 2020 00:56:02 +0200

> This series constifies a number of static ops variables, to allow the
> compiler to put them in read-only memory. Compile-tested only.

Series applied, thank you.
