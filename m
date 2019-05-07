Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3CD16B59
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 21:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfEGTao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 15:30:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33328 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfEGTan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 15:30:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E985A14B89888;
        Tue,  7 May 2019 12:30:42 -0700 (PDT)
Date:   Tue, 07 May 2019 12:30:42 -0700 (PDT)
Message-Id: <20190507.123042.589323077170977597.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, antoine.tenart@bootlin.com,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com
Subject: Re: [PATCH net] dt-bindings: net: Fix a typo in the phy-mode list
 for ethernet bindings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190507153555.18545-1-maxime.chevallier@bootlin.com>
References: <20190507153555.18545-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 12:30:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Tue,  7 May 2019 17:35:55 +0200

> The phy_mode "2000base-x" is actually supposed to be "1000base-x", even
> though the commit title of the original patch says otherwise.
> 
> Fixes: 55601a880690 ("net: phy: Add 2000base-x, 2500base-x and rxaui modes")
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Applied.
