Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5291155638
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 12:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgBGLAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 06:00:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40956 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgBGLAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 06:00:07 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F29FF1585ABDA;
        Fri,  7 Feb 2020 03:00:04 -0800 (PST)
Date:   Fri, 07 Feb 2020 12:00:00 +0100 (CET)
Message-Id: <20200207.120000.2189785171336183347.davem@davemloft.net>
To:     boon.leong.ong@intel.com
Cc:     netdev@vger.kernel.org, tee.min.tan@intel.com,
        weifeng.voon@intel.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, Jose.Abreu@synopsys.com,
        mcoquelin.stm32@gmail.com, alexandru.ardelean@analog.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v5 0/5] net: stmmac: general fixes for Ethernet
 functionality
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200207073105.9286-1-boon.leong.ong@intel.com>
References: <20200207073105.9286-1-boon.leong.ong@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 03:00:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>
Date: Fri,  7 Feb 2020 15:31:05 +0800

> Thanks to all feedbacks from community so far.
> 
> We updated the patch-series to below:-
 ...

Series applied and queued up for -stable.
