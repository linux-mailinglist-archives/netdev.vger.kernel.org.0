Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F17448F3C1
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbfHOSmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:42:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48060 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730317AbfHOSmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:42:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7FD9813E99267;
        Thu, 15 Aug 2019 11:42:12 -0700 (PDT)
Date:   Thu, 15 Aug 2019 11:42:11 -0700 (PDT)
Message-Id: <20190815.114211.1027285612144924753.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: read MII_CTRL1000 in
 genphy_read_status only if needed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <84cbdf69-70b4-3dd0-c34d-7db0a4f69653@gmail.com>
References: <84cbdf69-70b4-3dd0-c34d-7db0a4f69653@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 11:42:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 15 Aug 2019 13:15:19 +0200

> Value of MII_CTRL1000 is needed only if LPA_1000MSFAIL is set.
> Therefore move reading this register.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
