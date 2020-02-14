Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286F015DB26
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgBNPij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:38:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53576 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729451AbgBNPij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:38:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C250115C4F166;
        Fri, 14 Feb 2020 07:38:38 -0800 (PST)
Date:   Fri, 14 Feb 2020 07:38:38 -0800 (PST)
Message-Id: <20200214.073838.883906888137648178.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] netdevice.h: fix all kernel-doc and Sphinx warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <eb81cbe5-c91b-4105-5a45-ddd0747ace76@infradead.org>
References: <eb81cbe5-c91b-4105-5a45-ddd0747ace76@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Feb 2020 07:38:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Wed, 12 Feb 2020 22:28:20 -0800

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Eliminate all kernel-doc and Sphinx warnings in
> <linux/netdevice.h>.  Fixes these warnings:
> 
> ../include/linux/netdevice.h:2100: warning: Function parameter or member 'gso_partial_features' not described in 'net_device'
> ../include/linux/netdevice.h:2100: warning: Function parameter or member 'l3mdev_ops' not described in 'net_device'
> ../include/linux/netdevice.h:2100: warning: Function parameter or member 'xfrmdev_ops' not described in 'net_device'
> ../include/linux/netdevice.h:2100: warning: Function parameter or member 'tlsdev_ops' not described in 'net_device'
> ../include/linux/netdevice.h:2100: warning: Function parameter or member 'name_assign_type' not described in 'net_device'
> ../include/linux/netdevice.h:2100: warning: Function parameter or member 'ieee802154_ptr' not described in 'net_device'
> ../include/linux/netdevice.h:2100: warning: Function parameter or member 'mpls_ptr' not described in 'net_device'
> ../include/linux/netdevice.h:2100: warning: Function parameter or member 'xdp_prog' not described in 'net_device'
> ../include/linux/netdevice.h:2100: warning: Function parameter or member 'gro_flush_timeout' not described in 'net_device'
> ../include/linux/netdevice.h:2100: warning: Function parameter or member 'xdp_bulkq' not described in 'net_device'
> ../include/linux/netdevice.h:2100: warning: Function parameter or member 'xps_cpus_map' not described in 'net_device'
> ../include/linux/netdevice.h:2100: warning: Function parameter or member 'xps_rxqs_map' not described in 'net_device'
> ../include/linux/netdevice.h:2100: warning: Function parameter or member 'qdisc_hash' not described in 'net_device'
> ../include/linux/netdevice.h:3552: WARNING: Inline emphasis start-string without end-string.
> ../include/linux/netdevice.h:3552: WARNING: Inline emphasis start-string without end-string.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks Randy.
