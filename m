Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7182227B83E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgI1Xdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgI1Xdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:33:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011D2C0613E2;
        Mon, 28 Sep 2020 15:15:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F4E811E3E4CE;
        Mon, 28 Sep 2020 14:58:21 -0700 (PDT)
Date:   Mon, 28 Sep 2020 15:15:07 -0700 (PDT)
Message-Id: <20200928.151507.1739959435679214893.davem@davemloft.net>
To:     wangqing@vivo.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Use kobj_to_dev() API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1601102960-8322-1-git-send-email-wangqing@vivo.com>
References: <1601102960-8322-1-git-send-email-wangqing@vivo.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 14:58:21 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>
Date: Sat, 26 Sep 2020 14:49:18 +0800

> Use kobj_to_dev() instead of container_of().
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

Applied to net-next, thank you.
