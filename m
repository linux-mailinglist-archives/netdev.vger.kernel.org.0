Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C82A58965
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfF0SAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:00:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57512 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfF0SAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 14:00:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E29A612DAD56E;
        Thu, 27 Jun 2019 11:00:48 -0700 (PDT)
Date:   Thu, 27 Jun 2019 11:00:48 -0700 (PDT)
Message-Id: <20190627.110048.2142669780668795915.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        Tristram.Ha@microchip.com, Woojung.Huh@microchip.com
Subject: Re: [PATCH V4 00/10] net: dsa: microchip: Convert to regmap
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190625234348.16246-1-marex@denx.de>
References: <20190625234348.16246-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 11:00:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Wed, 26 Jun 2019 01:43:38 +0200

> This patchset converts KSZ9477 switch driver to regmap.
> 
> This was tested with extra patches on KSZ8795. This was also tested
> on KSZ9477 on Microchip KSZ9477EVB board, which I now have.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Series applied, thanks.
