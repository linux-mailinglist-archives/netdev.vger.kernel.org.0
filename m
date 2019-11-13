Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB5DFB9FD
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfKMUfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:35:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37710 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfKMUfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:35:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E85E41264D9AC;
        Wed, 13 Nov 2019 12:35:16 -0800 (PST)
Date:   Wed, 13 Nov 2019 12:35:16 -0800 (PST)
Message-Id: <20191113.123516.1934775432819454409.davem@davemloft.net>
To:     Bryan.Whitehead@microchip.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 net-next] mscc.c: Add support for additional VSC PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573662795-3672-1-git-send-email-Bryan.Whitehead@microchip.com>
References: <1573662795-3672-1-git-send-email-Bryan.Whitehead@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 12:35:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bryan Whitehead <Bryan.Whitehead@microchip.com>
Date: Wed, 13 Nov 2019 11:33:15 -0500

> Add support for the following VSC PHYs
> 	VSC8504, VSC8552, VSC8572
> 	VSC8562, VSC8564, VSC8575, VSC8582
> 
> Updates for v2:
> 	Checked for NULL on input to container_of
> 	Changed a large if else series to a switch statement.
> 	Added a WARN_ON to make sure lowest nibble of mask is 0
> 
> Signed-off-by: Bryan Whitehead <Bryan.Whitehead@microchip.com>

Applied, thanks.
