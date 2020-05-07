Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632DD1C7F49
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgEGArB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgEGAq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:46:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00ADC061A0F;
        Wed,  6 May 2020 17:46:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B610127814AF;
        Wed,  6 May 2020 17:46:59 -0700 (PDT)
Date:   Wed, 06 May 2020 17:46:58 -0700 (PDT)
Message-Id: <20200506.174658.1119989944574077350.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     snelson@pensando.io, drivers@pensando.io, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ionic: Use debugfs_create_bool() to export bool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505132809.17655-1-geert+renesas@glider.be>
References: <20200505132809.17655-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:46:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Tue,  5 May 2020 15:28:09 +0200

> Currently bool ionic_cq.done_color is exported using
> debugfs_create_u8(), which requires a cast, preventing further compiler
> checks.
> 
> Fix this by switching to debugfs_create_bool(), and dropping the cast.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Shannon Nelson <snelson@pensando.io>

Applied, thanks.
