Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A37F9B834
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436937AbfHWVbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:31:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38136 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387547AbfHWVbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 17:31:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7B981543B28F;
        Fri, 23 Aug 2019 14:31:37 -0700 (PDT)
Date:   Fri, 23 Aug 2019 14:31:37 -0700 (PDT)
Message-Id: <20190823.143137.1666289020578814960.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/2] r8152: save EEE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-311-Taiwan-albertk@realtek.com>
References: <1394712342-15778-304-Taiwan-albertk@realtek.com>
        <1394712342-15778-311-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 14:31:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 23 Aug 2019 15:33:39 +0800

> v4:
> For patch #2, remove redundant calling of "ocp_reg_write(tp, OCP_EEE_ADV, 0)".
> 
> v3:
> For patch #2, fix the mistake caused by copying and pasting.
> 
> v2:
> Adjust patch #1. The EEE has been disabled in the beginning of
> r8153_hw_phy_cfg() and r8153b_hw_phy_cfg(), so only check if
> it is necessary to enable EEE.
> 
> Add the patch #2 for the helper function.
> 
> v1:
> Saving the settings of EEE to avoid they become the default settings
> after reset_resume().

Series applied.
