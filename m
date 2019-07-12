Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEDF367680
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbfGLW0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:26:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34240 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727245AbfGLW0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:26:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC5E414E01C12;
        Fri, 12 Jul 2019 15:26:42 -0700 (PDT)
Date:   Fri, 12 Jul 2019 15:26:42 -0700 (PDT)
Message-Id: <20190712.152642.1572187171713415392.davem@davemloft.net>
To:     efremov@linux.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: make exported variables non-static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190710180324.8131-1-efremov@linux.com>
References: <20190710180324.8131-1-efremov@linux.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 15:26:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>
Date: Wed, 10 Jul 2019 21:03:24 +0300

> The variables phy_basic_ports_array, phy_fibre_port_array and
> phy_all_ports_features_array are declared static and marked
> EXPORT_SYMBOL_GPL(), which is at best an odd combination.
> Because the variables were decided to be a part of API, this commit
> removes the static attributes and adds the declarations to the header.
> 
> Fixes: 3c1bcc8614db ("net: ethernet: Convert phydev advertize and supported from u32 to link mode")
> Signed-off-by: Denis Efremov <efremov@linux.com>

Applied, thanks.
