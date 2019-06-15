Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F32D46DA1
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 03:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFOBrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 21:47:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56910 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfFOBrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 21:47:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A7B412B05D2C;
        Fri, 14 Jun 2019 18:47:02 -0700 (PDT)
Date:   Fri, 14 Jun 2019 18:47:01 -0700 (PDT)
Message-Id: <20190614.184701.104242108912142211.davem@davemloft.net>
To:     hancock@sedsystems.ca
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH net-next] net: phy: Add more 1000BaseX support detection
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560290769-11858-1-git-send-email-hancock@sedsystems.ca>
References: <1560290769-11858-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 18:47:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>
Date: Tue, 11 Jun 2019 16:06:09 -0600

> Commit "net: phy: Add detection of 1000BaseX link mode support" added
> support for not filtering out 1000BaseX mode from the PHY's supported
> modes in genphy_config_init, but we have to make a similar change in
> genphy_read_abilities in order to actually detect it as a supported mode
> in the first place. Add this in.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>

Applied.
