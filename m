Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3FD197373
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 06:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgC3EcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 00:32:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32962 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3EcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 00:32:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09BE315C50FA6;
        Sun, 29 Mar 2020 21:32:23 -0700 (PDT)
Date:   Sun, 29 Mar 2020 21:32:23 -0700 (PDT)
Message-Id: <20200329.213223.1902716730875032247.davem@davemloft.net>
To:     vee.khee.wong@intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com
Subject: Re: [PATCH 1/1] net: stmmac: Add support for VLAN Rx filtering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325005632.6626-1-vee.khee.wong@intel.com>
References: <20200325005632.6626-1-vee.khee.wong@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 21:32:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: vee.khee.wong@intel.com
Date: Wed, 25 Mar 2020 08:56:32 +0800

> From: "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>
> 
> Add support for VLAN ID-based filtering by the MAC controller for MAC
> drivers that support it. Only the 12-bit VID field is used.
> 
> Signed-off-by: Chuah, Kim Tatt <kim.tatt.chuah@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Wong, Vee Khee <vee.khee.wong@intel.com>

This doesn't apply cleanly to the current net-next tree, please
respin.
