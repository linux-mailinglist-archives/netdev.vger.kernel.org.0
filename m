Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCB51608BF
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgBQDXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:23:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48222 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727755AbgBQDXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:23:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3A61155CAC60;
        Sun, 16 Feb 2020 19:23:43 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:23:43 -0800 (PST)
Message-Id: <20200216.192343.2089015531155068961.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: dsa: b53: Ensure the default VID is
 untagged
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200214232619.26482-1-f.fainelli@gmail.com>
References: <20200214232619.26482-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:23:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 14 Feb 2020 15:26:19 -0800

> We need to ensure that the default VID is untagged otherwise the switch
> will be sending tagged frames and the results can be problematic. This
> is especially true with b53 switches that use VID 0 as their default
> VLAN since VID 0 has a special meaning.
> 
> Fixes: fea83353177a ("net: dsa: b53: Fix default VLAN ID")
> Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks Florian.
