Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A65AC0134
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfI0IcL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 27 Sep 2019 04:32:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57306 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfI0IcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:32:11 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0BD3514DEFEE7;
        Fri, 27 Sep 2019 01:32:08 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:32:07 +0200 (CEST)
Message-Id: <20190927.103207.629278236080536516.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        michal.vokac@ysoft.com
Subject: Re: [PATCH net] net: dsa: qca8k: Fix port enable for CPU port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925004707.1799-1-andrew@lunn.ch>
References: <20190925004707.1799-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 01:32:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 25 Sep 2019 02:47:07 +0200

> The CPU port does not have a PHY connected to it. So calling
> phy_support_asym_pause() results in an Opps. As with other DSA
> drivers, add a guard that the port is a user port.
> 
> Reported-by: Michal Vok·Ë <michal.vokac@ysoft.com>
> Fixes: 0394a63acfe2 ("net: dsa: enable and disable all ports")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied.
