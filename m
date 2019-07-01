Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18EA61A897
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 19:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfEKRC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 13:02:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42010 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfEKRC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 13:02:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B5E841478DBF3;
        Sat, 11 May 2019 10:02:26 -0700 (PDT)
Date:   Sat, 11 May 2019 10:02:24 -0700 (PDT)
Message-Id: <20190511.100224.1253633990588650004.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: realtek: fix double page ops in generic
 Realtek driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c2c9f3c6-81c4-7c27-8989-10331bb69dc6@gmail.com>
References: <c2c9f3c6-81c4-7c27-8989-10331bb69dc6@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 11 May 2019 10:02:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 11 May 2019 07:44:48 +0200

> When adding missing callbacks I missed that one had them set already.
> Interesting that the compiler didn't complain.
> 
> Fixes: daf3ddbe11a2 ("net: phy: realtek: add missing page operations")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
