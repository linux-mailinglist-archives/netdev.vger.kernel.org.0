Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BCF27F6F0
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 03:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732340AbgJABB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 21:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731881AbgJABB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 21:01:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCC3C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 18:01:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9257013D85D15;
        Wed, 30 Sep 2020 17:45:06 -0700 (PDT)
Date:   Wed, 30 Sep 2020 18:01:50 -0700 (PDT)
Message-Id: <20200930.180150.884209577267624386.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, nhorman@tuxdriver.com,
        jiri@nvidia.com, roopa@nvidia.com, aroulin@nvidia.com,
        ayal@nvidia.com, masahiroy@kernel.org, mlxsw@nvidia.com,
        idosch@nvidia.com
Subject: Re: [PATCH net-next 0/7] drop_monitor: Convert to use devlink
 tracepoint
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929081556.1634838-1-idosch@idosch.org>
References: <20200929081556.1634838-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 30 Sep 2020 17:45:07 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 29 Sep 2020 11:15:49 +0300

> From: Ido Schimmel <idosch@nvidia.com>
> 
> Drop monitor is able to monitor both software and hardware originated
> drops. Software drops are monitored by having drop monitor register its
> probe on the 'kfree_skb' tracepoint. Hardware originated drops are
> monitored by having devlink call into drop monitor whenever it receives
> a dropped packet from the underlying hardware.
> 
> This patch set converts drop monitor to monitor both software and
> hardware originated drops in the same way - by registering its probe on
> the relevant tracepoint.
> 
> In addition to drop monitor being more consistent, it is now also
> possible to build drop monitor as module instead of as a builtin and
> still monitor hardware originated drops. Initially, CONFIG_NET_DEVLINK
> implied CONFIG_NET_DROP_MONITOR, but after commit def2fbffe62c
> ("kconfig: allow symbols implied by y to become m") we can have
> CONFIG_NET_DEVLINK=y and CONFIG_NET_DROP_MONITOR=m and hardware
> originated drops will not be monitored.
 ...

Series applied, thank you.
