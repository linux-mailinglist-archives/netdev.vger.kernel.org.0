Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD19276549
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgIXAl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:41:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572A0C0613CE;
        Wed, 23 Sep 2020 17:41:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 910E411E58429;
        Wed, 23 Sep 2020 17:24:41 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:41:28 -0700 (PDT)
Message-Id: <20200923.174128.913566256378688203.davem@davemloft.net>
To:     robert.marko@sartura.hr
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v5 0/2] net: mdio-ipq4019: add Clause 45 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200922101632.54896-1-robert.marko@sartura.hr>
References: <20200922101632.54896-1-robert.marko@sartura.hr>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:24:41 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Marko <robert.marko@sartura.hr>
Date: Tue, 22 Sep 2020 12:16:30 +0200

> This patch series adds support for Clause 45 to the driver.
> 
> While at it also change some defines to upper case to match rest of the driver.
> 
> Changes since v4:
> * Rebase onto net-next.git
> 
> Changes since v1:
> * Drop clock patches, these need further investigation and
> no user for non default configuration has been found

Series applied, thank you.
