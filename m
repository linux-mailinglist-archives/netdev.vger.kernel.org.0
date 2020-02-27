Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E22170D6A
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 01:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgB0AqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 19:46:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35408 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgB0AqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 19:46:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A355E15ADF456;
        Wed, 26 Feb 2020 16:46:05 -0800 (PST)
Date:   Wed, 26 Feb 2020 16:46:04 -0800 (PST)
Message-Id: <20200226.164604.813084352067535153.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] Revert "net: dsa: bcm_sf2: Also configure
 Port 5 for 2Gb/sec on 7278"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224234427.12736-1-f.fainelli@gmail.com>
References: <20200224234427.12736-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 16:46:05 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 24 Feb 2020 15:44:26 -0800

> This reverts commit 7458bd540fa0a90220b9e8c349d910d9dde9caf8 ("net: dsa:
> bcm_sf2: Also configure Port 5 for 2Gb/sec on 7278") as it causes
> advanced congestion buffering issues with 7278 switch devices when using
> their internal Giabit PHY. While this is being debugged, continue with
> conservative defaults that work and do not cause packet loss.
> 
> Fixes: 7458bd540fa0 ("net: dsa: bcm_sf2: Also configure Port 5 for 2Gb/sec on 7278")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
