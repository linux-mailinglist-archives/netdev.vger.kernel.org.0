Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EFA317464
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhBJXaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:30:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47636 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbhBJXaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 18:30:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 6DDA84D25BDAF;
        Wed, 10 Feb 2021 15:29:30 -0800 (PST)
Date:   Wed, 10 Feb 2021 15:29:24 -0800 (PST)
Message-Id: <20210210.152924.767175240247395907.davem@davemloft.net>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, atenart@kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v12 net-next 12/15] net: mvpp2: add BM protection
 underrun feature support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1612950500-9682-13-git-send-email-stefanc@marvell.com>
References: <1612950500-9682-1-git-send-email-stefanc@marvell.com>
        <1612950500-9682-13-git-send-email-stefanc@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 10 Feb 2021 15:29:31 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <stefanc@marvell.com>
Date: Wed, 10 Feb 2021 11:48:17 +0200

>  
> +static int bm_underrun_protect = 1;
> +
> +module_param(bm_underrun_protect, int, 0444);
> +MODULE_PARM_DESC(bm_underrun_protect, "Set BM underrun protect feature (0-1), def=1");

No new module parameters, please.
