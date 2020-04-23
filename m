Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1471E1B5296
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgDWCgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgDWCgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:36:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0323C03C1AA;
        Wed, 22 Apr 2020 19:36:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01EB9127AD5D6;
        Wed, 22 Apr 2020 19:36:02 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:36:02 -0700 (PDT)
Message-Id: <20200422.193602.1338372363623853618.davem@davemloft.net>
To:     vee.khee.wong@intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com
Subject: Re: [PATCH net-next v2 1/1] net: stmmac: Add support for VLAN
 promiscuous mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422033106.25745-1-vee.khee.wong@intel.com>
References: <20200422033106.25745-1-vee.khee.wong@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:36:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@intel.com>
Date: Wed, 22 Apr 2020 11:31:06 +0800

> From: "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>
> 
> For dwmac4, enable VLAN promiscuity when MAC controller is requested to
> enter promiscuous mode.
> 
> Signed-off-by: Chuah, Kim Tatt <kim.tatt.chuah@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Tan, Tee Min <tee.min.tan@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>

Applied, thank you.
