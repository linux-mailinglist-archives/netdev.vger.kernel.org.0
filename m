Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C9CEA854
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfJaAnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:43:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48924 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfJaAnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:43:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 195BD14E202B7;
        Wed, 30 Oct 2019 17:43:04 -0700 (PDT)
Date:   Wed, 30 Oct 2019 17:43:03 -0700 (PDT)
Message-Id: <20191030.174303.1290574456168401774.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: add ethtool pause configuration
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <eb248743-4407-93a6-2e80-e84b7510ca49@gmail.com>
References: <eb248743-4407-93a6-2e80-e84b7510ca49@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 17:43:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 29 Oct 2019 22:32:48 +0100

> This patch adds glue logic to make pause settings per port
> configurable vie ethtool.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks Heiner.
