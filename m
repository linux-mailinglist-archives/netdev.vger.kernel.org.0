Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15FEFD5709
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 19:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbfJMRbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 13:31:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42400 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbfJMRbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 13:31:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB7BE144B304D;
        Sun, 13 Oct 2019 10:31:32 -0700 (PDT)
Date:   Sun, 13 Oct 2019 10:31:32 -0700 (PDT)
Message-Id: <20191013.103132.921221152987204278.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, hkallweit1@gmail.com,
        Tristram.Ha@microchip.com, woojung.huh@microchip.com
Subject: Re: [PATCH 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191010191249.2112-1-marex@denx.de>
References: <20191010191249.2112-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Oct 2019 10:31:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please respin with a proper cover letter and appropriate Fixes:
tag(s).

Thank you.
