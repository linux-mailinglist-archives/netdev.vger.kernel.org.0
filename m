Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219AA255D42
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 17:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgH1PC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 11:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgH1PCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 11:02:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5259EC061232
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 08:02:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA9BD12866699;
        Fri, 28 Aug 2020 07:45:23 -0700 (PDT)
Date:   Fri, 28 Aug 2020 08:02:07 -0700 (PDT)
Message-Id: <20200828.080207.572688006909641471.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/12] ionic memory usage rework
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827230030.43343-1-snelson@pensando.io>
References: <20200827230030.43343-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Aug 2020 07:45:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Thu, 27 Aug 2020 16:00:18 -0700

> Previous review comments have suggested [1],[2] that this driver
> needs to rework how queue resources are managed and reconfigured
> so that we don't do a full driver reset and to better handle
> potential allocation failures.  This patchset is intended to
> address those comments.
> 
> The first few patches clean some general issues and
> simplify some of the memory structures.  The last 4 patches
> specifically address queue parameter changes without a full
> ionic_stop()/ionic_open().
> 
> [1] https://lore.kernel.org/netdev/20200706103305.182bd727@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
> [2] https://lore.kernel.org/netdev/20200724.194417.2151242753657227232.davem@davemloft.net/
 ...

Series applied, thanks for doing this work as this is an area where
many drivers have poor behavior.
