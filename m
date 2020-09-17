Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23DC26E9A9
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgIQX4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgIQX4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:56:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9138C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 16:56:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1766513667336;
        Thu, 17 Sep 2020 16:39:54 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:56:40 -0700 (PDT)
Message-Id: <20200917.165640.1281223578971864757.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net 0/2] net: phy: Unbind fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917034310.2360488-1-f.fainelli@gmail.com>
References: <20200917034310.2360488-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:39:54 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 16 Sep 2020 20:43:08 -0700

> This patch series fixes a couple of issues with the unbinding of the PHY
> drivers and then bringing down a network interface. The first is a NULL
> pointer de-reference and the second was an incorrect warning being
> triggered.

Series applied and queued up for -stable, thanks.
