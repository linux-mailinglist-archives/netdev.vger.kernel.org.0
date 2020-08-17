Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCF1245B4D
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 06:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHQEHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 00:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgHQEHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 00:07:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B5CC061388
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 21:07:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 609CC125007FC;
        Sun, 16 Aug 2020 20:50:50 -0700 (PDT)
Date:   Sun, 16 Aug 2020 21:07:35 -0700 (PDT)
Message-Id: <20200816.210735.456329073174973695.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, cphealy@gmail.com, jiri@mellanox.com
Subject: Re: [PATCH] net: devlink: Remove overzealous WARN_ON with snapshots
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200816192638.2291010-1-andrew@lunn.ch>
References: <20200816192638.2291010-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Aug 2020 20:50:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 16 Aug 2020 21:26:38 +0200

> It is possible to trigger this WARN_ON from user space by triggering a
> devlink snapshot with an ID which already exists. We don't need both
> -EEXISTS being reported and spamming the kernel log.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks Andrew.
