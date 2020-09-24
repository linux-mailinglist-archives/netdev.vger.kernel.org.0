Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4151D2765AD
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgIXBJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXBJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:09:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9A0C0613CE;
        Wed, 23 Sep 2020 18:09:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A1F3127111A2;
        Wed, 23 Sep 2020 17:52:21 -0700 (PDT)
Date:   Wed, 23 Sep 2020 18:09:07 -0700 (PDT)
Message-Id: <20200923.180907.1867807213397459967.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, alexandre.torgue@st.com,
        boon.leong.ong@intel.com, chen.yong.seow@intel.com,
        mgross@linux.intel.com
Subject: Re: [PATCH v1 net] net: stmmac: removed enabling eee in EEE set
 callback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923085614.8147-1-weifeng.voon@intel.com>
References: <20200923085614.8147-1-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:52:21 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Wed, 23 Sep 2020 16:56:14 +0800

> EEE should be only be enabled during stmmac_mac_link_up() when the
> link are up and being set up properly. set_eee should only do settings
> configuration and disabling the eee.
> 
> Without this fix, turning on EEE using ethtool will return
> "Operation not supported". This is due to the driver is in a dead loop
> waiting for eee to be advertised in the for eee to be activated but the
> driver will only configure the EEE advertisement after the eee is
> activated.
> 
> Ethtool should only return "Operation not supported" if there is no EEE
> capbility in the MAC controller.
> 
> Fixes: 8a7493e58ad6 ("net: stmmac: Fix a race in EEE enable callback")
> 
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

Please do not insert empty lines between Fixes: and other tags.  All tags
are equal and belong together in a group.

I fixed that up, applied the patch, and queued it up for -stable.

Thank you.
