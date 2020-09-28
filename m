Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CB327A907
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgI1HwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgI1HwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 03:52:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9039FC0613CE;
        Mon, 28 Sep 2020 00:52:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CFE2313C7095B;
        Mon, 28 Sep 2020 00:35:11 -0700 (PDT)
Date:   Mon, 28 Sep 2020 00:51:56 -0700 (PDT)
Message-Id: <20200928.005156.1682118019743863282.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, lkp@intel.com,
        kuba@kernel.org, ap420073@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: vlan: Fixed signedness in
 vlan_group_prealloc_vid()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928023154.28031-1-f.fainelli@gmail.com>
References: <20200928023154.28031-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 00:35:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sun, 27 Sep 2020 19:31:50 -0700

> After commit d0186842ec5f ("net: vlan: Avoid using BUG() in
> vlan_proto_idx()"), vlan_proto_idx() was changed to return a signed
> integer, however one of its called: vlan_group_prealloc_vid() was still
> using an unsigned integer for its return value, fix that.
> 
> Fixes: d0186842ec5f ("net: vlan: Avoid using BUG() in vlan_proto_idx()")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks Florian.
