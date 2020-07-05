Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0969B21503F
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgGEWtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgGEWtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:49:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC94C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:49:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA7B812915D83;
        Sun,  5 Jul 2020 15:49:16 -0700 (PDT)
Date:   Sun, 05 Jul 2020 15:49:16 -0700 (PDT)
Message-Id: <20200705.154916.363785506713635147.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com
Subject: Re: [PATCH] net: dsa: vitesse-vsc73xx: Convert to plain comments
 to avoid kerneldoc warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200705210508.893443-1-andrew@lunn.ch>
References: <20200705210508.893443-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jul 2020 15:49:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun,  5 Jul 2020 23:05:08 +0200

> The comments before struct vsc73xx_platform and struct vsc73xx_spi use
> kerneldoc format, but then fail to document the members of these
> structures. All the structure members are self evident, and the driver
> has not other kerneldoc comments, so change these to plain comments to
> avoid warnings.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied to net-next.
