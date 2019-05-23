Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C9A2738E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbfEWAon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:44:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36862 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729654AbfEWAom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:44:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3EBA1457784D;
        Wed, 22 May 2019 17:44:41 -0700 (PDT)
Date:   Wed, 22 May 2019 17:44:41 -0700 (PDT)
Message-Id: <20190522.174441.2151424309076790135.davem@davemloft.net>
To:     tpiepho@impinj.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net-next v2 8/8] net: phy: dp83867: Allocate state
 struct in probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522184255.16323-8-tpiepho@impinj.com>
References: <20190522184255.16323-1-tpiepho@impinj.com>
        <20190522184255.16323-8-tpiepho@impinj.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:44:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Trent Piepho <tpiepho@impinj.com>
Date: Wed, 22 May 2019 18:43:27 +0000

> This was being done in config the first time the phy was configured.
> Should be in the probe method.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Trent Piepho <tpiepho@impinj.com>

Applied.
