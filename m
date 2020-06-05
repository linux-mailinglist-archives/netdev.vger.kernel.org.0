Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92BE1F00DB
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 22:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgFEURS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 16:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbgFEURR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 16:17:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91A4C08C5C2;
        Fri,  5 Jun 2020 13:17:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60571127B0A88;
        Fri,  5 Jun 2020 13:17:17 -0700 (PDT)
Date:   Fri, 05 Jun 2020 13:17:16 -0700 (PDT)
Message-Id: <20200605.131716.1384746623877149157.davem@davemloft.net>
To:     keescook@chromium.org
Cc:     joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethtool: Fix comment mentioning typo in
 IS_ENABLED()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <202006050720.D741B4C@keescook>
References: <202006050720.D741B4C@keescook>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jun 2020 13:17:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Fri, 5 Jun 2020 07:21:22 -0700

> This has no code changes, but it's a typo noticed in other clean-ups,
> so we might as well fix it. IS_ENABLED() takes full names, and should
> have the "CONFIG_" prefix.
> 
> Reported-by: Joe Perches <joe@perches.com>
> Link: https://lore.kernel.org/lkml/b08611018fdb6d88757c6008a5c02fa0e07b32fb.camel@perches.com
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied, thank you.
