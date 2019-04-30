Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7617FC1A
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 17:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfD3PE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 11:04:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43836 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfD3PE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 11:04:28 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A16D71403ED5B;
        Tue, 30 Apr 2019 08:04:27 -0700 (PDT)
Date:   Tue, 30 Apr 2019 11:04:25 -0400 (EDT)
Message-Id: <20190430.110425.1977792345336253148.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: dsa: bcm_sf2: fix buffer overflow doing set_rxnfc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190430104419.GA9096@mwanda>
References: <20190430104419.GA9096@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Apr 2019 08:04:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 30 Apr 2019 13:44:19 +0300

> The "fs->location" is a u32 that comes from the user in ethtool_set_rxnfc().
> We can't pass unclamped values to test_bit() or it results in an out of
> bounds access beyond the end of the bitmap.
> 
> Fixes: 7318166cacad ("net: dsa: bcm_sf2: Add support for ethtool::rxnfc")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied and queued up for -stable, thanks Dan.
