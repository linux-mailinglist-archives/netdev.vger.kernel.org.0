Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51D21A8F3C
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 01:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441031AbgDNXlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 19:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392187AbgDNXlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 19:41:13 -0400
X-Greylist: delayed 782 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Apr 2020 16:41:13 PDT
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6303AC061A0C;
        Tue, 14 Apr 2020 16:41:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D21F1280BC25;
        Tue, 14 Apr 2020 16:41:12 -0700 (PDT)
Date:   Tue, 14 Apr 2020 16:41:11 -0700 (PDT)
Message-Id: <20200414.164111.137518183439779253.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, linux-kernel@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH net 0/4] net: dsa: b53: Various ARL fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2c4e181c-02b9-576c-99c1-18a1fa25c469@gmail.com>
References: <20200414041630.5740-1-f.fainelli@gmail.com>
        <2c4e181c-02b9-576c-99c1-18a1fa25c469@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Apr 2020 16:41:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 14 Apr 2020 08:47:15 -0700

> Please do not apply this just yet, this patch issues a dev_warn() which
> would be seen even when deleting an entry from the ARL while the table
> is full this is undesirable and I also need to update the callers of
> b53_arl_op() to check for -ENOSPC specifically. v2 coming, thanks!

Ok, marked as supercered in patchwork.
