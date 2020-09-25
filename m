Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E282279517
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgIYXsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729425AbgIYXst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:48:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25B3C0613CE;
        Fri, 25 Sep 2020 16:48:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3422113BA0918;
        Fri, 25 Sep 2020 16:32:00 -0700 (PDT)
Date:   Fri, 25 Sep 2020 16:48:46 -0700 (PDT)
Message-Id: <20200925.164846.1055766774275451296.davem@davemloft.net>
To:     vee.khee.wong@intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        treding@nvidia.com, andrew@lunn.ch, boon.leong.ong@intel.com,
        weifeng.voon@intel.com, sadhishkhanna.vijaya.balan@intel.com,
        chen.yong.seow@intel.com, mgross@linux.intel.com
Subject: Re: [PATCH net-next 1/1] net: stmmac: Add option for VLAN filter
 fail queue enable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925094041.12038-2-vee.khee.wong@intel.com>
References: <20200925094041.12038-1-vee.khee.wong@intel.com>
        <20200925094041.12038-2-vee.khee.wong@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:32:00 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@intel.com>
Date: Fri, 25 Sep 2020 17:40:41 +0800

> From: "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>
> 
> Add option in plat_stmmacenet_data struct to enable VLAN Filter Fail
> Queuing. This option allows packets that fail VLAN filter to be routed
> to a specific Rx queue when Receive All is also set.
> 
> When this option is enabled:
> - Enable VFFQ only when entering promiscuous mode, because Receive All
>   will pass up all rx packets that failed address filtering (similar to
>   promiscuous mode).
> - VLAN-promiscuous mode is never entered to allow rx packet to fail VLAN
>   filters and get routed to selected VFFQ Rx queue.
> 
> Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
> Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Chuah, Kim Tatt <kim.tatt.chuah@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

Applied.
