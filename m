Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4738CFA78E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfKMDq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:46:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54424 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbfKMDqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:46:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 16C4F154FFFC5;
        Tue, 12 Nov 2019 19:46:55 -0800 (PST)
Date:   Tue, 12 Nov 2019 19:46:54 -0800 (PST)
Message-Id: <20191112.194654.825424933050239161.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: Prevent usage of
 NET_DSA_TAG_8021Q as tagging protocol
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112043846.3585-1-f.fainelli@gmail.com>
References: <20191112043846.3585-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 19:46:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 11 Nov 2019 20:38:46 -0800

> It is possible for a switch driver to use NET_DSA_TAG_8021Q as a valid
> DSA tagging protocol since it registers itself as such, unfortunately
> since there are not xmit or rcv functions provided, the lack of a xmit()
> function will lead to a NPD in dsa_slave_xmit() to start with.
> 
> net/dsa/tag_8021q.c is only comprised of a set of helper functions at
> the moment, but is not a fully autonomous or functional tagging "driver"
> (though it could become later on). We do not have any users of
> NET_DSA_TAG_8021Q so now is a good time to make sure there are not
> issues being encountered by making this file strictly a place holder for
> helper functions.
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks.
