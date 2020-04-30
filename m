Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1825B1C060F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgD3TU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3TU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:20:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4473C035495;
        Thu, 30 Apr 2020 12:20:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4C1931288F344;
        Thu, 30 Apr 2020 12:20:27 -0700 (PDT)
Date:   Thu, 30 Apr 2020 12:20:26 -0700 (PDT)
Message-Id: <20200430.122026.1592233238408070886.davem@davemloft.net>
To:     tangbin@cmss.chinamobile.com
Cc:     benh@kernel.crashing.org, andrew@lunn.ch, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhangshengju@cmss.chinamobile.com
Subject: Re: [PATCH] net: ftgmac100: Fix unused assignment
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430121123.25184-1-tangbin@cmss.chinamobile.com>
References: <20200430121123.25184-1-tangbin@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 12:20:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>
Date: Thu, 30 Apr 2020 20:11:23 +0800

> Delete unused initialized value in ftgmac100.c file.
> 
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

This does not apply to the current networking trees.
