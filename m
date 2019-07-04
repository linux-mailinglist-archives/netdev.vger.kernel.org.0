Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C031E5FD73
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 21:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfGDTd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 15:33:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52568 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbfGDTd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 15:33:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 684F8143B8010;
        Thu,  4 Jul 2019 12:33:26 -0700 (PDT)
Date:   Thu, 04 Jul 2019 12:33:25 -0700 (PDT)
Message-Id: <20190704.123325.601746500276980665.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, alexandre.torgue@st.com,
        boon.leong.ong@intel.com
Subject: Re: [PATCH v1 net-next] net: stmmac: Enable dwmac4 jumbo frame
 more than 8KiB
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562173150-808-1-git-send-email-weifeng.voon@intel.com>
References: <1562173150-808-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jul 2019 12:33:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Thu,  4 Jul 2019 00:59:10 +0800

> From: Weifeng Voon <weifeng.voon@intel.com>
> 
> Enable GMAC v4.xx and beyond to support 16KiB buffer.
> 
> Signed-off-by: Weifeng Voon <weifeng.voon@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

Applied.
