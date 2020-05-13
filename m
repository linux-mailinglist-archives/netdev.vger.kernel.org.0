Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E841D1FBE
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390816AbgEMTzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:55:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10049C061A0C;
        Wed, 13 May 2020 12:55:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E863127F6DBD;
        Wed, 13 May 2020 12:55:47 -0700 (PDT)
Date:   Wed, 13 May 2020 12:55:46 -0700 (PDT)
Message-Id: <20200513.125546.1487344805837197413.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-5.4.y] net: dsa: Do not make user port errors
 fatal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513174145.10048-1-f.fainelli@gmail.com>
References: <20200513174145.10048-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 12:55:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 13 May 2020 10:41:45 -0700

> commit 86f8b1c01a0a537a73d2996615133be63cdf75db upstream
> 
> Prior to 1d27732f411d ("net: dsa: setup and teardown ports"), we would
> not treat failures to set-up an user port as fatal, but after this
> commit we would, which is a regression for some systems where interfaces
> may be declared in the Device Tree, but the underlying hardware may not
> be present (pluggable daughter cards for instance).
> 
> Fixes: 1d27732f411d ("net: dsa: setup and teardown ports")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Greg, please queue this up.
