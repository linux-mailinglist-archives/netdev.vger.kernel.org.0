Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9909B1860B3
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 01:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgCPAK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 20:10:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42696 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729120AbgCPAK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 20:10:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF00512179321;
        Sun, 15 Mar 2020 17:10:28 -0700 (PDT)
Date:   Sun, 15 Mar 2020 17:10:28 -0700 (PDT)
Message-Id: <20200315.171028.1842230848808546741.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH REPOST net-next 0/2] net: mii clause 37 helpers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200314100916.GE25745@shell.armlinux.org.uk>
References: <20200314100916.GE25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 17:10:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Sat, 14 Mar 2020 10:09:16 +0000

> This is a re-post of two patches that are common to two series that
> I've sent in recent weeks; I'm re-posting them separately in the hope
> that they can be merged.  No changes from either of the previous
> postings.
> 
> These patches:
> 
> 1. convert the existing (unused) mii_lpa_to_ethtool_lpa_x() function
>    to a linkmode variant.
> 
> 2. add a helper for clause 37 advertisements, supporting both the
>    1000baseX and defacto 2500baseX variants. Note that ethtool does
>    not support half duplex for either of these, and we make no effort
>    to do so.

Series applied.
