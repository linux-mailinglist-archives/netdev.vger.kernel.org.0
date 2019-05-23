Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6FF927383
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbfEWAoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:44:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36802 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729380AbfEWAoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:44:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 083A214577846;
        Wed, 22 May 2019 17:44:09 -0700 (PDT)
Date:   Wed, 22 May 2019 17:44:08 -0700 (PDT)
Message-Id: <20190522.174408.2115994822395295597.davem@davemloft.net>
To:     tpiepho@impinj.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net-next v2 3/8] net: phy: dp83867: Add ability to
 disable output clock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522184255.16323-3-tpiepho@impinj.com>
References: <20190522184255.16323-1-tpiepho@impinj.com>
        <20190522184255.16323-3-tpiepho@impinj.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:44:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Trent Piepho <tpiepho@impinj.com>
Date: Wed, 22 May 2019 18:43:22 +0000

> Generally, the output clock pin is only used for testing and only serves
> as a source of RF noise after this.  It could be used to daisy-chain
> PHYs, but this is uncommon.  Since the PHY can disable the output, make
> doing so an option.  I do this by adding another enumeration to the
> allowed values of ti,clk-output-sel.
> 
> The code was not using the value DP83867_CLK_O_SEL_REF_CLK as one might
> expect: to select the REF_CLK as the output.  Rather it meant "keep
> clock output setting as is", which, depending on PHY strapping, might
> not be outputting REF_CLK.
> 
> Change this so DP83867_CLK_O_SEL_REF_CLK means enable REF_CLK output.
> Omitting the property will leave the setting as is (which was the
> previous behavior in this case).
> 
> Out of range values were silently converted into
> DP83867_CLK_O_SEL_REF_CLK.  Change this so they generate an error.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Trent Piepho <tpiepho@impinj.com>

Applied.
