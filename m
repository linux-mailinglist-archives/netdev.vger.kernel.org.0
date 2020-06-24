Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820BB206A76
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388536AbgFXDSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387985AbgFXDSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:18:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7150CC061573;
        Tue, 23 Jun 2020 20:18:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDE9C129835C8;
        Tue, 23 Jun 2020 20:18:51 -0700 (PDT)
Date:   Tue, 23 Jun 2020 20:18:50 -0700 (PDT)
Message-Id: <20200623.201850.2071234644181824274.davem@davemloft.net>
To:     gaurav1086@gmail.com
Cc:     kuba@kernel.org, hkallweit1@gmail.com, mhabets@solarflare.com,
        mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net/ethernet] do_reset: remove dev null check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624005600.2221-1-gaurav1086@gmail.com>
References: <20200624005600.2221-1-gaurav1086@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 20:18:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gaurav Singh <gaurav1086@gmail.com>
Date: Tue, 23 Jun 2020 20:55:45 -0400

> dev cannot be NULL here since its already being accessed
> before. Remove the redundant null check.
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

I changed your Subject to be:

[PATCH net-next] xirc2ps_cs: remove dev null check from do_reset().

Since that is more properly formed.

Applied to net-next, thanks.
