Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20D03F0BCB
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 02:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfKFBzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 20:55:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41844 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFBzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 20:55:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97885150FEF28;
        Tue,  5 Nov 2019 17:55:12 -0800 (PST)
Date:   Tue, 05 Nov 2019 17:55:12 -0800 (PST)
Message-Id: <20191105.175512.1515216386686066366.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        hkallweit1@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: Fix use after free in
 dsa_switch_remove()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191103031326.26873-1-f.fainelli@gmail.com>
References: <20191103031326.26873-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 17:55:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sat,  2 Nov 2019 20:13:26 -0700

> The order in which the ports are deleted from the list and freed and the
> call to dsa_tree_remove_switch() is done is reversed, which leads to an
> use after free condition. Reverse the two: first tear down the ports and
> switch from the fabric, then free the ports associated with that switch
> fabric.
> 
> Fixes: 05f294a85235 ("net: dsa: allocate ports on touch")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
