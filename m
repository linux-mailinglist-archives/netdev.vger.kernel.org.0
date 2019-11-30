Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9181010DE70
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 18:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfK3RqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 12:46:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43664 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfK3RqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 12:46:08 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B8FF11F5F7B0;
        Sat, 30 Nov 2019 09:46:07 -0800 (PST)
Date:   Sat, 30 Nov 2019 09:46:06 -0800 (PST)
Message-Id: <20191130.094606.1605980362790188417.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        andrew@lunn.ch, nsekhar@ti.com, ivan.khoronzhuk@linaro.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: ti: ale: ensure vlan/mdb deleted
 when no members
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191129175809.815-1-grygorii.strashko@ti.com>
References: <20191129175809.815-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 Nov 2019 09:46:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Fri, 29 Nov 2019 19:58:09 +0200

> The recently updated ALE APIs cpsw_ale_del_mcast() and
> cpsw_ale_del_vlan_modify() have an issue and will not delete ALE entry even
> if VLAN/mcast group has no more members. Hence fix it here and delete ALE
> entry if !port_mask.
> 
> The issue affected only new cpsw switchdev driver.
> 
> Fixes: e85c14370783 ("net: ethernet: ti: ale: modify vlan/mdb api for switchdev")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied.
