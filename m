Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A411E4D55
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgE0SsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgE0Srg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:47:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD117C08C5C4;
        Wed, 27 May 2020 11:29:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D708E128B2F4A;
        Wed, 27 May 2020 11:29:23 -0700 (PDT)
Date:   Wed, 27 May 2020 11:29:22 -0700 (PDT)
Message-Id: <20200527.112922.1235278258146783650.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: b53: remove redundant premature assignment
 to new_pvid
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527120129.172676-1-colin.king@canonical.com>
References: <20200527120129.172676-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 11:29:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Wed, 27 May 2020 13:01:29 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable new_pvid is being assigned with a value that is never read,
> the following if statement updates new_pvid with a new value in both
> of the if paths. The assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next, thanks.
