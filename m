Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EACD1D4231
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgEOAkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727116AbgEOAkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:40:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C373C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 17:40:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 081E914D3AC77;
        Thu, 14 May 2020 17:40:30 -0700 (PDT)
Date:   Thu, 14 May 2020 17:40:30 -0700 (PDT)
Message-Id: <20200514.174030.256864602474289052.davem@davemloft.net>
To:     kevlo@kevlo.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: phy: broadcom: fix
 BCM54XX_SHD_SCR3_TRDDAPD value for BCM54810
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514005733.GA94953@ns.kevlo.org>
References: <20200514005733.GA94953@ns.kevlo.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 17:40:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Lo <kevlo@kevlo.org>
Date: Thu, 14 May 2020 08:57:33 +0800

> Set the correct bit when checking for PHY_BRCM_DIS_TXCRXC_NOENRGY on the 
> BCM54810 PHY.
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>

Applied to 'net', thanks.
