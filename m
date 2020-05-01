Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13AC1C0CE7
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgEAD4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEAD4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:56:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DF0C035494;
        Thu, 30 Apr 2020 20:56:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B97CC1277C56A;
        Thu, 30 Apr 2020 20:56:18 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:56:18 -0700 (PDT)
Message-Id: <20200430.205618.484622161127720565.davem@davemloft.net>
To:     michael@walle.cc
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v2 4/4] net: phy: bcm54140: add second PHY ID
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200428230659.7754-4-michael@walle.cc>
References: <20200428230659.7754-1-michael@walle.cc>
        <20200428230659.7754-4-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:56:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Wed, 29 Apr 2020 01:06:59 +0200

> This PHY has two PHY IDs depending on its mode. Adjust the mask so that
> it includes both IDs.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied.
