Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D6A24A9B0
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHSWtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSWtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:49:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D538C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:49:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F16C011E4576A;
        Wed, 19 Aug 2020 15:32:31 -0700 (PDT)
Date:   Wed, 19 Aug 2020 15:49:17 -0700 (PDT)
Message-Id: <20200819.154917.1918744984354933156.davem@davemloft.net>
To:     dbogdanov@marvell.com
Cc:     netdev@vger.kernel.org, mchopra@marvell.com, irusskikh@marvell.com,
        michal.kalderon@marvell.com
Subject: Re: [PATCH net 2/3] net: qede: Disable aRFS for NPAR and 100G
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3950bbb988b66c9c43c46d46c9632a272cea294c.1597833340.git.dbogdanov@marvell.com>
References: <cover.1597833340.git.dbogdanov@marvell.com>
        <3950bbb988b66c9c43c46d46c9632a272cea294c.1597833340.git.dbogdanov@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 15:32:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>
Date: Wed, 19 Aug 2020 23:29:28 +0300

> Fixes: e4917d46a65 ("qede: Add aRFS support")

This Fixes tag only has 11 digits of SHA1, when you should
provide 12 like the other two patches in this series do.

Thank you.
