Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054EA27B5AD
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgI1Tue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgI1Tub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:50:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B73C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 12:50:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B34F1455A059;
        Mon, 28 Sep 2020 12:33:44 -0700 (PDT)
Date:   Mon, 28 Sep 2020 12:50:31 -0700 (PDT)
Message-Id: <20200928.125031.1589464517035226386.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v2 00/10] udp_tunnel: convert Intel drivers
 with shared tables
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200926005649.3285089-1-kuba@kernel.org>
References: <20200926005649.3285089-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 12:33:44 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 25 Sep 2020 17:56:39 -0700

> This set converts Intel drivers which have the ability to spawn
> multiple netdevs, but have only one UDP tunnel port table.
> 
> Appropriate support is added to the core infra in patch 1,
> followed by netdevsim support and a selftest.
> 
> The table sharing works by core attaching the same table
> structure to all devices sharing the table. This means the
> reference count has to accommodate potentially large values.
> 
> Once core is ready i40e and ice are converted. These are
> complex drivers, but we got a tested-by from Aaron, so we
> should be good :)
> 
> Compared to v1 I've made sure the selftest is executable.
> 
> Other than that patches 8 and 9 are actually from the Mellanox
> conversion series were kept out to avoid Mellanox vs Intel
> conflicts.
> 
> Last patch is new, some docs to let users knows ethtool
> can now display UDP tunnel info.

Series applied, thanks Jakub.
