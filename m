Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4AE88F3E8
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731455AbfHOSsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:48:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48192 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728818AbfHOSst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:48:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5A73213EA2200;
        Thu, 15 Aug 2019 11:48:49 -0700 (PDT)
Date:   Thu, 15 Aug 2019 11:48:48 -0700 (PDT)
Message-Id: <20190815.114848.1589177734213496897.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/2] net: phy: realtek: map vendor-specific
 EEE registers to standard MMD registers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <88a71ee7-a17d-ac9c-c998-d0ea35e5c566@gmail.com>
References: <88a71ee7-a17d-ac9c-c998-d0ea35e5c566@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 11:48:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 15 Aug 2019 14:12:10 +0200

> EEE-related registers on newer integrated PHY's have the standard
> layout, but are accessible not via MMD but via vendor-specific
> registers. Emulating the standard MMD registers allows to use the
> generic functions for EEE control and to significantly simplify
> the r8169 driver.
> 
> v2:
> - rebase patch 2

Series applied, thanks Heiner.
