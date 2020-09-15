Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06AD26B280
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgIOWsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbgIOWsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 18:48:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92691C06174A;
        Tue, 15 Sep 2020 15:47:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D0DD313B5D1C3;
        Tue, 15 Sep 2020 15:31:11 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:47:58 -0700 (PDT)
Message-Id: <20200915.154758.399614089931643151.davem@davemloft.net>
To:     mdf@kernel.org
Cc:     snelson@pensando.io, mst@redhat.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, moritzf@google.com
Subject: Re: [PATCH net-next v2 0/3] First bunch of Tulip cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915042452.26155-1-mdf@kernel.org>
References: <20200915042452.26155-1-mdf@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 15:31:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moritz Fischer <mdf@kernel.org>
Date: Mon, 14 Sep 2020 21:24:49 -0700

> This series is the first bunch of minor cleanups for the de2104x driver
> to make it look and behave more like a modern driver.
> 
> These changes replace some of the non-devres versions with devres
> versions of functions to simplify the error paths.
> 
> Next up after this will be the ioremap part.

I really don't consider a "conversion" over to devres for older drivers
a suitable cleanup.

There are no resource handling bugs you are fixing, the driver uses
the APIs it uses correctly, and the coding style is reasonable.

Therefore, I'm sorry I'm not applying these changes.
