Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B2A174BDC
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 06:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgCAFtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 00:49:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38820 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgCAFtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 00:49:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC78115BDA6DE;
        Sat, 29 Feb 2020 21:49:16 -0800 (PST)
Date:   Sat, 29 Feb 2020 21:49:16 -0800 (PST)
Message-Id: <20200229.214916.1022439823321659708.davem@davemloft.net>
To:     cforno12@linux.ibm.com
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        tlfalcon@linux.ibm.com, mkubecek@suse.cz,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        cforno12@linux.vnet.ibm.com
Subject: Re: [PATCH, net-next, v7, 0/2] net/ethtool: Introduce
 link_ksettings API for virtual network devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200228201205.15846-1-cforno12@linux.ibm.com>
References: <20200228201205.15846-1-cforno12@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Feb 2020 21:49:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cris Forno <cforno12@linux.ibm.com>
Date: Fri, 28 Feb 2020 14:12:03 -0600

> This series provides an API for drivers of virtual network devices that
> allows users to alter initial device speed and duplex settings to reflect
> the actual capabilities of underlying hardware. The changes made include
> a helper function ethtool_virtdev_set_link_ksettings, which is used to
> retrieve alterable link settings. In addition, there is a new ethtool
> function defined to validate those settings. These changes resolve code
> duplication for existing virtual network drivers that have already
> implemented this behavior.  In the case of the ibmveth driver, this API is
> used to provide this capability for the first time.

Applied to net-next.
