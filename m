Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8A05911F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 04:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfF1CZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 22:25:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36416 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfF1CZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 22:25:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87EA1149BFB82;
        Thu, 27 Jun 2019 19:25:22 -0700 (PDT)
Date:   Thu, 27 Jun 2019 19:25:19 -0700 (PDT)
Message-Id: <20190627.192519.1652788423313482742.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        Tristram.Ha@microchip.com, Woojung.Huh@microchip.com
Subject: Re: [PATCH 0/5] net: dsa: microchip: Further regmap cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627215556.23768-1-marex@denx.de>
References: <20190627215556.23768-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 19:25:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Thu, 27 Jun 2019 23:55:51 +0200

> This patchset cleans up KSZ9477 switch driver by replacing various
> ad-hoc polling implementations and register RMW with regmap functions.
> 
> Each polling function is replaced separately to make it easier to review
> and possibly bisect, but maybe the patches can be squashed.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Series applied, thanks.
