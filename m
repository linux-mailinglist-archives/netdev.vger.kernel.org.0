Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16625A3FB1
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfH3Vfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:35:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42294 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbfH3Vfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:35:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1EA9D154FA03A;
        Fri, 30 Aug 2019 14:35:45 -0700 (PDT)
Date:   Fri, 30 Aug 2019 14:35:44 -0700 (PDT)
Message-Id: <20190830.143544.1550158330174645573.davem@davemloft.net>
To:     sfr@canb.auug.org.au
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, weifeng.voon@intel.com,
        boon.leong.ong@intel.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190829200546.7b9af296@canb.auug.org.au>
References: <20190829200546.7b9af296@canb.auug.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 14:35:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 29 Aug 2019 20:05:46 +1000

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 29 Aug 2019 19:49:27 +1000
> Subject: [PATCH] net: stmmac: depend on COMMON_CLK
> 
> Fixes: 190f73ab4c43 ("net: stmmac: setup higher frequency clk support for EHL & TGL")
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied.
