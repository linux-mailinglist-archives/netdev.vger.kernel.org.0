Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E234F8E5
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 01:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfFVXSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 19:18:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfFVXSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 19:18:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 65EC1153A9D75;
        Sat, 22 Jun 2019 16:18:21 -0700 (PDT)
Date:   Sat, 22 Jun 2019 16:18:18 -0700 (PDT)
Message-Id: <20190622.161818.2057106264249040436.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, f.fainelli@gmail.com,
        alexandre.torgue@st.com, boon.leong.ong@intel.com
Subject: Re: [net v1] net: stmmac: set IC bit when transmitting frames with
 HW timestamp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560955308-15190-1-git-send-email-weifeng.voon@intel.com>
References: <1560955308-15190-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 16:18:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Wed, 19 Jun 2019 22:41:48 +0800

> From: Roland Hii <roland.king.guan.hii@intel.com>
> 
> When transmitting certain PTP frames, e.g. SYNC and DELAY_REQ, the
> PTP daemon, e.g. ptp4l, is polling the driver for the frame transmit
> hardware timestamp. The polling will most likely timeout if the tx
> coalesce is enabled due to the Interrupt-on-Completion (IC) bit is
> not set in tx descriptor for those frames.
> 
> This patch will ignore the tx coalesce parameter and set the IC bit
> when transmitting PTP frames which need to report out the frame
> transmit hardware timestamp to user space.
> 
> Fixes: f748be531d70 ("net: stmmac: Rework coalesce timer and fix multi-queue races")
> Signed-off-by: Roland Hii <roland.king.guan.hii@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

Applied and queued up for -stable.
