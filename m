Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32355273529
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 23:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbgIUVsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 17:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbgIUVsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 17:48:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48B4C061755;
        Mon, 21 Sep 2020 14:48:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D32D311E49F63;
        Mon, 21 Sep 2020 14:31:54 -0700 (PDT)
Date:   Mon, 21 Sep 2020 14:48:41 -0700 (PDT)
Message-Id: <20200921.144841.1356454980970038338.davem@davemloft.net>
To:     robert.marko@sartura.hr
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v4 0/2] net: mdio-ipq4019: add Clause 45 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200920141653.357493-1-robert.marko@sartura.hr>
References: <20200920141653.357493-1-robert.marko@sartura.hr>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 14:31:55 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Marko <robert.marko@sartura.hr>
Date: Sun, 20 Sep 2020 16:16:51 +0200

> This patch series adds support for Clause 45 to the driver.
> 
> While at it also change some defines to upper case to match rest of the driver.
> 
> Changes since v1:
> * Drop clock patches, these need further investigation and
> no user for non default configuration has been found

Please respin, in the net-next tree the MDIO drivers have been moved
into their own directory.
