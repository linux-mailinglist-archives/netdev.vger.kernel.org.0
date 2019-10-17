Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADB0DBA30
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 01:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503756AbfJQXcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 19:32:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43758 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503752AbfJQXcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 19:32:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE85214304E2A;
        Thu, 17 Oct 2019 16:32:11 -0700 (PDT)
Date:   Thu, 17 Oct 2019 16:32:11 -0700 (PDT)
Message-Id: <20191017.163211.2216752480865273146.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, hkallweit1@gmail.com,
        sean.nyekjaer@prevas.dk, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH net V5 2/2] net: phy: micrel: Update KSZ87xx PHY name
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191016133507.10564-2-marex@denx.de>
References: <20191016133507.10564-1-marex@denx.de>
        <20191016133507.10564-2-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 16:32:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Wed, 16 Oct 2019 15:35:07 +0200

> The KSZ8795 PHY ID is in fact used by KSZ8794/KSZ8795/KSZ8765 switches.
> Update the PHY ID and name to reflect that, as this family of switches
> is commonly refered to as KSZ87xx
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Applied.
