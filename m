Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACB0141EAF
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 16:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgASPAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 10:00:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49032 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASPAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 10:00:55 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DE38C14EC2C82;
        Sun, 19 Jan 2020 07:00:53 -0800 (PST)
Date:   Sun, 19 Jan 2020 16:00:49 +0100 (CET)
Message-Id: <20200119.160049.756836628220782206.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com
Subject: Re: [PATCH net-next 0/2] Rate adaptation for Felix DSA switch
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116181933.32765-1-olteanv@gmail.com>
References: <20200116181933.32765-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 07:00:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 16 Jan 2020 20:19:31 +0200

> When operating the MAC at 2.5Gbps (2500Base-X and USXGMII/QSXGMII) and
> in combination with certain PHYs, it is possible that the copper side
> may operate at lower link speeds. In this case, it is the PHY who has a
> MAC inside of it that emits pause frames towards the switch's MAC,
> telling it to slow down so that the transmission is lossless.
> 
> These patches are the support needed for the switch side of things to
> work.

Series applied, thanks.
