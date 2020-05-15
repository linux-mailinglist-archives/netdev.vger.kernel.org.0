Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDC31D5874
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgEOR4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726023AbgEOR4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:56:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE4CC061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 10:56:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 760ED14EBCA55;
        Fri, 15 May 2020 10:56:49 -0700 (PDT)
Date:   Fri, 15 May 2020 10:56:48 -0700 (PDT)
Message-Id: <20200515.105648.106219564402122123.davem@davemloft.net>
To:     kevlo@kevlo.org
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next] net: phy: broadcom: add support for BCM54811
 PHY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515172447.GA2101@ns.kevlo.org>
References: <20200515172447.GA2101@ns.kevlo.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 10:56:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Lo <kevlo@kevlo.org>
Date: Sat, 16 May 2020 01:24:47 +0800

> The BCM54811 PHY shares many similarities with the already supported BCM54810
> PHY but additionally requires some semi-unique configuration.
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
