Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B191EEDBD
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 00:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgFDWcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 18:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgFDWcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 18:32:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEDBC08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 15:32:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6102411F5F8D1;
        Thu,  4 Jun 2020 15:32:45 -0700 (PDT)
Date:   Thu, 04 Jun 2020 15:32:42 -0700 (PDT)
Message-Id: <20200604.153242.192900616904286387.davem@davemloft.net>
To:     rohitm@chelsio.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, secdev@chelsio.com
Subject: Re: [PATCH net] crypto/chcr: error seen if
 CONFIG_CHELSIO_TLS_DEVICE isn't set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200603042813.21914-1-rohitm@chelsio.com>
References: <20200603042813.21914-1-rohitm@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 15:32:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>
Date: Wed,  3 Jun 2020 09:58:13 +0530

> cxgb4_uld_in_use() is used only by cxgb4_ktls_det_feature() which
> is under CONFIG_CHELSIO_TLS_DEVICE macro.
> 
> Fixes: a3ac249a1ab5 ("cxgb4/chcr: Enable ktls settings at run time")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Applied, thanks.
